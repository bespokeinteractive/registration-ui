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

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;
import org.openmrs.Patient;
import org.openmrs.User;
import org.openmrs.api.PatientService;
import org.openmrs.api.UserService;
import org.openmrs.api.context.Context;
import org.openmrs.module.registration.RegistrationFee;
import org.openmrs.module.registration.api.impl.RegistrationServiceImpl;
import org.openmrs.test.BaseModuleContextSensitiveTest;

/**
 * Tests {@link ${RegistrationService}}.
 */
public class RegistrationServiceTest extends BaseModuleContextSensitiveTest {
	private RegistrationService registrationService;
	private PatientService patientService;
	private UserService userService;

	@Before
	public void setup() {
		patientService = Mockito.mock(PatientService.class);
		userService=Mockito.mock(UserService.class);
		registrationService = new RegistrationServiceImpl();

	}

	@Test
	public void shouldSetRegistrationFee() {
		RegistrationFee fee = new RegistrationFee();
		User user = new User();
		Patient patient=new Patient();
		fee.setCreatedBy(user);
		fee.setPatient(patient);
		
	}
}
