/**
 *  Copyright 2008 Bespoke Interactive
 *
 *  This file is part of Registration module.
 *
 *  Registration module is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  Registration module is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Registration module.  If not, see <http://www.gnu.org/licenses/>.
 *
 **/

package org.openmrs.module.registration.util;

public class RegistrationConstants {
	
	public static final String MODULE_ID = "registration";
	
	public static final String PROPERTY_FORM = MODULE_ID + ".form.patient.register";
	
	public static final String PROPERTY_IDENTIFIER_PREFIX = MODULE_ID + ".identifier_prefix";
	
	public static final String PROPERTY_PATIENT_IDENTIFIER_TYPE = MODULE_ID + ".patientIdentifierType";
	
	public static final String PROPERTY_LOCATION = MODULE_ID + ".location";
	
	public static final String PROPERTY_ENCOUNTER_TYPE_REGINIT = MODULE_ID + ".encounterType.init";
	
	public static final String PROPERTY_ENCOUNTER_TYPE_REVISIT = MODULE_ID + ".encounterType.revisit";
	
	public static final String PROPERTY_NUMBER_OF_DATE_VALIDATION = MODULE_ID + ".numberOfDateValidation";
	
	public static final String PROPERTY_INITIAL_REGISTRATION_FEE = MODULE_ID + ".initialVisitRegistrationFee";
	
	public static final String PROPERTY_MCH_REGISTRATION_FEE = MODULE_ID + ".mchRegistrationFee";
	
	public static final String PROPERTY_SPECIALCLINIC_REGISTRATION_FEE = MODULE_ID + ".specialClinicRegistrationFee";
	
	public static final String PROPERTY_CHILDLESSTHANFIVEYEAR_REGISTRATION_FEE = MODULE_ID + ".childLessThanFiveYearRegistrationFee";
	
	public static final String PROPERTY_REVISIT_REGISTRATION_FEE = MODULE_ID + ".reVisitRegistrationFee";
	
	public static final String PROPERTY_RSBY_NO_OF_PATIENT = MODULE_ID + ".patientPerRSBY";
	
	public static final String PROPERTY_BPL_NO_OF_PATIENT = MODULE_ID + ".patientPerBPL";
	
	public static final String PROPERTY_ORDER_TYPE_ID = MODULE_ID + ".bloodbankOrderTypeId";
	
	public static final String PROPERTY_BLOODBANK_OPDWARD_NAME = "bloodbank.wardName";
	
	// field names
	public static final String FORM_FIELD_PATIENT_SURNAME = "patient.surName";
	
	public static final String FORM_FIELD_PATIENT_FIRSTNAME = "patient.firstName";
	
	public static final String FORM_FIELD_PATIENT_OTHERNAME = "patient.otherName";
	
		public static final String FORM_FIELD_PAYMENT_CATEGORY = "person.attribute.14";
	
	public static final String FORM_FIELD_REGISTRATION_FEE = "patient.registration.fee";
	
	public static final String FORM_FIELD_SELECTED_PAYMENT_CATEGORY = "patient.selectedPaymentCategory";
	
	public static final String FORM_FIELD_SELECTED_PAYMENT_SUBCATEGORY = "patient.selectedPaymentSubCategory";
	
	public static final String FORM_FIELD_PATIENT_IDENTIFIER = "patient.identifier";
	
	public static final String FORM_FIELD_PATIENT_BIRTHDATE = "patient.birthdate";
	
	public static final String FORM_FIELD_PATIENT_BIRTHDATE_ESTIMATED = "patient.birthdateEstimate";
	
	public static final String FORM_FIELD_PATIENT_GENDER = "patient.gender";
	
	public static final String FORM_FIELD_PATIENT_RELIGION = "patient.religion";
	
	public static final String FORM_FIELD_PATIENT_ADDRESS_POSTALADDRESS = "patient.address.postalAddress";
	
	public static final String FORM_FIELD_PATIENT_ADDRESS_DISTRICT = "patient.address.district";
	
	public static final String FORM_FIELD_PATIENT_ADDRESS_UPAZILA = "patient.address.upazila";
	
