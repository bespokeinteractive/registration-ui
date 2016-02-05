package org.openmrs.module.registration;

import org.openmrs.Patient;
import org.openmrs.Person;

import java.io.Serializable;
import java.util.Date;

/**
 * @author Stanslaus Odhiambo
 * Crated on 2/5/2016.
 * This class extends org.openmrs.Patient and allows for the addition of custom fields for the kenyan scenario
 */
public class PatientWrapper extends Patient implements Serializable {
    private Date lastVisitTime;
    private String wrapperIdentifier;

    public PatientWrapper(Date lastVisitTime) {
        this.lastVisitTime = lastVisitTime;
    }

    public PatientWrapper(Person person, Date lastVisitTime) {
        super(person);
        this.lastVisitTime = lastVisitTime;
        this.wrapperIdentifier = ((Patient)person).getPatientIdentifier().getIdentifier();
    }

    public PatientWrapper(Integer patientId, Date lastVisitTime) {
        super(patientId);
        this.lastVisitTime = lastVisitTime;
    }

    public Date getLastVisitTime() {
        return lastVisitTime;
    }

    public void setLastVisitTime(Date lastVisitTime) {
        this.lastVisitTime = lastVisitTime;
    }

    public String getWrapperIdentifier() {
        return wrapperIdentifier;
    }

    public void setWrapperIdentifier(String wrapperIdentifier) {
        this.wrapperIdentifier = wrapperIdentifier;
    }
}
