package org.openmrs.module.registration.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.util.GlobalPropertyUtil;
import org.openmrs.module.hospitalcore.util.ObsUtils;
import org.openmrs.module.registration.RegistrationFee;
import org.openmrs.module.registration.api.RegistrationService;
import org.openmrs.module.registration.util.RegistrationConstants;
import org.openmrs.module.registration.util.RegistrationUtils;
import org.openmrs.module.registration.web.controller.util.PatientModel;
import org.openmrs.module.registration.web.controller.util.RegistrationWebUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @author Stanslaus Odhiambo
 *         Created on 1/14/2016.
 */
public class ShowPatientInfoPageController {
    private static Log logger = LogFactory.getLog(ShowPatientInfoPageController.class);

    public void controller(){

    }

    public void get(@RequestParam("patientId") Integer patientId,
                      @RequestParam(value = "encounterId", required = false) Integer encounterId,
                      @RequestParam(value = "revisit", required = false) Boolean revisit,
                      @RequestParam(value = "reprint", required = false) Boolean reprint, PageModel model)
            throws IOException, ParseException {
        Patient patient = Context.getPatientService().getPatient(patientId);
        HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
        PatientModel patientModel = new PatientModel(patient);
        model.addAttribute("patient", patientModel);
        model.addAttribute("MEDICOLEGALCASE", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_MEDICO_LEGAL_CASE));
        // Get current date
        SimpleDateFormat sdf = new SimpleDateFormat("EEE dd/MM/yyyy kk:mm");
        model.addAttribute("currentDateTime", sdf.format(new Date()));

        // Get patient registration fee
        if (GlobalPropertyUtil.getInteger(RegistrationConstants.PROPERTY_NUMBER_OF_DATE_VALIDATION, 0) > 0) {
            List<RegistrationFee> fees = Context.getService(RegistrationService.class).getRegistrationFees(patient,
                    GlobalPropertyUtil.getInteger(RegistrationConstants.PROPERTY_NUMBER_OF_DATE_VALIDATION, 0));
            if (!CollectionUtils.isEmpty(fees)) {
                RegistrationFee fee = fees.get(0);
                Calendar dueDate = Calendar.getInstance();
                dueDate.setTime(fee.getCreatedOn());
                dueDate.add(Calendar.DATE, 30);
                model.addAttribute("dueDate", RegistrationUtils.formatDate(dueDate.getTime()));
                model.addAttribute("daysLeft", dateDiff(dueDate.getTime(), new Date()));
            }
        }

