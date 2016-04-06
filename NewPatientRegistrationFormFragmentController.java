package org.openmrs.module.registration.fragment.controller;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.PatientDrugHistory;
import org.openmrs.module.hospitalcore.model.PatientFamilyHistory;
import org.openmrs.module.hospitalcore.model.PatientMedicalHistory;
import org.openmrs.module.hospitalcore.model.PatientPersonalHistory;
import org.openmrs.module.hospitalcore.util.HospitalCoreUtils;
import org.openmrs.module.registration.includable.validator.attribute.PatientAttributeValidatorService;
import org.openmrs.module.registration.util.RegistrationConstants;
import org.openmrs.module.registration.util.RegistrationUtils;
import org.openmrs.module.registration.web.controller.util.RegistrationWebUtils;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class NewPatientRegistrationFormFragmentController {
	private static Log logger = LogFactory
			.getLog(NewPatientRegistrationFormFragmentController.class);


	public void controller(){
		//place holder get method to handle the get request for now
	}
	
	
	
	public SimpleObject postPatientDetails(HttpServletRequest request, UiUtils uiUtils, FragmentModel model){
		RegistrationRequest request1 = new RegistrationRequest();
		// list all parameter submitted
		Map<String, String> parameters = RegistrationWebUtils
				.optimizeParameters(request);
		logger.info("Submited parameters: " + parameters);

		Patient patient;
		try {
			// create patient
			patient = generatePatient(parameters);
			patient = Context.getPatientService().savePatient(patient);
			RegistrationUtils.savePatientSearch(patient);
			logger.info(String.format("Saved new patient [id=%s]",
					patient.getId()));

			// create encounter for the visit
			Encounter encounter = createEncounter(patient, parameters);
			encounter = Context.getEncounterService().saveEncounter(encounter);
			logger.info(String
					.format("Saved encounter for the visit of patient [id=%s, patient=%s]",
							encounter.getId(), patient.getId()));

			model.addAttribute("status", "success");
			request1.setPatientId(patient.getPatientId());
			model.addAttribute("patientId", patient.getPatientId());
			request1.setStatus("success");
			model.addAttribute("encounterId", encounter.getId());
			request1.setEncounterId(encounter.getId());
		} catch (Exception e) {

			e.printStackTrace();
			model.addAttribute("status", "error");
			request1.setStatus("error");
			model.addAttribute("message", e.getMessage());
			request1.setMessage(e.getMessage());
		}
		//return "/module/registration/patient/savePatient";

		//make a dummy return URL for now
		//change this later
//		return "redirect:"+uiUtils.pageLink("registration", "statuses");
		return SimpleObject.create("json",request1);

	}


	/**
	 * Generate Patient From Parameters
	 *
	 * @param parameters
	 * @return
	 * @throws Exception
	 */
	private Patient generatePatient(Map<String, String> parameters)
			throws Exception {

		Patient patient = new Patient();

		// get person name
		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_FIRSTNAME))
				&& !StringUtils
				.isBlank(parameters
						.get(RegistrationConstants.FORM_FIELD_PATIENT_SURNAME))) {
			PersonName personName = RegistrationUtils
					.getPersonName(
							null,
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_FIRSTNAME),
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_OTHERNAME),
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_SURNAME));
			patient.addName(personName);
		}

		// get identifier
		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_IDENTIFIER))) {
			PatientIdentifier identifier = RegistrationUtils
					.getPatientIdentifier(parameters
							.get(RegistrationConstants.FORM_FIELD_PATIENT_IDENTIFIER));
			patient.addIdentifier(identifier);
		}

		// get birthdate
		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_BIRTHDATE))) {
			patient.setBirthdate(RegistrationUtils.parseDate(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_BIRTHDATE)));
			if (parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_BIRTHDATE_ESTIMATED)
					.contains("true")) {
				patient.setBirthdateEstimated(true);
			}
		}

		// get gender
		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_GENDER))) {
			patient.setGender(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_GENDER));
		}

		// get address
		if (!StringUtils
				.isBlank(parameters
						.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_DISTRICT))) {
			patient.addAddress(RegistrationUtils.getPersonAddress(
					null,
					parameters
							.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_POSTALADDRESS),
					parameters
							.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_DISTRICT),
					parameters
							.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_UPAZILA),
					parameters
							.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_LOCATION)));
		}

		// get custom person attribute
		PatientAttributeValidatorService validator = new PatientAttributeValidatorService();
		Map<String, Object> validationParameters = HospitalCoreUtils
				.buildParameters("patient", patient, "attributes", parameters);
		String validateResult = validator.validate(validationParameters);
		logger.info("Attirubte validation: " + validateResult);
		if (StringUtils.isBlank(validateResult)) {
			for (String name : parameters.keySet()) {
				if ((name.contains(".attribute."))
						&& (!StringUtils.isBlank(parameters.get(name)))) {
					String[] parts = name.split("\\.");
					String idText = parts[parts.length - 1];
					Integer id = Integer.parseInt(idText);
					PersonAttribute attribute = RegistrationUtils
							.getPersonAttribute(id, parameters.get(name));
					patient.addAttribute(attribute);
				}
			}
		} else {
			throw new Exception(validateResult);
		}

		return patient;
	}

	/**
	 * Create Encouunter For The Visit Of Patient
	 *
	 * @param patient
	 * @param parameters
	 * @return
	 */
	private Encounter createEncounter(Patient patient,
									  Map<String, String> parameters) {

		Encounter encounter = RegistrationWebUtils.createEncounter(patient,
				false);

		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_TRIAGE))) {
			Concept triageConcept = Context.getConceptService().getConcept(
					RegistrationConstants.CONCEPT_NAME_TRIAGE);

			Concept selectedTRIAGEConcept = Context
					.getConceptService()
					.getConcept(
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_TRIAGE));
			String selectedCategory=parameters.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY);
			Obs triageObs = new Obs();
			triageObs.setConcept(triageConcept);
			triageObs.setValueCoded(selectedTRIAGEConcept);
			encounter.addObs(triageObs);

			RegistrationWebUtils.sendPatientToTriageQueue(patient,
					selectedTRIAGEConcept, false, selectedCategory);
		} else if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_OPD_WARD))) {
			Concept opdConcept = Context.getConceptService().getConcept(
					RegistrationConstants.CONCEPT_NAME_OPD_WARD);
			PatientQueueService queueService = (PatientQueueService) Context.getService(PatientQueueService.class);
			Concept selectedOPDConcept = Context
					.getConceptService()
					.getConcept(
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_OPD_WARD));
			String selectedCategory=parameters.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY);
			Obs opdObs = new Obs();
			opdObs.setConcept(opdConcept);
			opdObs.setValueCoded(selectedOPDConcept);
			encounter.addObs(opdObs);

			RegistrationWebUtils.sendPatientToOPDQueue(patient,
					selectedOPDConcept, false, selectedCategory);
			PatientMedicalHistory patientmedical= new PatientMedicalHistory();
			patientmedical.setTriageLogId(null);
			patientmedical.setCreatedOn(new Date());
			patientmedical.setPatientId(patient.getPatientId());
			queueService.savePatientMedicalHistory(patientmedical);
			PatientDrugHistory patientdrug= new PatientDrugHistory();
			patientdrug.setTriageLogId(null);
			patientdrug.setCreatedOn(new Date());
			patientdrug.setPatientId(patient.getPatientId());
			queueService.savePatientDrugHistory(patientdrug);
			PatientFamilyHistory patientfamily= new PatientFamilyHistory();
			patientfamily.setTriageLogId(null);
			patientfamily.setCreatedOn(new Date());
			patientfamily.setPatientId(patient.getPatientId());
			queueService.savePatientFamilyHistory(patientfamily);
			PatientPersonalHistory patientperson= new PatientPersonalHistory();
			patientperson.setTriageLogId(null);
			patientperson.setCreatedOn(new Date());
			patientperson.setPatientId(patient.getPatientId());
			queueService.savePatientPersonalHistory(patientperson);
		}else {
			Concept specialClinicConcept = Context.getConceptService().getConcept(
					RegistrationConstants.CONCEPT_NAME_SPECIAL_CLINIC);
			PatientQueueService queueService = (PatientQueueService) Context.getService(PatientQueueService.class);
			Concept selectedSpecialClinicConcept = Context
					.getConceptService()
					.getConcept(
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_SPECIAL_CLINIC));
			String selectedCategory=parameters.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY);
			Obs opdObs = new Obs();
			opdObs.setConcept(specialClinicConcept);
			opdObs.setValueCoded(selectedSpecialClinicConcept);
			encounter.addObs(opdObs);

			RegistrationWebUtils.sendPatientToOPDQueue(patient,
					selectedSpecialClinicConcept, false, selectedCategory);
			PatientMedicalHistory patientmedical= new PatientMedicalHistory();
			patientmedical.setTriageLogId(null);
			patientmedical.setCreatedOn(new Date());
			patientmedical.setPatientId(patient.getPatientId());
			queueService.savePatientMedicalHistory(patientmedical);
			PatientDrugHistory patientdrug= new PatientDrugHistory();
			patientdrug.setTriageLogId(null);
			patientdrug.setCreatedOn(new Date());
			patientdrug.setPatientId(patient.getPatientId());
			queueService.savePatientDrugHistory(patientdrug);
			PatientFamilyHistory patientfamily= new PatientFamilyHistory();
			patientfamily.setTriageLogId(null);
			patientfamily.setCreatedOn(new Date());
			patientfamily.setPatientId(patient.getPatientId());
			queueService.savePatientFamilyHistory(patientfamily);
			PatientPersonalHistory patientperson= new PatientPersonalHistory();
			patientperson.setTriageLogId(null);
			patientperson.setCreatedOn(new Date());
			patientperson.setPatientId(patient.getPatientId());
			queueService.savePatientPersonalHistory(patientperson);

		}

		//payment category and registration fee
		Concept cnrf = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_REGISTRATION_FEE);
		Concept cnp = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NEW_PATIENT);
		Obs obsn = new Obs();
		obsn.setConcept(cnrf);
		obsn.setValueCoded(cnp);
		Double doubleVal = Double.parseDouble(parameters
				.get(RegistrationConstants.FORM_FIELD_REGISTRATION_FEE));
		obsn.setValueNumeric(doubleVal);
		obsn.setValueText(parameters
				.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY));
		if (parameters.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY).equals("Paying")) {
			obsn.setComment(parameters
					.get(RegistrationConstants.FORM_FIELD_PAYING_CATEGORY));
		}
		else if (parameters.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY).equals("Non-Paying")) {
			obsn.setComment(parameters
					.get(RegistrationConstants.FORM_FIELD_NONPAYING_CATEGORY));
		}
		else if (parameters.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY).equals("Special Schemes")) {
			obsn.setComment(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_SPECIAL_SCHEME));
		}
		encounter.addObs(obsn);



		Concept mlcConcept = Context.getConceptService().getConcept(
				RegistrationConstants.CONCEPT_NAME_MEDICO_LEGAL_CASE);

		Obs mlcObs = new Obs();
		if (!StringUtils
				.isBlank(parameters
						.get(RegistrationConstants.FORM_FIELD_PATIENT_MLC))) {
			Concept selectedMlcConcept = Context
					.getConceptService()
					.getConcept(
							parameters
									.get(RegistrationConstants.FORM_FIELD_PATIENT_MLC));
			mlcObs.setConcept(mlcConcept);
			mlcObs.setValueCoded(selectedMlcConcept);
			encounter.addObs(mlcObs);
		}/* else {
			mlcObs.setConcept(mlcConcept);
			mlcObs.setValueCoded(Context.getConceptService().getConcept(
					"NO"));
			encounter.addObs(mlcObs);
		}*/

		/*
		 * REFERRAL INFORMATION
		 */
		Obs referralObs = new Obs();
		Concept referralConcept = Context
				.getConceptService()
				.getConcept(
						RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_TO_HOSPITAL);
		referralObs.setConcept(referralConcept);
		encounter.addObs(referralObs);
		if (!StringUtils.isBlank(parameters
				.get(RegistrationConstants.FORM_FIELD_PATIENT_REFERRED_FROM))) {
			referralObs.setValueCoded(Context.getConceptService().getConcept(
					"YES"));

			// referred from
			Obs referredFromObs = new Obs();
			Concept referredFromConcept = Context
					.getConceptService()
					.getConcept(
							RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_FROM);
			referredFromObs.setConcept(referredFromConcept);
			referredFromObs
					.setValueCoded(Context
							.getConceptService()
							.getConcept(
									Integer.parseInt(parameters
											.get(RegistrationConstants.FORM_FIELD_PATIENT_REFERRED_FROM))));
			encounter.addObs(referredFromObs);

			// referred reason
			Obs referredReasonObs = new Obs();
			Concept referredReasonConcept = Context
					.getConceptService()
					.getConcept(
							RegistrationConstants.CONCEPT_NAME_REASON_FOR_REFERRAL);
			referredReasonObs.setConcept(referredReasonConcept);
			referredReasonObs
					.setValueCoded(Context
							.getConceptService()
							.getConcept(
									Integer.parseInt(parameters
											.get(RegistrationConstants.FORM_FIELD_PATIENT_REFERRED_REASON))));
			referredReasonObs.setValueText(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_REFERRED_DESCRIPTION));
			encounter.addObs(referredReasonObs);
		} else {
			referralObs.setValueCoded(Context.getConceptService().getConcept(
					"NO"));
		}
		return encounter;
	}

	public SimpleObject savePatientInfo(@RequestParam("patientId") Integer patientId,
								@RequestParam(value = "encounterId", required = false) Integer encounterId,
								// @RequestParam(value = "regFeeValue", required = false) Double selectedRegFeeValue,
								HttpServletRequest request, HttpServletResponse response) throws ParseException, IOException {

		Map<String, String> parameters = RegistrationWebUtils.optimizeParameters(request);
		System.out.println("these are the parameters:" + parameters);

		// get patient
		Patient patient = Context.getPatientService().getPatient(patientId);

		/*
		 * SAVE ENCOUNTER
		 */
		Encounter encounter = null;
		if (encounterId != null) {
			encounter = Context.getEncounterService().getEncounter(encounterId);
			/*
				Concept cnrf = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_REGISTRATION_FEE);
				Concept cnp = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NEW_PATIENT);
				Obs obsn = new Obs();
				obsn.setConcept(cnrf);
				obsn.setValueCoded(cnp);
				obsn.setValueNumeric(selectedRegFeeValue);
				obsn.setValueText(selectedPaymentCategory);
				encounter.addObs(obsn);
				*/
			HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
			Obs obs=hcs.getObs(Context.getPersonService().getPerson(patient), encounter);
			//obs.setValueNumeric(selectedRegFeeValue);
		} else {
			encounter = RegistrationWebUtils.createEncounter(patient, true);

			if (!StringUtils.isBlank(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_TRIAGE))) {
				Concept triageConcept = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_TRIAGE);
				Concept selectedTRIAGEConcept = Context.getConceptService().getConcept(
						Integer.parseInt(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_TRIAGE)));
				String selectedCategory=parameters.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY);
				Obs triage = new Obs();
				triage.setConcept(triageConcept);
				triage.setValueCoded(selectedTRIAGEConcept);
				encounter.addObs(triage);

				// send patient to triage room
				RegistrationWebUtils.sendPatientToTriageQueue(patient, selectedTRIAGEConcept, true ,selectedCategory);
			}
			else if (!StringUtils.isBlank(parameters
					.get(RegistrationConstants.FORM_FIELD_PATIENT_OPD_WARD))) {
				Concept opdConcept = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_OPD_WARD);
				Concept selectedOPDConcept = Context.getConceptService().getConcept(
						Integer.parseInt(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_OPD_WARD)));
				String selectedCategory=parameters.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY);
				Obs opd = new Obs();
				opd.setConcept(opdConcept);
				opd.setValueCoded(selectedOPDConcept);
				encounter.addObs(opd);

				// send patient to opd room
				RegistrationWebUtils.sendPatientToOPDQueue(patient, selectedOPDConcept, true ,selectedCategory);
			}
			else{
				Concept specialClinicConcept = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_SPECIAL_CLINIC);
				Concept selectedSpecialClinicConcept = Context.getConceptService().getConcept(
						Integer.parseInt(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_SPECIAL_CLINIC)));
				String selectedCategory=parameters.get(RegistrationConstants.FORM_FIELD_PAYMENT_CATEGORY);
				Obs opd = new Obs();
				opd.setConcept(specialClinicConcept);
				opd.setValueCoded(selectedSpecialClinicConcept);
				encounter.addObs(opd);

				// send patient to special clinic
				RegistrationWebUtils.sendPatientToOPDQueue(patient, selectedSpecialClinicConcept, true ,selectedCategory);
			}

			Concept mlcConcept = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_MEDICO_LEGAL_CASE);

			Obs mlc = new Obs();
			if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_MLC))){
				Concept selectedMlcConcept = Context.getConceptService().getConcept(
						Integer.parseInt(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_MLC)));

				mlc.setConcept(mlcConcept);
				mlc.setValueCoded(selectedMlcConcept);
				encounter.addObs(mlc);
			}
			/*else {
				mlc.setConcept(mlcConcept);
				mlc.setValueCoded(Context.getConceptService().getConcept("NO"));
				encounter.addObs(mlc);
			}*/
			Concept cnrffr = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_REGISTRATION_FEE);
			Concept cr = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_REVISIT);
			Double doubleVal = Double.parseDouble(parameters.get(RegistrationConstants.FORM_FIELD_REGISTRATION_FEE));
			Obs obsr = new Obs();
			obsr.setConcept(cnrffr);
			obsr.setValueCoded(cr);
			obsr.setValueNumeric(doubleVal);
			obsr.setValueText(parameters.get(RegistrationConstants.FORM_FIELD_SELECTED_PAYMENT_CATEGORY));
			obsr.setComment(parameters.get(RegistrationConstants.FORM_FIELD_SELECTED_PAYMENT_SUBCATEGORY));
			HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
			List<PersonAttribute> pas = hcs.getPersonAttributes(patientId);
			for (PersonAttribute pa : pas) {
				PersonAttributeType attributeType = pa.getAttributeType();
				PersonAttributeType personAttributePaymentCategory=hcs.getPersonAttributeTypeByName("Paying Category Type");
				if(attributeType.getPersonAttributeTypeId()==personAttributePaymentCategory.getPersonAttributeTypeId()){
					obsr.setComment(pa.getValue());
				}
			}
			encounter.addObs(obsr);

		}

		try {
			// update patient
			Patient updatedPatient = generatePatient(patient, parameters);
			patient = Context.getPatientService().savePatient(updatedPatient);

			// update patient attribute
			updatedPatient = setAttributes(patient, parameters);
			patient = Context.getPatientService().savePatient(updatedPatient);
			RegistrationUtils.savePatientSearch(patient);
		}
		catch (Exception e) {
		}

		// create temporary attributes
		/*
		for (String name : parameters.keySet()) {
			if ((name.contains(".attribute.")) && (!StringUtils.isBlank(parameters.get(name)))) {
				String[] parts = name.split("\\.");
				String idText = parts[parts.length - 1];
				Integer id = Integer.parseInt(idText);

				//ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
				Concept concept = Context.getConceptService().getConcept(id);
				String conname=concept.getName().toString();

				if(conname.equals("REGISTRATION FEE")){
					Obs registrationFeeAttribute = new Obs();
					registrationFeeAttribute.setConcept(concept);
					registrationFeeAttribute .setValueAsString(parameters.get(name));
					encounter.addObs(registrationFeeAttribute);
				}

				if(conname.equals("REGISTRATION FEE FREE REASON")){
					Obs registrationFeeFreeReasonAttribute = new Obs();
					registrationFeeFreeReasonAttribute.setConcept(concept);
					registrationFeeFreeReasonAttribute.setValueAsString(parameters.get(name));
					encounter.addObs(registrationFeeFreeReasonAttribute);
				}

				if(conname.equals("MEDICO LEGAL CASE")){
					Obs temporaryAttribute = new Obs();
					temporaryAttribute.setConcept(concept);
					temporaryAttribute.setValueAsString(parameters.get(name));
					encounter.addObs(temporaryAttribute);
				}


			}

		}
		*/

		// save encounter
		Context.getEncounterService().saveEncounter(encounter);
		//logger.info(String.format("Save encounter for the visit of patient [encounterId=%s, patientId=%s]",encounter.getId(), patient.getId()));

