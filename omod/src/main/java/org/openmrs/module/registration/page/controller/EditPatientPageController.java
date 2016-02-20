package org.openmrs.module.registration.page.controller;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.DocumentException;
import org.jaxen.JaxenException;
import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.util.HospitalCoreUtils;
import org.openmrs.module.registration.includable.validator.attribute.PatientAttributeValidatorService;
import org.openmrs.module.registration.util.RegistrationConstants;
import org.openmrs.module.registration.util.RegistrationUtils;
import org.openmrs.module.registration.web.controller.util.PatientModel;
import org.openmrs.module.registration.web.controller.util.RegistrationWebUtils;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.text.ParseException;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * @author Stanslaus Odhiambo
 *         Created on 2/3/2016.
 *         This class ais the controller method that handles a patient revisit case where the patient details are to be changed
 *         from the currently stored details
 */
public class EditPatientPageController {
    private static Log logger = LogFactory.getLog(EditPatientPageController.class);

    /**
     * Controller method to handle all the get requests on the editPatient view
     *
     * @param patientId - The id of the patient whose details are to be edited
     * @param model     PageModel object used to pass attributes back to the view when it's rendered
     * @throws JaxenException
     * @throws DocumentException
     * @throws IOException
     * @throws ParseException
     */
    public void get(@RequestParam("patientId") Integer patientId, PageModel model) throws JaxenException, DocumentException,
            IOException, ParseException {
        HospitalCoreService hospitalCoreService = (HospitalCoreService) Context.getService(HospitalCoreService.class);
        Patient patient = Context.getPatientService().getPatient(patientId);
        PatientModel patientModel = new PatientModel(patient);
        model.addAttribute("patient", patientModel);
        RegistrationWebUtils.getAddressDta(model);
        model.addAttribute("religionList", RegistrationWebUtils.getReligionConcept());
        PersonAttributeType personAttributeReligion = hospitalCoreService.getPersonAttributeTypeByName("Religion");
        model.addAttribute("personAttributeReligion", personAttributeReligion);
        PersonAttributeType personAttributeChiefdom = hospitalCoreService.getPersonAttributeTypeByName("Chiefdom");
        model.addAttribute("personAttributeChiefdom", personAttributeChiefdom);
        model.addAttribute("status", "success");
        model.addAttribute("message", "none");

        //
        model.addAttribute(
                "payingCategory",
                RegistrationWebUtils
                        .getSubConceptsWithName(RegistrationConstants.CONCEPT_NAME_PAYING_CATEGORY));
        model.addAttribute(
                "nonPayingCategory",
                RegistrationWebUtils
                        .getSubConceptsWithName(RegistrationConstants.CONCEPT_NAME_NONPAYING_CATEGORY));
        model.addAttribute(
                "specialScheme",
                RegistrationWebUtils
                        .getSubConceptsWithName(RegistrationConstants.CONCEPT_NAME_SPECIAL_SCHEME));
        model.addAttribute(
                "universities",
                RegistrationWebUtils
                        .getSubConceptsWithName(RegistrationConstants.CONCEPT_NAME_LIST_OF_UNIVERSITIES));
        Map<Integer, String> payingCategoryMap = new LinkedHashMap<Integer, String>();
        Concept payingCategory = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_PAYING_CATEGORY);
        for (ConceptAnswer ca : payingCategory.getAnswers()) {
            payingCategoryMap.put(ca.getAnswerConcept().getConceptId(), ca.getAnswerConcept().getName().getName());
        }
        Map<Integer, String> nonPayingCategoryMap = new LinkedHashMap<Integer, String>();
        Concept nonPayingCategory = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_NONPAYING_CATEGORY);
        for (ConceptAnswer ca : nonPayingCategory.getAnswers()) {
            nonPayingCategoryMap.put(ca.getAnswerConcept().getConceptId(), ca.getAnswerConcept().getName().getName());
        }
        Map<Integer, String> specialSchemeMap = new LinkedHashMap<Integer, String>();
        Concept specialScheme = Context.getConceptService().getConcept(RegistrationConstants.CONCEPT_NAME_SPECIAL_SCHEME);
        for (ConceptAnswer ca : specialScheme.getAnswers()) {
            specialSchemeMap.put(ca.getAnswerConcept().getConceptId(), ca.getAnswerConcept().getName().getName());
        }
        model.addAttribute("payingCategoryMap", payingCategoryMap);
        model.addAttribute("nonPayingCategoryMap", nonPayingCategoryMap);
        model.addAttribute("specialSchemeMap", specialSchemeMap);
    }

    /**
     *
     * @param patientId The id of the patient whose details are edited
     * @param request HttpServletRequest object that holds payload from the form when the form is submitted
     * @param model PageModel object that holds the attributes
     * @param uiUtils Helps with formatting
     * @return
     * @throws ParseException
     */
    public String post(@RequestParam("patientId") Integer patientId,
                              HttpServletRequest request, PageModel model, UiUtils uiUtils) throws ParseException {

        Patient patient = Context.getPatientService().getPatient(patientId);

        // list all parameter submitted
        Map<String, String> parameters = RegistrationWebUtils
                .optimizeParameters(request);
        logger.info("Submited parameters: " + parameters);

        try {
            // update patient
            Patient updatedPatient = generatePatient(patient, parameters);
            patient = Context.getPatientService().savePatient(updatedPatient);

            // update patient attribute
            updatedPatient = setAttributes(patient, parameters);
            patient = Context.getPatientService().savePatient(updatedPatient);
            RegistrationUtils.savePatientSearch(patient);

            model.addAttribute("status", "success");
            logger.info(String.format("Updated patient [id=%s]",
                    patient.getId()));
        } catch (Exception e) {
            e.printStackTrace();
//            model.addAttribute("status", "error");
//            model.addAttribute("message", e.getMessage());
//            String s = "redirect:" + uiUtils.pageLink("registration", "editPatient?patientId="+patientId);
//            return s;
        }

        String s = "redirect:" + uiUtils.pageLink("registration", "patientRegistration");
        return s;
    }
    /**
     * Generate Patient From Parameters
     *
     * @param parameters
     * @return
     * @throws ParseException
     */
    private Patient generatePatient(Patient patient,
                                    Map<String, String> parameters) throws ParseException {

        // get person name
        if (!StringUtils.isBlank(parameters
                .get(RegistrationConstants.FORM_FIELD_PATIENT_SURNAME))
                && !StringUtils
                .isBlank(parameters
                        .get(RegistrationConstants.FORM_FIELD_PATIENT_FIRSTNAME))) {
            RegistrationUtils
                    .getPersonName(
                            patient.getPersonName(),
                            parameters
                                    .get(RegistrationConstants.FORM_FIELD_PATIENT_SURNAME),
                            parameters
                                    .get(RegistrationConstants.FORM_FIELD_PATIENT_FIRSTNAME),
                            parameters
                                    .get(RegistrationConstants.FORM_FIELD_PATIENT_OTHERNAME));
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
            RegistrationUtils
                    .getPersonAddress(
                            patient.getPersonAddress(),
                            parameters
                                    .get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_POSTALADDRESS),
                            parameters
                                    .get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_DISTRICT),
                            parameters
                                    .get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_UPAZILA),
                            parameters
                                    .get(RegistrationConstants.FORM_FIELD_PATIENT_ADDRESS_LOCATION));
        }

        return patient;
    }

    private Patient setAttributes(Patient patient,
                                  Map<String, String> attributes) throws Exception {
        PatientAttributeValidatorService validator = new PatientAttributeValidatorService();
        Map<String, Object> parameters = HospitalCoreUtils.buildParameters(
                "patient", patient, "attributes", attributes);
        String validateResult = validator.validate(parameters);
        logger.info("Attirubte validation: " + validateResult);
        if (StringUtils.isBlank(validateResult)) {
            for (String name : attributes.keySet()) {
                if ((name.contains(".attribute."))
                        && (!StringUtils.isBlank(attributes.get(name)))) {
                    String[] parts = name.split("\\.");
                    String idText = parts[parts.length - 1];
                    Integer id = Integer.parseInt(idText);
                    PersonAttribute attribute = RegistrationUtils
                            .getPersonAttribute(id, attributes.get(name));
                    patient.addAttribute(attribute);
                }
            }
        } else {
            throw new Exception(validateResult);
        }

        return patient;
    }
}