        // Get selected OPD room if this is the first time of visit
        if (encounterId != null) {
            List<PersonAttribute> pas = hcs.getPersonAttributes(patientId);
            for (PersonAttribute pa : pas) {
                PersonAttributeType attributeType = pa.getAttributeType();
                PersonAttributeType personAttributePaymentCategory = hcs.getPersonAttributeTypeByName("Payment Category");
                if (attributeType.getPersonAttributeTypeId() == personAttributePaymentCategory.getPersonAttributeTypeId()) {
                    model.addAttribute("selectedPaymentCategory", pa.getValue());
                }
            }

            Encounter encounter = Context.getEncounterService().getEncounter(encounterId);
            for (Obs obs : encounter.getObs()) {
                if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_TRIAGE)) {
                    model.addAttribute("selectedTRIAGE", obs.getValueCoded().getConceptId());
                }
                if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_OPD_WARD)) {
                    model.addAttribute("selectedOPD", obs.getValueCoded().getConceptId());
                }
                if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_SPECIAL_CLINIC)) {
                    model.addAttribute("selectedSPECIALCLINIC", obs.getValueCoded().getConceptId());
                }

                if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_MEDICO_LEGAL_CASE)) {
                    model.addAttribute("selectedMLC", obs.getValueCoded().getConceptId());
                }

                if (obs.getConcept().getDisplayString().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_REGISTRATION_FEE)) {
                    double regFee = obs.getValueNumeric();
                    int regFeeToInt = (int) regFee;
                    model.addAttribute("registrationFee", regFeeToInt);
                }

            }
            Boolean firstTimeVisit = true;
            model.addAttribute("firstTimeVisit", firstTimeVisit);
            model.addAttribute("typeOfSlip", "Registration Receipt");
        }

        if ((revisit != null) && revisit) {
            model.addAttribute("typeOfSlip", "Registration Receipt");

            SimpleDateFormat spf = new SimpleDateFormat("dd/MM/yyyy");
            String sef = spf.format(hcs.getLastVisitTime(patient));
            System.out.println("patient created day visit" + hcs.getLastVisitTime(patient));
            System.out.println("patient created day " + sef);
            String stf = spf.format(new Date());
            System.out.println("patient prevuois day visit" + spf.format(new Date()));
            System.out.println("prevuois day visit" + stf);
            //model.addAttribute("currentDateTime",stf );
            int value = stf.compareTo(sef);
            System.out.println("****" + value);
            model.addAttribute("create", value);
        }

        // If reprint, get the latest registration encounter
        if ((reprint != null) && reprint) {

            model.addAttribute("typeOfSlip", "Duplicate Slip");
            SimpleDateFormat spf = new SimpleDateFormat("dd/MM/yyyy");
            String sef = spf.format(hcs.getLastVisitTime(patient));
            String srf = spf.format(patient.getDateCreated());
            System.out.println("patient created day visit" + hcs.getLastVisitTime(patient));
            System.out.println("patient created day " + patient.getDateCreated());
            System.out.println("patient created day " + sef);
            String stf = spf.format(new Date());
            System.out.println("patient prevuois day visit" + spf.format(new Date()));
            System.out.println("prevuois day visit" + stf);
            //model.addAttribute("currentDateTime",stf );
            int value = stf.compareTo(sef);
            int values = stf.compareTo(srf);
            System.out.println("****" + value);
            System.out.println("****" + values);
            model.addAttribute("create", value);
            model.addAttribute("creates", values);
            model.addAttribute("currentDateTime", sdf.format(hcs.getLastVisitTime(patient)));

            Encounter encounter = Context.getService(RegistrationService.class).getLastEncounter(patient);
            if (encounter != null) {
                Map<Integer, String> observations = new HashMap<Integer, String>();

                for (Obs obs : encounter.getAllObs()) {
                    if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_TRIAGE)) {
                        model.addAttribute("selectedTRIAGE", obs.getValueCoded().getConceptId());
                    }
                    if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_OPD_WARD)) {
                        model.addAttribute("selectedOPD", obs.getValueCoded().getConceptId());
                    }
                    if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_SPECIAL_CLINIC)) {
                        model.addAttribute("selectedSPECIALCLINIC", obs.getValueCoded().getConceptId());
                    }

                    if (obs.getConcept().getName().getName().equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_MEDICO_LEGAL_CASE)) {
                        model.addAttribute("selectedMLC", obs.getValueCoded().getConceptId());
                    }
                    if (obs.getConcept().getDisplayString()
                            .equalsIgnoreCase(RegistrationConstants.CONCEPT_NAME_REGISTRATION_FEE)) {
                        double regFee = obs.getValueNumeric();
                        int regFeeToInt = (int) regFee;

                        model.addAttribute("registrationFee", regFeeToInt);
                    }
                    observations.put(obs.getConcept().getConceptId(), ObsUtils.getValueAsString(obs));
                }
                model.addAttribute("observations", observations);
                List<PersonAttribute> pas = hcs.getPersonAttributes(patientId);
                for (PersonAttribute pa : pas) {
                    PersonAttributeType attributeType = pa.getAttributeType();
                    PersonAttributeType personAttributePaymentCategory = hcs.getPersonAttributeTypeByName("Payment Category");
                    if (attributeType.getPersonAttributeTypeId() == personAttributePaymentCategory.getPersonAttributeTypeId()) {
                        model.addAttribute("selectedPaymentCategory", pa.getValue());
                    }
                }
            }
        }

        User user = Context.getAuthenticatedUser();
        model.addAttribute("reVisitFee", GlobalPropertyUtil.getString(RegistrationConstants.PROPERTY_REVISIT_REGISTRATION_FEE, ""));
        model.addAttribute("childLessThanFiveYearRegistrationFee", GlobalPropertyUtil.getString(RegistrationConstants.PROPERTY_CHILDLESSTHANFIVEYEAR_REGISTRATION_FEE, ""));
        model.addAttribute("specialClinicRegFee", GlobalPropertyUtil.getString(RegistrationConstants.PROPERTY_SPECIALCLINIC_REGISTRATION_FEE, ""));
        model.addAttribute("TRIAGE", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_TRIAGE));
        model.addAttribute("OPDs", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_OPD_WARD));
        model.addAttribute("SPECIALCLINIC", RegistrationWebUtils.getSubConcepts(RegistrationConstants.CONCEPT_NAME_SPECIAL_CLINIC));
        model.addAttribute("user", user);
       // return "/module/registration/patient/showPatientInfo";
    }


    /**
     * Get date diff betwwen 2 dates
     *
     * @param d1
     * @param d2
     * @return
     */
    private long dateDiff(Date d1, Date d2) {
        long diff = Math.abs(d1.getTime() - d2.getTime());
        return (diff / (1000 * 60 * 60 * 24));
    }


}