	public static final String FORM_FIELD_PATIENT_ADDRESS_LOCATION = "patient.address.location";
	
	public static final String FORM_FIELD_PAYING_CATEGORY = "person.attribute.44";
	
	public static final String FORM_FIELD_NONPAYING_CATEGORY = "person.attribute.45";
	
	//public static final String FORM_FIELD_NHIFNUMBER = "patient.nhifNumber";
	
	public static final String FORM_FIELD_PATIENT_SPECIAL_SCHEME = "person.attribute.46";
	
	//public static final String FORM_FIELD_PATIENT_UNIVERSITY = "person.attribute.47";
	
	//public static final String FORM_FIELD_PATIENT_STUDENTID = "patient.studentId";
	
	//public static final String FORM_FIELD_PATIENT_WAIVERNUMBER = "patient.waiverNumber";
	
	public static final String FORM_FIELD_PATIENT_MLC= "patient.mlc";
	
	public static final String FORM_FIELD_PATIENT_TRIAGE = "patient.triage";
	
	public static final String FORM_FIELD_PATIENT_OPD_WARD = "patient.opdWard";
	
	public static final String FORM_FIELD_PATIENT_SPECIAL_CLINIC = "patient.specialClinic";
	
	public static final String FORM_FIELD_PATIENT_REFERRED = "patient.referred";
	
	public static final String FORM_FIELD_PATIENT_REFERRED_FROM = "patient.referred.from";
	
	public static final String FORM_FIELD_PATIENT_REFERRED_REASON = "patient.referred.reason";
	
	public static final String FORM_FIELD_PATIENT_REFERRED_DESCRIPTION= "patient.referred.description";
	
	public static final String CONCEPT_NAME_TRIAGE = "TRIAGE";
	
	public static final String CONCEPT_NAME_OPD_WARD = "OPD WARD";
	
	public static final String CONCEPT_NAME_SPECIAL_CLINIC = "SPECIAL CLINIC";
	
	public static final String CONCEPT_NAME_PAYING_CATEGORY = "PAYING CATEGORY";
	
	public static final String CONCEPT_NAME_NONPAYING_CATEGORY = "NON-PAYING CATEGORY";
	
	public static final String CONCEPT_NAME_SPECIAL_SCHEME = "SPECIAL SCHEME";
	
	public static final String CONCEPT_NAME_LIST_OF_INSURANCE = "LIST OF INSURANCE";

	public static final String CONCEPT_NAME_LIST_OF_UNIVERSITIES = "LIST OF UNIVERSITIES";

	public static final String CONCEPT_NAME_PATIENT_REFERRED_TO_HOSPITAL = "PATIENT REFERRED TO HOSPITAL?";

	public static final String CONCEPT_NAME_COUNTY_REFERRED_FROM = "COUNTY REFERRED FROM";

	public static final String CONCEPT_NAME_FACILITY_REFERRED_FROM = "FACILITY REFERRED FROM";

	public static final String CONCEPT_NAME_REASON_FOR_REFERRAL = "REASON FOR REFERRAL";
	
	public static final String CONCEPT_NAME_PATIENT_REFERRED_FROM = "PATIENT REFERRED FROM";
	
	public static final String CONCEPT_NEW_PATIENT = "New Patient";
	
	public static final String CONCEPT_REVISIT = "Revisit";
	
	public static final String CONCEPT_NAME_MEDICO_LEGAL_CASE = "MEDICO LEGAL CASE";
	
	public static final String FORM_FIELD_PATIENT_REGISTRATION_FEE_ATTRIBUTE = "patient.registration.fee.attribute";
	public static final String FORM_FIELD_PATIENT_REGISTRATION_FEE_FREE_REASON_ATTRIBUTE = "patient.registration.fee.free.reason.attribute";
	public static final String CONCEPT_NAME_REGISTRATION_FEE = "REGISTRATION FEE";
	public static final String CONCEPT_NAME_REGISTRATION_FEE_FREE_REASON = "REGISTRATION FEE FREE REASON";
	
}
