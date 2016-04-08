package org.openmrs.module.registration.page.controller;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.DocumentException;
import org.jaxen.JaxenException;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifier;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.PersonName;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.PatientDrugHistory;
import org.openmrs.module.hospitalcore.model.PatientFamilyHistory;
import org.openmrs.module.hospitalcore.model.PatientMedicalHistory;
import org.openmrs.module.hospitalcore.model.PatientPersonalHistory;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
import org.openmrs.module.hospitalcore.util.HospitalCoreUtils;
import org.openmrs.module.registration.includable.validator.attribute.PatientAttributeValidatorService;
import org.openmrs.module.registration.util.RegistrationConstants;
import org.openmrs.module.registration.util.RegistrationUtils;
import org.openmrs.module.registration.web.controller.util.RegistrationWebUtils;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

public class NewPatientRegistrationPageController {
	private static Log logger = LogFactory.getLog(NewPatientRegistrationPageController.class);

	public void get(HttpServletRequest request, PageModel model) throws JaxenException, DocumentException, IOException {
		HospitalCoreService hospitalCoreService = (HospitalCoreService) Context.getService(HospitalCoreService.class);
		model.addAttribute("patientIdentifier", RegistrationUtils.getNewIdentifier());
		model.addAttribute("referralHospitals",
				RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_FROM));
		model.addAttribute("referralReasons",
				RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_REASON_FOR_REFERRAL));
		RegistrationWebUtils.getAddressDta(model);
		model.addAttribute("TEMPORARYCAT",
				RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_MEDICO_LEGAL_CASE));
		model.addAttribute("religionList", RegistrationWebUtils.getReligionConcept());
		PersonAttributeType personAttributeReligion = hospitalCoreService.getPersonAttributeTypeByName("Religion");
		model.addAttribute("personAttributeReligion", personAttributeReligion);
		PersonAttributeType personAttributeChiefdom = hospitalCoreService.getPersonAttributeTypeByName("Chiefdom");
		model.addAttribute("personAttributeChiefdom", personAttributeChiefdom);
		model.addAttribute("TRIAGE", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_TRIAGE));
		model.addAttribute("OPDs", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_OPD_WARD));
		model.addAttribute("SPECIALCLINIC",
				RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_SPECIAL_CLINIC));
		model.addAttribute("payingCategory",
				RegistrationWebUtils.getSubConceptsWithName(RegistrationConstants.CONCEPT_NAME_PAYING_CATEGORY));
		model.addAttribute("nonPayingCategory",
				RegistrationWebUtils.getSubConceptsWithName(RegistrationConstants.CONCEPT_NAME_NONPAYING_CATEGORY));
		model.addAttribute("specialScheme",
				RegistrationWebUtils.getSubConceptsWithName(RegistrationConstants.CONCEPT_NAME_SPECIAL_SCHEME));
		model.addAttribute("universities",
				RegistrationWebUtils.getSubConceptsWithName(RegistrationConstants.CONCEPT_NAME_LIST_OF_UNIVERSITIES));
		Map<Integer, String> payingCategoryMap = new LinkedHashMap<Integer, String>();
		Concept payingCategory = Context.getConceptService()
				.getConcept(RegistrationConstants.CONCEPT_NAME_PAYING_CATEGORY);
		for (ConceptAnswer ca : payingCategory.getAnswers()) {
			payingCategoryMap.put(ca.getAnswerConcept().getConceptId(), ca.getAnswerConcept().getName().getName());
		}
		Map<Integer, String> nonPayingCategoryMap = new LinkedHashMap<Integer, String>();
		Concept nonPayingCategory = Context.getConceptService()
				.getConcept(RegistrationConstants.CONCEPT_NAME_NONPAYING_CATEGORY);
		for (ConceptAnswer ca : nonPayingCategory.getAnswers()) {
			nonPayingCategoryMap.put(ca.getAnswerConcept().getConceptId(), ca.getAnswerConcept().getName().getName());
		}
		Map<Integer, String> specialSchemeMap = new LinkedHashMap<Integer, String>();
		Concept specialScheme = Context.getConceptService()
				.getConcept(RegistrationConstants.CONCEPT_NAME_SPECIAL_SCHEME);
		for (ConceptAnswer ca : specialScheme.getAnswers()) {
			specialSchemeMap.put(ca.getAnswerConcept().getConceptId(), ca.getAnswerConcept().getName().getName());
		}
		model.addAttribute("payingCategoryMap", payingCategoryMap);
		model.addAttribute("nonPayingCategoryMap", nonPayingCategoryMap);
		model.addAttribute("specialSchemeMap", specialSchemeMap);
		model.addAttribute("initialRegFee",
				GlobalPropertyUtil.getString(RegistrationConstants.PROPERTY_INITIAL_REGISTRATION_FEE, ""));
		// model.addAttribute("mchRegFee",
		// GlobalPropertyUtil.getString(RegistrationConstants.PROPERTY_MCH_REGISTRATION_FEE,
		// ""));
		model.addAttribute("childLessThanFiveYearRegistrationFee", GlobalPropertyUtil
				.getString(RegistrationConstants.PROPERTY_CHILDLESSTHANFIVEYEAR_REGISTRATION_FEE, ""));
		model.addAttribute("specialClinicRegFee",
				GlobalPropertyUtil.getString(RegistrationConstants.PROPERTY_SPECIALCLINIC_REGISTRATION_FEE, ""));

	}

	public String post(HttpServletRequest request, PageModel model, UiUtils uiUtils) throws IOException {
		// list all parameter submitted
		Map<String, String> parameters = RegistrationWebUtils.optimizeParameters(request);
		Map<String, Object> redirectParams=new HashMap<String, Object>();
		logger.info("Submitted Parameters: " + parameters);

		Patient patient = null;
		try {
			// create patient
			patient = generatePatient(parameters);

			patient = Context.getPatientService().savePatient(patient);
			RegistrationUtils.savePatientSearch(patient);
			logger.info(String.format("Saved new patient [id=%s]", patient.getId()));

			// create encounter for the visit here
			Encounter encounter = createEncounter(patient, parameters);
			encounter = Context.getEncounterService().saveEncounter(encounter);
			redirectParams.put("status", "success");
			redirectParams.put("patientId", patient.getPatientId());
			redirectParams.put("encounterId", encounter.getId());

			model.addAttribute("status", "success");
			model.addAttribute("patientId", patient.getPatientId());
			model.addAttribute("encounterId", encounter.getId());
        } catch (Exception e) {

			e.printStackTrace();
			model.addAttribute("status", "error");
			model.addAttribute("message", e.getMessage());
		}


        String s = "redirect:" + uiUtils.pageLink("registration", "showPatientInfo", redirectParams);
        return s;

	}

	/**
	 * Generate Patient From Parameters
	 *
	 * @param parameters
	 * @return
	 * @throws Exception
	 */
	private Patient generatePatient(Map<String, String> parameters) throws Exception {

		Patient patient = new Patient();

		// get person name
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_SURNAME))
				&& !StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_FIRSTNAME))) {
			PersonName personName = RegistrationUtils.getPersonName(null,
					parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_SURNAME),
					parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_FIRSTNAME),
					parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_OTHERNAME));
			patient.addName(personName);
		}


		// get identifier
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_IDENTIFIER))) {
			PatientIdentifier identifier = RegistrationUtils
					.getPatientIdentifier(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_IDENTIFIER));
			identifier.setPreferred(true);
			patient.addIdentifier(identifier);
		}


		// get birthdate
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_BIRTHDATE))) {
			patient.setBirthdate(
					RegistrationUtils.parseDate(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_BIRTHDATE)));
			if (parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_BIRTHDATE_ESTIMATED).contains("true")) {
				patient.setBirthdateEstimated(true);
			}
		}

		// get gender
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_GENDER))) {
			patient.setGender(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_GENDER));
		}


		// get address
		if (!StringUtils.isBlank(parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_POSTALADDRESS))) {
			patient.addAddress(RegistrationUtils.getPersonAddress(null,
					parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_POSTALADDRESS),
					parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_DISTRICT),
					parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_UPAZILA),
					parameters.get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_LOCATION)));
		}

		// get custom person attribute
		PatientAttributeValidatorService validator = new PatientAttributeValidatorService();
		Map<String, Object> validationParameters = HospitalCoreUtils.buildParameters("patient", patient, "attributes",
				parameters);
		String validateResult = validator.validate(validationParameters);
		logger.info("Attribute validation: " + validateResult);
		if (StringUtils.isBlank(validateResult)) {
			for (String name : parameters.keySet()) {
				if ((name.contains(".attribute.")) && (!StringUtils.isBlank(parameters.get(name)))) {
					String[] parts = name.split("\\.");
					String idText = parts[parts.length - 1];
					Integer id = Integer.parseInt(idText);
					PersonAttribute attribute = RegistrationUtils.getPersonAttribute(id, parameters.get(name));
					patient.addAttribute(attribute);
				}
			}
		} else {
			throw new Exception(validateResult);
		}
		return patient;
	}

	/**
	 * Create Encounter For The Visit Of Patient
	 *
	 * @param patient
	 * @param parameters
	 * @return
	 */
	private Encounter createEncounter(Patient patient, Map<String, String> parameters) {

		int rooms1 = Integer.parseInt(parameters.get("rooms1"));
		int paymt1 = Integer.parseInt(parameters.get("paym_1"));
		int paymt2 = Integer.parseInt(parameters.get("paym_2"));

        int legal1 = Integer.parseInt(parameters.get("legal1"));
        String legal2 = parameters.get("patient.mlc");

        int refer1 = Integer.parseInt(parameters.get("refer1"));
        String refer2 = parameters.get("patient.referred.from");
        String refer3 = parameters.get("patient.referred.description");
        String refer4 = parameters.get("patient.referred.reason");
        String refer5 = parameters.get("patient.referred.county");
        String refer6 = parameters.get("patient.referred.facility");

        String paymt3 = null;
        String paymt4 = null;

        String tNTriage = null,oNOpd = null, sNSpecial = null,nFNumber ;
        String nPayn = null, nNotpayn = null, nScheme = null, nNHIFnumb = null, nWaivernumb = null, nUniID = null, nStuID = null ;

		switch(rooms1){
			case 1: {
                tNTriage = parameters.get("rooms2");
				break;
			}
            case 2: {
                oNOpd = parameters.get("rooms2");
                break;
            }
            case 3: {
                sNSpecial = parameters.get("rooms2");
                nFNumber= parameters.get("rooms3");
                break;
            }
		}

        switch(paymt1){
            case 1: {
                paymt3 = "Paying";
                if (paymt2 == 1){
                    nPayn = "GENERAL";
                }
                else if (paymt2 == 2){
                    nPayn = "CHILD LESS THAN 5 YEARS";
                }
                else if (paymt2 == 3){
                    nPayn = "EXPECTANT MOTHER";
                }

                break;
            }
            case 2: {
                paymt3 = "Non-Paying";

                if (paymt2 == 1){
                    nNotpayn = "NHIF CIVIL SERVANT";
                    nNHIFnumb = parameters.get("modesummary");
                }
                else if (paymt2 == 2){
                    nNotpayn = "CCC PATIENT";
                }
                else if (paymt2 == 3){
                    nNotpayn = "TB PATIENT";
                }
                else if (paymt2 == 4){
                    nNotpayn = "PRISIONER";
                }

                break;
            }
            case 3: {
                paymt3 = "Special Schemes";

                if (paymt2 == 1){
                    nUniID = parameters.get("university");
                    nStuID = parameters.get("modesummary");
                    nScheme = "STUDENT SCHEME";
                }
                else if (paymt2 == 2){
                    nWaivernumb = parameters.get("modesummary");
                    nScheme = "WAIVER CASE";
                }
                else if (paymt2 == 3){
                    nScheme = "DELIVERY CASE";
                }

                nFNumber= parameters.get("rooms3");
                break;
            }
        }






		Encounter encounter = RegistrationWebUtils.createEncounter(patient, false);

		if (!StringUtils.isBlank(tNTriage)) {
			Concept triageConcept = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_TRIAGE);

			Concept selectedTRIAGEConcept = Context.getConceptService()
					.getConcept(tNTriage);

			String selectedCategory = paymt3;
			Obs triageObs = new Obs();
			triageObs.setConcept(triageConcept);
			triageObs.setValueCoded(selectedTRIAGEConcept);
			encounter.addObs(triageObs);

			RegistrationWebUtils.sendPatientToTriageQueue(patient, selectedTRIAGEConcept, false, selectedCategory);
		} else if (!StringUtils.isBlank(oNOpd)) {
			Concept opdConcept = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_OPD_WARD);
			PatientQueueService queueService = (PatientQueueService) Context.getService(PatientQueueService.class);
			Concept selectedOPDConcept = Context.getConceptService()
					.getConcept(oNOpd);
			String selectedCategory = paymt3;
			Obs opdObs = new Obs();
			opdObs.setConcept(opdConcept);
			opdObs.setValueCoded(selectedOPDConcept);
			encounter.addObs(opdObs);

			RegistrationWebUtils.sendPatientToOPDQueue(patient, selectedOPDConcept, false, selectedCategory);
			PatientMedicalHistory patientmedical = new PatientMedicalHistory();
			patientmedical.setTriageLogId(null);
			patientmedical.setCreatedOn(new Date());
			patientmedical.setPatientId(patient.getPatientId());
			queueService.savePatientMedicalHistory(patientmedical);
			PatientDrugHistory patientdrug = new PatientDrugHistory();
			patientdrug.setTriageLogId(null);
			patientdrug.setCreatedOn(new Date());
			patientdrug.setPatientId(patient.getPatientId());
			queueService.savePatientDrugHistory(patientdrug);
			PatientFamilyHistory patientfamily = new PatientFamilyHistory();
			patientfamily.setTriageLogId(null);
			patientfamily.setCreatedOn(new Date());
			patientfamily.setPatientId(patient.getPatientId());
			queueService.savePatientFamilyHistory(patientfamily);
			PatientPersonalHistory patientperson = new PatientPersonalHistory();
			patientperson.setTriageLogId(null);
			patientperson.setCreatedOn(new Date());
			patientperson.setPatientId(patient.getPatientId());
			queueService.savePatientPersonalHistory(patientperson);
		} else {
			Concept specialClinicConcept = Context.getConceptService()
					.getConcept(RegistrationConstants.CONCEPT_NAME_SPECIAL_CLINIC);
			PatientQueueService queueService = (PatientQueueService) Context.getService(PatientQueueService.class);
			Concept selectedSpecialClinicConcept = Context.getConceptService()
					.getConcept(sNSpecial);
			String selectedCategory = paymt3;
			Obs opdObs = new Obs();
			opdObs.setConcept(specialClinicConcept);
			opdObs.setValueCoded(selectedSpecialClinicConcept);
			encounter.addObs(opdObs);

			RegistrationWebUtils.sendPatientToOPDQueue(patient, selectedSpecialClinicConcept, false, selectedCategory);
			PatientMedicalHistory patientmedical = new PatientMedicalHistory();
			patientmedical.setTriageLogId(null);
			patientmedical.setCreatedOn(new Date());
			patientmedical.setPatientId(patient.getPatientId());
			queueService.savePatientMedicalHistory(patientmedical);
			PatientDrugHistory patientdrug = new PatientDrugHistory();
			patientdrug.setTriageLogId(null);
			patientdrug.setCreatedOn(new Date());
			patientdrug.setPatientId(patient.getPatientId());
			queueService.savePatientDrugHistory(patientdrug);
			PatientFamilyHistory patientfamily = new PatientFamilyHistory();
			patientfamily.setTriageLogId(null);
			patientfamily.setCreatedOn(new Date());
			patientfamily.setPatientId(patient.getPatientId());
			queueService.savePatientFamilyHistory(patientfamily);
			PatientPersonalHistory patientperson = new PatientPersonalHistory();
			patientperson.setTriageLogId(null);
			patientperson.setCreatedOn(new Date());
			patientperson.setPatientId(patient.getPatientId());
			queueService.savePatientPersonalHistory(patientperson);

		}

        // payment category and registration fee
        Concept cnrf = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_REGISTRATION_FEE);
        Concept cnp = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NEW_PATIENT);
        Obs obsn = new Obs();
        obsn.setConcept(cnrf);
        obsn.setValueCoded(cnp);
        Double doubleVal = Double.parseDouble(parameters.get(RegistrationConstants.FORM_FIELD_REGISTRATION_FEE));
        obsn.setValueNumeric(doubleVal);
        obsn.setValueText(paymt3);
        if (paymt3.equals("Paying")) {
            obsn.setComment(nPayn);
        } else if (paymt3.equals("Non-Paying")) {
            obsn.setComment(nNotpayn);
        } else if (paymt3.equals("Special Schemes")) {
            obsn.setComment(nScheme);
        }
        encounter.addObs(obsn);

        Concept mlcConcept = Context.getConceptService()
                .getConcept(RegistrationConstants.CONCEPT_NAME_MEDICO_LEGAL_CASE);

        Obs mlcObs = new Obs();

        if (!StringUtils.isBlank(legal2)) {
            Concept selectedMlcConcept = Context.getConceptService()
                    .getConcept(legal2);
            mlcObs.setConcept(mlcConcept);
            mlcObs.setValueCoded(selectedMlcConcept);
            encounter.addObs(mlcObs);
        } /*
			 * else { mlcObs.setConcept(mlcConcept);
			 * mlcObs.setValueCoded(Context.getConceptService().getConcept(
			 * "NO")); encounter.addObs(mlcObs); }
			 */


		/*
		 * REFERRAL INFORMATION
		 */
		Obs referralObs = new Obs();
		Concept referralConcept = Context.getConceptService()
				.getConcept(RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_TO_HOSPITAL);
		referralObs.setConcept(referralConcept);
		encounter.addObs(referralObs);
		if (!StringUtils.isBlank(refer2)) {
			referralObs.setValueCoded(Context.getConceptService().getConcept("YES"));

			// referred from
			Obs referredFromObs = new Obs();
			Concept referredFromConcept = Context.getConceptService()
					.getConcept(RegistrationConstants.CONCEPT_NAME_PATIENT_REFERRED_FROM);
			referredFromObs.setConcept(referredFromConcept);
			referredFromObs.setValueCoded(Context.getConceptService().getConcept(
					Integer.parseInt(refer2)));
			encounter.addObs(referredFromObs);

			// referred reason
			Obs referredReasonObs = new Obs();
			Concept referredReasonConcept = Context.getConceptService()
					.getConcept(RegistrationConstants.CONCEPT_NAME_REASON_FOR_REFERRAL);
			referredReasonObs.setConcept(referredReasonConcept);
			referredReasonObs.setValueCoded(Context.getConceptService().getConcept(
					Integer.parseInt(refer4)));
			referredReasonObs
					.setValueText(refer3);
			encounter.addObs(referredReasonObs);

			// REFERRED FROM COUNTY
			Obs referredFromCountyObs = new Obs();
			Concept referredFromCountyConcept = Context.getConceptService()
					.getConcept(RegistrationConstants.CONCEPT_NAME_COUNTY_REFERRED_FROM);
			referredFromCountyObs.setConcept(referredFromCountyConcept);
			referredFromCountyObs
					.setValueText(refer5);
			encounter.addObs(referredFromCountyObs);

            // REFERRED FROM FACILITY
            Obs referredFacilityObs = new Obs();
            Concept referredFacilityConcept = Context.getConceptService()
                    .getConcept(RegistrationConstants.CONCEPT_NAME_FACILITY_REFERRED_FROM);
            referredFacilityObs.setConcept(referredFacilityConcept);
            referredFacilityObs
                    .setValueText(refer5);
            encounter.addObs(referredFacilityObs);
		} else {
			referralObs.setValueCoded(Context.getConceptService().getConcept("NO"));
		}
		return encounter;
	}

}
