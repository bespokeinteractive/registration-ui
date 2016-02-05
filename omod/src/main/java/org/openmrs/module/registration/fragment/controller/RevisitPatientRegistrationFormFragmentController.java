package org.openmrs.module.registration.fragment.controller;

import org.apache.commons.lang.StringUtils;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.matcher.*;
import org.openmrs.module.hospitalcore.util.HospitalCoreConstants;
import org.openmrs.module.registration.PatientWrapper;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

/**
 * @author Stanslaus Odhiambo
 *         Created on 2/1/2016.
 *         This class represents the backing controller for the Revisit Patient Scenario. Contains the actions for checking the list of
 *         patients etc
 */

public class RevisitPatientRegistrationFormFragmentController {
    /**
     * The default controller method that handles the GET and POST requests if none is provided in this controller
     */
    public void controller() {
        //do nothing
    }

    public List<SimpleObject> searchPatient(
            @RequestParam(value = "phrase", required = false) String phrase,
            @RequestParam(value = "currentPage", required = false) Integer currentPage,
            @RequestParam(value = "pageSize", required = false) Integer pageSize,
            UiUtils uiUtils,
            HttpServletRequest request) {
        String prefix = Context.getAdministrationService().getGlobalProperty(
                HospitalCoreConstants.PROPERTY_IDENTIFIER_PREFIX);
//        model.addAttribute("prefix", prefix);
        if (phrase.contains("-") && !phrase.contains(prefix)) {
            phrase = prefix + phrase;
        }

        String gender = request.getParameter("gender");
        if (gender.equalsIgnoreCase("any"))
            gender = null;
        Integer age = getInt(request.getParameter("age"));
        Integer ageRange = getInt(request.getParameter("ageRange"));
        String relativeName = request.getParameter("relativeName");
        String date = request.getParameter("date");
        Integer dateRange = getInt(request.getParameter("dateRange"));

        HospitalCoreService hcs = (HospitalCoreService) Context
                .getService(HospitalCoreService.class);
        List<Patient> patients = hcs.searchPatient(phrase, gender, age,
                ageRange, date, dateRange, relativeName);
        List<PatientWrapper> wrapperList = patientsWithLastVisit(patients);

        return SimpleObject.fromCollection(wrapperList, uiUtils, "patientId", "wrapperIdentifier", "names", "age", "gender","formartedVisitDate");
    }

    // Filter patient list using advance search criteria
    private List<Patient> filterPatients(HttpServletRequest request,
                                         List<Patient> patients) throws NumberFormatException,
            ParseException {

        List<Patient> filteredPatients = patients;

        // filter using gender
        String genderCriterion = request.getParameter("gender");
        if (!StringUtils.isBlank(genderCriterion)) {
            filteredPatients = select(filteredPatients, new GenderMatcher(
                    new String(genderCriterion)));
        }

        // filter using age criteria
        String ageCriterion = request.getParameter("age");
        if (!StringUtils.isBlank(ageCriterion)) {
            String ageRange = request.getParameter("ageRange");
            try {
                filteredPatients = select(filteredPatients, new AgeMatcher(
                        new Integer(ageCriterion), new Integer(ageRange)));
            } catch (Exception e) {
                e.printStackTrace();
                throw new NumberFormatException("advancesearch.error.age");
            }
        }

        // filter using relative name
        String relativeNameCriterion = request.getParameter("relativeName");
        if (!StringUtils.isBlank(relativeNameCriterion)) {
            filteredPatients = select(filteredPatients,
                    new RelativeNameMatcher(relativeNameCriterion));
        }

        // filter using date of visit
        String dateCriterion = request.getParameter("date");
        if (!StringUtils.isBlank(dateCriterion)) {
            try {
                String dateRange = request.getParameter("dateRange");
                filteredPatients = select(filteredPatients, new DateMatcher(
                        dateCriterion, new Integer(dateRange)));
            } catch (Exception e) {
                e.printStackTrace();
                throw new NumberFormatException("advancesearch.error.date");
            }
        }

        return filteredPatients;
    }

    // paging
    private List<Patient> pagePatient(List<Patient> patients, int currentPage,
                                      int pageSize) {
        int firstIndex = pageSize * currentPage;
        List<Patient> page = new ArrayList<Patient>();
        for (int i = firstIndex; i < (currentPage + 1) * pageSize; i++) {
            if (i < patients.size()) {
                page.add(patients.get(i));
            }
        }
        return page;
    }

    private List<PatientWrapper> patientsWithLastVisit(List<Patient> patients){
        HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
        List<PatientWrapper> wrappers = new ArrayList<PatientWrapper>();
        for (Patient patient : patients) {
            wrappers.add(new PatientWrapper(patient, hcs.getLastVisitTime(patient)));
        }
        return  wrappers;
    }


    private List<Patient> select(List<Patient> patients, Matcher matcher) {
        List<Patient> result = new ArrayList<Patient>();
        for (Patient patient : patients) {
            if (matcher.matches(patient)) {
                result.add(patient);
            }
        }
        return result;
    }

    private Integer getInt(String value) {
        try {
            Integer number = Integer.parseInt(value);
            return number;
        } catch (Exception e) {
            return 0;
        }
    }
}