//		response.setContentType("text/html;charset=UTF-8");
//		PrintWriter out = response.getWriter();
//		out.print("success");
		ReturnObject object = new ReturnObject();
		object.setStatus("success");

		return SimpleObject.create("json",object);
	}

	private Patient generatePatient(Patient patient, Map<String, String> parameters) throws ParseException {
		return patient;
	}

	private Patient setAttributes(Patient patient, Map<String, String> attributes) throws Exception {
		PatientAttributeValidatorService validator = new PatientAttributeValidatorService();
		Map<String, Object> parameters = HospitalCoreUtils.buildParameters("patient", patient, "attributes", attributes);
		String validateResult = validator.validate(parameters);
		logger.info("Attirubte validation: " + validateResult);
		if (StringUtils.isBlank(validateResult)) {
			for (String name : attributes.keySet()) {
				if ((name.contains(".attribute.")) && (!StringUtils.isBlank(attributes.get(name)))) {
					String[] parts = name.split("\\.");
					String idText = parts[parts.length - 1];
					Integer id = Integer.parseInt(idText);
					PersonAttribute attribute = RegistrationUtils.getPersonAttribute(id, attributes.get(name));
					patient.addAttribute(attribute);
				}
			}
		} else {
			throw new Exception(validateResult);
		}

		return patient;
	}






}

class ReturnObject{
	String status;

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}
