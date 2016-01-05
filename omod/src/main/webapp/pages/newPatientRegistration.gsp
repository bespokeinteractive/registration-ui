<% ui.decorateWith("appui", "standardEmrPage", [title: "Patient Registration"]) %>
<% 
	ui.includeCss("registration", "onepcssgrid.css")
%>

<openmrs:require privilege="Add Patients" otherwise="/login.htm" redirect="/findPatient.htm" />

<%
	def hospitalName = context.administrationService.getGlobalProperty("hospitalcore.hospitalName")
%>
<br/>

<style>	
		body {
			margin-top: 20px;
		}

		.col1, .col2, .col3, .col4, .col5, .col6, .col7, .col8, .col9, .col10, .col11, .col12 {
			background: #fff;
			color: #801255;
			text-align: left;
			//padding: 20px 0;
		}

		@media all and (max-width: 768px) {
			.onerow {
				margin: 0 0 100px;
			}
		}
</style>

<script type="text/javascript">

	// Hospital name
	hospitalName = "${hospitalName}";

	// Districts
	var _districts = new Array();
	${districts}.eachWithIndex{district,ix ->
		_districts[ix] = district;	
	}
	

	
	// Upazilas
	var _upazilas = new Array();
	${upazilas}.eachWithIndex{upazila,i ->
		_districts[i] = upazila;	
	}
	
	
	var _payingCategoryMap = new Array();
	
	${payingCategoryMap}.eachWithIndex{entry,i ->
		_payingCategoryMap[entry.key] = entry.value;
	
	}
	
	
	var _nonPayingCategoryMap = new Array();
	${nonPayingCategoryMap}.eachWithIndex{entry,i ->
		_nonPayingCategoryMap[entry.key] = entry.value;		
	}
	

	
	var _specialSchemeMap = new Array();
	${specialSchemeMap}.eachWithIndex{entry,i ->
		_specialSchemeMap[entry.key] = entry.value;
	
	
	/**
	 ** MODEL FROM CONTROLLER
	 **/
	MODEL = {
		patientIdentifier: "${patientIdentifier}",
		districts: _districts,
		upazilas: _upazilas,
		////ghanshyam,16-dec-2013,3438 Remove the interdependency
		TRIAGE: "${TRIAGE}",
		OPDs: "${OPDs}",
		SPECIALCLINIC: "${SPECIALCLINIC}",
		payingCategory: "${payingCategory}",
		nonPayingCategory: "${nonPayingCategory}",
		specialScheme: "${specialScheme}",
		payingCategoryMap: _payingCategoryMap,
		nonPayingCategoryMap: _nonPayingCategoryMap,
		specialSchemeMap: _specialSchemeMap,
		universities: "${universities}",
		referredFrom: "${referralHospitals}",
		referralType: "${referralReasons}",
		TEMPORARYCAT: "${TEMPORARYCAT}",
		religions: "${religionList}"
	}
</script>

<div class="onepcssgrid-1000">

${ ui.includeFragment("registration", "newPatientRegistrationForm") }

</div>




