/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.registration.api.impl;

import java.text.ParseException;
import java.util.List;

import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.api.impl.BaseOpenmrsService;
import org.openmrs.module.registration.RegistrationFee;
import org.openmrs.module.registration.api.RegistrationService;
import org.openmrs.module.registration.api.db.RegistrationDAO;


public class RegistrationServiceImpl extends BaseOpenmrsService implements
		RegistrationService {

	public RegistrationServiceImpl() {
	}

	protected RegistrationDAO dao;

	public void setDao(RegistrationDAO dao) {
		this.dao = dao;
	}

	/*
	 * REGISTRATION FEE
	 */
	public RegistrationFee saveRegistrationFee(RegistrationFee fee) {
		return dao.saveRegistrationFee(fee);
	}

	public RegistrationFee getRegistrationFee(Integer id) {
		return dao.getRegistrationFee(id);
	}

	public List<RegistrationFee> getRegistrationFees(Patient patient,
			Integer numberOfLastDate) throws ParseException {
		return dao.getRegistrationFees(patient, numberOfLastDate);
	}

	public void deleteRegistrationFee(RegistrationFee fee) {
		dao.deleteRegistrationFee(fee);
	}

	/*
	 * PERSON ATTRIBUTE
	 */
	public List<PersonAttribute> getPersonAttribute(PersonAttributeType type,
			String value) {
		return dao.getPersonAttribute(type, value);
	}

	public Encounter getLastEncounter(Patient patient) {
		return dao.getLastEncounter(patient);
	}
	

	public int getNationalId(String nationalId){
		return dao.getNationalId(nationalId);
	}
	
	public int getNationalId(Integer patientId,String nationalId){
		return dao.getNationalId(patientId,nationalId);
	}
	
	public int getHealthId(String healthId){
		return dao.getHealthId(healthId);
	}
	
	public int getHealthId(Integer patientId,String healthId){
		return dao.getHealthId(patientId,healthId);
	}
	
	public int getPassportNumber(String passportNumber){
		return dao.getPassportNumber(passportNumber);
	}
	
	public int getPassportNumber(Integer patientId,String passportNumber){
		return dao.getPassportNumber(patientId,passportNumber);
	}
	
}
