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
package org.openmrs.module.registration.api;

import java.text.ParseException;
import java.util.List;

import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.api.OpenmrsService;
import org.openmrs.module.registration.RegistrationFee;
import org.springframework.transaction.annotation.Transactional;

/**
 * This service exposes module's core functionality. It is a Spring managed bean
 * which is configured in moduleApplicationContext.xml.
 * <p>
 * It can be accessed only via Context:<br>
 * <code>
 * Context.getService(RegistrationService.class).someMethod();
 * </code>
 * 
 * @see org.openmrs.api.context.Context
 */
@Transactional
public interface RegistrationService extends OpenmrsService {

	// REGISTRATION FEE
	/**
	 * Save registration fee
	 * 
	 * @param fee
	 * @return
	 */
	public RegistrationFee saveRegistrationFee(RegistrationFee fee);

	/**
	 * Get registration fee by id
	 * 
	 * @param id
	 * @return
	 */
	public RegistrationFee getRegistrationFee(Integer id);

	/**
	 * Get list of registration fee
	 * 
	 * @param patient
	 * @param numberOfLastDate
	 *            <b>null</b> to search all time
	 * @return
	 * @throws ParseException
	 */
	public List<RegistrationFee> getRegistrationFees(Patient patient, Integer numberOfLastDate) throws ParseException;

	/**
	 * Delete a registration fee
	 * 
	 * @param fee
	 */
	public void deleteRegistrationFee(RegistrationFee fee);

	// PERSON ATTRIBUTE
	public List<PersonAttribute> getPersonAttribute(PersonAttributeType type, String value);

	/*
	 * ENCOUNTER
	 */

	/**
	 * Get last encounter
	 * 
	 * @param patient
	 * @return
	 */
	public Encounter getLastEncounter(Patient patient);

	// ghanshya,3-july-2013 #1962 Create validation for length of Health ID and
	// National ID
	public int getNationalId(String nationalId);

	public int getNationalId(Integer patientId, String nationalId);

	public int getHealthId(String healthId);

	public int getHealthId(Integer patientId, String healthId);

	public int getPassportNumber(String passportNumber);

	public int getPassportNumber(Integer patientId, String passportNumber);
}