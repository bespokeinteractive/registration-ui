jQuery(document).ready(
			function() {
				
				// Hospital name
				hospitalName = "${hospitalName}";

				// Districts	
				var _districts = new Array();
				${districts}.eachWithIndex{district,i ->
					_districts[i] = district;	
				}

				
				// Upazilas
				var _upazilas = new Array();
				${upazilas}.eachWithIndex{upazila,i ->
					_upazilas[i] = upazila;	
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
				
				
				
				
				
				jQuery("#patientRegistrationForm").fillForm(
						"patient.identifier==" + MODEL.patientIdentifier);
				jQuery('#calendar').datepicker({
					yearRange : 'c-100:c+100',
					dateFormat : 'dd/mm/yy',
					changeMonth : true,
					changeYear : true
				});
				jQuery('#birthdate').change(PAGE.checkBirthDate);
				MODEL.religions = "Religion, |" + MODEL.religions;
				PAGE.fillOptions("#patientReligion", {
					data : MODEL.religions,
					delimiter : ",",
					optionDelimiter : "|"
				});
				PAGE.fillOptions("#districts", {
					data : MODEL.districts
				});
				PAGE.fillOptions("#upazilas", {
					data : typeof(MODEL.upazilas[0])=="undefined"?MODEL.upazilas:MODEL.upazilas[0].split(',')
				});
				
			selectedDistrict = jQuery("#districts option:checked").val();
			selectedUpazila = jQuery("#upazilas option:checked").val();
			var loc=('${location}');
			var districtArr = loc.split("@");
			for (var i = 0; i < districtArr.length; i++){
			var dis = districtArr[i];
			var subcountyArr = dis.split("/");
			if(subcountyArr[0]==selectedDistrict){
			for(var j = 1; j < subcountyArr.length; j++){
			
			var locationArr = subcountyArr[j].split(".");
			
			if(locationArr[0]==selectedUpazila){
			var _locations = new Array();
			for(var k = 1; k < locationArr.length; k++){
			_locations.push(locationArr[k]);
			
			PAGE.fillOptions("#locations", {
					data : _locations
				});
			
			   }
			  }
			 }
			}
		  }	
		  
				MODEL.payingCategory = " , |" + MODEL.payingCategory;
				PAGE.fillOptions("#payingCategory", {
					data : MODEL.payingCategory,
					delimiter : ",",
					optionDelimiter : "|"
				});
				
				MODEL.nonPayingCategory = " , |" + MODEL.nonPayingCategory;
				PAGE.fillOptions("#nonPayingCategory", {
					data : MODEL.nonPayingCategory,
					delimiter : ",",
					optionDelimiter : "|"
				});
				
				MODEL.specialScheme = ", |"	+ MODEL.specialScheme;
				PAGE.fillOptions("#specialScheme", {
					data : MODEL.specialScheme,
					delimiter : ",",
					optionDelimiter : "|"
				});
				
				MODEL.universities = " , |"	+ MODEL.universities;
				PAGE.fillOptions("#university", {
					data : MODEL.universities,
					delimiter : ",",
					optionDelimiter : "|"
				});
				
				MODEL.TRIAGE = " , |" + MODEL.TRIAGE;
				PAGE.fillOptions("#triage", {
					data : MODEL.TRIAGE,
					delimiter : ",",
					optionDelimiter : "|"
				});
				MODEL.OPDs = " , |"	+ MODEL.OPDs;
				PAGE.fillOptions("#opdWard", {
					data : MODEL.OPDs,
					delimiter : ",",
					optionDelimiter : "|"
				});
				MODEL.SPECIALCLINIC = ", |"	+ MODEL.SPECIALCLINIC;
				PAGE.fillOptions("#specialClinic", {
					data : MODEL.SPECIALCLINIC,
					delimiter : ",",
					optionDelimiter : "|"
				});
				MODEL.TEMPORARYCAT = " , |"
						+ MODEL.TEMPORARYCAT;
				PAGE.fillOptions("#mlc", {
					data : MODEL.TEMPORARYCAT,
					delimiter : ",",
					optionDelimiter : "|"
				});
							
				MODEL.referredFrom = " ,Referred From|"
						+ MODEL.referredFrom;
				PAGE.fillOptions("#referredFrom", {
					data : MODEL.referredFrom,
					delimiter : ",",
					optionDelimiter : "|"
				});
				MODEL.referralType = " ,Referral Type|"
						+ MODEL.referralType;
				PAGE.fillOptions("#referralType	", {
					data : MODEL.referralType,
					delimiter : ",",
					optionDelimiter : "|"
				});

				jQuery("#searchbox").showPatientSearchBox(
						{
							searchBoxView : hospitalName + "/registration",
							resultView : "/module/registration/patientsearch/"
									+ hospitalName + "/findCreate",
							success : function(data) {
								PAGE.searchPatientSuccess(data);
							},
							beforeNewSearch : PAGE.searchPatientBefore
						});


		
				jQuery("#payingCategoryField").hide();
				jQuery("#nonPayingCategoryField").hide();
				jQuery("#specialSchemeCategoryField").hide();
				jQuery("#nhifNumberRow").hide();
				jQuery("#universityRow").hide();
				jQuery("#studentIdRow").hide();
				jQuery("#waiverNumberRow").hide();
				jQuery("#mlc").hide();
				jQuery("#otherNationality").hide();
				jQuery("#referredFromColumn").hide();
				jQuery("#referralTypeRow").hide();
				jQuery("#referralDescriptionRow").hide();
				jQuery("#triageField").hide();
				jQuery("#opdWardField").hide();
				jQuery("#specialClinicField").hide();
				jQuery("#fileNumberField").hide();
				
				// binding
				jQuery("#paying").click(function() {
					VALIDATORS.payingCheck();
				});
				jQuery("#nonPaying").click(function() {
					VALIDATORS.nonPayingCheck();
				});
				jQuery("#specialSchemes").click(function() {
					VALIDATORS.specialSchemeCheck();
				});

				jQuery("#mlcCaseYes").click(function() {
					VALIDATORS.mlcYesCheck();
				});
				
				jQuery("#mlcCaseNo").click(function() {
					VALIDATORS.mlcNoCheck();
				});
				
				jQuery("#referredYes").click(function() {
					VALIDATORS.referredYesCheck();
				});
				
				jQuery("#referredNo").click(function() {
					VALIDATORS.referredNoCheck();
				});
				
				jQuery("#triageRoom").click(function() {
					VALIDATORS.triageRoomCheck();
				});
				
				jQuery("#opdRoom").click(function() {
					VALIDATORS.opdRoomCheck();
				});
				
				jQuery("#specialClinicRoom").click(function() {
					VALIDATORS.specialClinicRoomCheck();
				});

				jQuery("#sameAddress").click(function() {
					VALIDATORS.copyaddress();
				});

				
				// hide free reason
				
				jQuery("#calendarButton").click(function() {
					jQuery("#calendar").datepicker("show");
				});
				jQuery("#calendar").change(function() {
					jQuery("#birthdate").val(jQuery(this).val());
					PAGE.checkBirthDate();
				});
				jQuery("#birthdate").click(function() {
					jQuery("#birthdate").select();
				});
				jQuery("#patientGender").change(function() {
					VALIDATORS.genderCheck();
				});

			});

	/**
	 ** FORM
	 **/
	PAGE = {
		/** SUBMIT */
		submit : function() {

			// Capitalize fullname and relative name
			relativeNameInCaptital = StringUtils.capitalize(jQuery("#patientRelativeName").val());
			jQuery("#patientRelativeName").val(relativeNameInCaptital);

			// Validate and submit
			if (this.validateRegisterForm()) {
				jQuery("#patientRegistrationForm")
						.mask(
								"<img src='" + openmrsContextPath + "/moduleResources/hospitalcore/ajax-loader.gif" + "'/>&nbsp;");
				jQuery("#patientRegistrationForm")
						.ajaxSubmit(
								{
									success : function(responseText,
											statusText, xhr) {
										json = jQuery.parseJSON(responseText);
										if (json.status == "success") {
											window.location.href = openmrsContextPath
													+ "/module/registration/showPatientInfo.form?patientId="
													+ json.patientId
													+ "&encounterId="
													+ json.encounterId;
										} else {
											alert(json.message);
										}
										jQuery("#patientRegistrationForm")
												.unmask();
									}
								});
			}
		},
		
		checkNationalID : function() {	
		nationalId=jQuery("#patientNationalId").val();
		jQuery.ajax({
		type : "GET",
		url : getContextPath() + "/module/registration/validatenationalidandpassportnumber.form",
		data : ({
			nationalId			: nationalId
				}),
		success : function(data) {	
		jQuery("#divForNationalId").html(data);
		validateNationalID();
		   } 
         });
	   },
	   
	    checkPassportNumber : function() {	
		passportNumber=jQuery("#passportNumber").val();
		jQuery.ajax({
		type : "GET",
		url : getContextPath() + "/module/registration/validatenationalidandpassportnumber.form",
		data : ({
			passportNumber			: passportNumber
				}),
		success : function(data) {	
		jQuery("#divForpassportNumber").html(data);
		validatePassportNumber();
		   } 
         });
	   },
	   
	   //This function is not used.left for future use if required
	   checkNationalIDAndPassportNumber : function() {	
		nationalId=jQuery("#patientNationalId").val();
		passportNumber=jQuery("#passportNumber").val();
		jQuery.ajax({
		type : "GET",
		url : getContextPath() + "/module/registration/validatenationalidandpassportnumber.form",
		data : ({
			nationalId			: nationalId,
			passportNumber		: passportNumber
				}),
		success : function(data) {	
		jQuery("#validationMessage").html(data);
		validateNationalIDAndPassportNumber();
		   } 
         });
	   },
		
		/** VALIDATE BIRTHDATE */
		checkBirthDate : function() {
			jQuery
					.ajax({
						type : "GET",
						url : getContextPath()
								+ "/module/registration/ajax/processPatientBirthDate.htm",
						data : ({
							birthdate : $("#birthdate").val()
						}),
						dataType : "json",
						success : function(json) {
							if (json.error == undefined) {
								if (json.estimated == "true") {
									jQuery("#birthdateEstimated").val("true");
								} else {
									jQuery("#birthdateEstimated").val("false");
								}
								jQuery("#estimatedAge").html(json.age);
								jQuery("#estimatedAgeInYear").val(json.ageInYear);
								jQuery("#birthdate").val(json.birthdate);
								jQuery("#calendar").val(json.birthdate);

							} else {
								alert(json.error);
								jQuery("#birthdate").val("");
							}
						},
						error : function(xhr, ajaxOptions, thrownError) {
							alert(thrownError);
						}
					});
		},

		/** FILL OPTIONS INTO SELECT 
		 * option = {
		 * 		data: list of values or string
		 *		index: list of corresponding indexes
		 *		delimiter: seperator for value and label
		 *		optionDelimiter: seperator for options
		 * }
		 */
		fillOptions : function(divId, option) {
			jQuery(divId).empty();
			if (option.delimiter == undefined) {
				if (option.index == undefined) {
					jQuery.each(option.data, function(index, value) {
						if (value.length > 0) {
							jQuery(divId).append(
									"<option value='" + value + "'>" + value
											+ "</option>");
						}
					});
				} else {
					jQuery.each(option.data, function(index, value) {
						if (value.length > 0) {
							jQuery(divId).append(
									"<option value='" + option.index[index] + "'>"
											+ value + "</option>");
						}
					});
				}
			} else {
				options = option.data.split(option.optionDelimiter);
				jQuery.each(options, function(index, value) {
					values = value.split(option.delimiter);
					optionValue = values[0];
					optionLabel = values[1];
					if (optionLabel != undefined) {
						if (optionLabel.length > 0) {
							jQuery(divId).append(
									"<option value='" + optionValue + "'>"
											+ optionLabel + "</option>");
						}
					}
				});
			}
		},

		/** CHANGE DISTRICT */
		changeDistrict : function() {

			// get the list of upazilas
			upazilaList = "";
			selectedDistrict = jQuery("#districts option:checked").val();
			jQuery.each(MODEL.districts, function(index, value) {
				if (value == selectedDistrict) {
					upazilaList = MODEL.upazilas[index];
				}
			});

			// fill upazilas into upazila dropdown
			this.fillOptions("#upazilas", {
				data : upazilaList.split(",")
			});
			
			
			selectedUpazila = jQuery("#upazilas option:checked").val();
			
			var loc=('${location}');
			var districtArr = loc.split("@");
			for (var i = 0; i < districtArr.length; i++){
			var dis = districtArr[i];
			var subcountyArr = dis.split("/");
			if(subcountyArr[0]==selectedDistrict){
			for(var j = 1; j < subcountyArr.length; j++){
			
			var locationArr = subcountyArr[j].split(".");
			
			if(locationArr[0]==selectedUpazila){
			var _locations = new Array();
			for(var k = 1; k < locationArr.length; k++){
			_locations.push(locationArr[k]);
			
			PAGE.fillOptions("#locations", {
					data : _locations
				});
			
			   }
			  }
			 }
			}
		  }	
			
			
		},
		
		/** CHANGE UPAZILA */
		changeUpazila : function() {
			selectedDistrict = jQuery("#districts option:checked").val();
			selectedUpazila = jQuery("#upazilas option:checked").val();
			var loc=('${location}');
			var districtArr = loc.split("@");
			for (var i = 0; i < districtArr.length; i++){
			var dis = districtArr[i];
			var subcountyArr = dis.split("/");
			if(subcountyArr[0]==selectedDistrict){
			for(var j = 1; j < subcountyArr.length; j++){
			
			var locationArr = subcountyArr[j].split(".");
			
			if(locationArr[0]==selectedUpazila){
			var _locations = new Array();
			for(var k = 1; k < locationArr.length; k++){
			_locations.push(locationArr[k]);
			
			PAGE.fillOptions("#locations", {
					data : _locations
				});
			
			   }
			  }
			 }
			}
		  }	
		},

		/** SHOW OR HIDE REFERRAL INFO */
		toogleReferralInfo : function(obj) {
			checkbox = jQuery(obj);
			if (checkbox.is(":checked")) {
				jQuery("#referralDiv").show();
			} else {
				jQuery("#referralDiv").hide();
			}
		},

		/** CALLBACK WHEN SEARCH PATIENT SUCCESSFULLY */
		searchPatientSuccess : function(data) {
			jQuery("#numberOfFoundPatients")
					.html(
							"Similar Patients: "
									+ data.totalRow
									+ "(<a href='javascript:PAGE.togglePatientResult();'>Show/Hide</a>)");
		},

		/** CALLBACK WHEN BEFORE SEARCHING PATIENT */
		searchPatientBefore : function(data) {
			jQuery("#numberOfFoundPatients")
					.html(
							"<center><img src='" + openmrsContextPath + "/moduleResources/hospitalcore/ajax-loader.gif" + "'/></center>");
			jQuery("#patientSearchResult").hide();
		},

		/** TOGGLE PATIENT RESULT */
		togglePatientResult : function() {
			jQuery("#patientSearchResult").toggle();
		},

		/** VALIDATE FORM */
		validateRegisterForm : function() {
			
			if (StringUtils.isBlank(jQuery("#surName").val())) {
				alert("Please enter the surname of the patient");
				return false;
			}
			else{
			    value = jQuery("#surName").val();
				value = value.substr(0, 1).toUpperCase() + value.substr(1);
				jQuery("#surName").val(value);
				//if(/^[a-zA-Z0-9- ]*$/.test(value) == false) {
				if(/^[a-zA-Z- ]*$/.test(value) === false) {
					alert('Please enter surname in correct format');
					return false;
				}
				
			}
			
			if (StringUtils.isBlank(jQuery("#firstName").val())) {
				alert("Please enter the first name of the patient");
				return false;
			}
			else{
			    value = jQuery("#firstName").val();
				value = value.substr(0, 1).toUpperCase() + value.substr(1);
				jQuery("#firstName").val(value);
				//if(/^[a-zA-Z0-9- ]*$/.test(value) == false) {
				if(/^[a-zA-Z- ]*$/.test(value) === false) {
					alert("Please enter firstname in correct format");
					return false;
				}
				
			}
			
			if (!StringUtils.isBlank(jQuery("#otherName").val())) {
				value = jQuery("#otherName").val();
				value = value.substr(0, 1).toUpperCase() + value.substr(1);
				jQuery("#otherName").val(value);
				//if(/^[a-zA-Z0-9- ]*$/.test(value) == false) {
				if(/^[a-zA-Z- ]*$/.test(value) == false) {
					alert('Please enter othername in correct format');
					return false;
				}
			}

			if (StringUtils.isBlank(jQuery("#birthdate").val())) {
				alert("Please enter age or DOB of the patient");
				return false;
			} 
			
			if (jQuery("#patientGender").val() == "Any") {
				alert("Please select gender of the patient");
				return false;
			}
			else{
				var selectedPayingCategory=jQuery("#payingCategory option:checked").val();
				var selectedSpecialScheme=jQuery("#specialSchemes option:checked").val();
	             if(selectedPayingCategory=="EXPECTANT MOTHER"){
	              if(jQuery("#patientGender").val() == "M"){
	              alert("Selected Payment category is only valid for Female");
	              return false;
	              }
	           }
	           
	           if(selectedPayingCategory=="DELIVERY CASE"){
	              if(jQuery("#patientGender").val() == "M"){
	              alert("Selected Payment category is only valid for Female");
	              return false;
	              }
	           }
	           
	       } 
			
			/*if (jQuery("#maritalStatus").val() == "Marital") {
				alert("Please select marital status of the patient");
				return false;
			} */
			
			/*if (jQuery("#patientReligion").val() == "Religion") {
				alert("Please select religion of the patient");
				return false;
			} */
					
			
			if (StringUtils.isBlank(jQuery("#patientPostalAddress").val())) {
				alert("Please enter the physical address of the patient");
				return false;
			}
			else{
			if (jQuery("#patientPostalAddress").val().length>255) {
			    alert("Physical Address should not exceed more than 255 characters");
				return false;
			  }
			}

			if (jQuery("#patientGender").val() == "M" &&  jQuery("#maritalStatus").val() == "Widow") {
				alert("Widow marital status is only for Female");
				return false;
			}		

			if (jQuery("#patientGender").val() == "F" &&  jQuery("#maritalStatus").val() == "Widower") {
				alert("Widower marital status is only for Male");
				return false;
			}		
 
			if (!StringUtils.isBlank(jQuery("#patientPhoneNumber").val())) {
				if (!StringUtils.isDigit(jQuery("#patientPhoneNumber").val())) {
					alert("Please enter the patient's contact number in correct format");
					return false;
				}
			}
			
			if (!StringUtils.isBlank(jQuery("#patientEmail").val())) {
			var x=jQuery("#patientEmail").val();
			//var regExpForEmail = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
			var regExpForEmail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
			if (regExpForEmail.test(x)) {
			return true;
			}
			else {
			alert("Please enter the patient's e-mail address in correct format");
			return false;
			}
			
			}
			
			if (jQuery("#paying").attr('checked') === false
					&& jQuery("#nonPaying").attr('checked') === false
					&& jQuery("#specialSchemes").attr('checked') === false) {			
			    alert("You did not choose any of the payment categories");
				return false;
			} 
			else {
			    if (jQuery("#paying").attr('checked')) {
					if (StringUtils.isBlank(jQuery("#payingCategory").val())){
						alert("Please select the Paying Category");
						return false;
					}
					else{
					var selectedPayingCategory=jQuery("#payingCategory option:checked").val();
	                var estAge = jQuery("#estimatedAgeInYear").val();
	                if(selectedPayingCategory=="CHILD LESS THAN 5 YEARS"){
	                if(estAge<6){
	 
	                }
	                else{
	                alert("Selected Payment category is only valid for a child less than 5 years");
	                return false;
	                }
	               }
	              }
				}
			    else if (jQuery("#nonPaying").attr('checked')) {
					if (StringUtils.isBlank(jQuery("#nonPayingCategory").val())){
						alert("Please select the Non-Paying Category");
						return false;
					}
					else{
					     var selectedNonPayingCategory=jQuery("#nonPayingCategory option:checked").val();
	                     //if(MODEL.nonPayingCategoryMap[selectedNonPayingCategory]=="NHIF CIVIL SERVANT"){
	                     if(selectedNonPayingCategory=="NHIF CIVIL SERVANT"){
	                          if (StringUtils.isBlank(jQuery("#nhifNumber").val())){
						      alert("Please enter the NHIF Number");
						      return false;
					           }
	                       }
					   }
				}
				else if (jQuery("#specialSchemes").attr('checked')) {
					if (StringUtils.isBlank(jQuery("#specialScheme").val())){
						alert("Please select the Special Scheme");
						return false;
					}
					else{
					     var selectedSpecialScheme=jQuery("#specialScheme option:checked").val();
	                     //if(MODEL.specialSchemeMap[selectedSpecialScheme]=="STUDENT SCHEME"){
	                     if(selectedSpecialScheme=="STUDENT SCHEME"){
	                          if (StringUtils.isBlank(jQuery("#university").val())){
						      alert("Please select the University");
						      return false;
					          }
	                          if (StringUtils.isBlank(jQuery("#studentId").val())){
						      alert("Please enter the Student ID");
						      return false;
					           }
	                      }
	                     //if(MODEL.specialSchemeMap[selectedSpecialScheme]=="WAIVER CASE"){
	                     if(selectedSpecialScheme=="WAIVER CASE"){
	                          if (StringUtils.isBlank(jQuery("#waiverNumber").val())){
						      alert("Please enter the Waiver Number");
						      return false;
					           }
	                      }
					   }
				}
			}
			
			if (StringUtils.isBlank(jQuery("#patientRelativeName").val())) {
				alert("Please enter the patient's relative name");
				return false;
			} 
			else{
			    value = jQuery("#patientRelativeName").val();
				//value = value.substr(0, 1).toUpperCase() + value.substr(1);
				//jQuery("#patientRelativeName").val(value);
				if(/^[a-zA-Z- ]*$/.test(value) === false) {
					alert("Please enter patient's relative name in correct format");
					return false;
				}
			}
			
			if (jQuery("#relationshipType").val() == "Relationship") {
				alert("Please enter the patient's relationship type with the NOK");
				return false;
			}
			
			if (jQuery("#relativePostalAddress").val().length>255) {
			    alert("Kin Physical Address should not exceed more than 255 characters");
				return false;
			}
			
			if (jQuery("#mlcCaseYes").attr('checked') === false
					&& jQuery("#mlcCaseNo").attr('checked') === false) {			
			    alert("You did not choose any of the Medico Legal Case");
				return false;
			}
			else{
			 if (jQuery("#mlcCaseYes").is(':checked')) {
				if (StringUtils.isBlank(jQuery("#mlc").val())){
					alert("Please select the medico legal case");
					return false;
				}
			  }
			}
			
			if (jQuery("#referredYes").attr('checked') === false
					&& jQuery("#referredNo").attr('checked') === false) {			
			    alert("You did not choose any of the Referral Information");
				return false;
			} 
			else{
			
			if (jQuery("#referredYes").attr('checked')) {
			
			if (StringUtils.isBlank(jQuery("#referredFrom").val())) {
				alert("Please enter referral from of the patient");
				return false;
			   }
			 else{
			 
			 if (StringUtils.isBlank(jQuery("#referralType").val())) {
					alert("Please enter referral type of the patient");
					return false;
				} 
			 } 
			 
			 }
			  
			}	
			
			if (jQuery("#triageRoom").attr('checked') === false
				&& jQuery("#opdRoom").attr('checked') === false
				&& jQuery("#specialClinicRoom").attr('checked') === false) {			
			    alert("You did not choose any of the room");
				return false;
			} else {
			    if (jQuery("#triageRoom").attr('checked')) {
					if (StringUtils.isBlank(jQuery("#triage").val())) {
						alert("Please select the triage room to visit");
						return false;
					}
				}
				else if (jQuery("#opdRoom").attr('checked')){
				    if (StringUtils.isBlank(jQuery("#opdWard").val())) {
						alert("Please select the OPD room to visit");
						return false;
					}
				}
				else{
				    if (StringUtils.isBlank(jQuery("#specialClinic").val())) {
						alert("Please select the Special Clinic to visit");
						return false;
					}
					else{
					if (jQuery("#paying").is(':checked')) {
					payingCategorySelection();
					}
					if (jQuery("#nonPaying").is(':checked')) {
					nonPayingCategorySelection();
					}
					if (jQuery("#specialSchemes").is(':checked')) {
					specialSchemeSelection();
					}		
					}
					/*
					if (StringUtils.isBlank(jQuery("#fileNumber").val())) {
						alert("Please enter the File Number");
						return false;
					}
					*/
				}
			}
            //submitNationalIDAndPassportNumber();
            if(validateNationalIDAndPassportNumber()){
            return true;
            }
            else{
            return false;
            }
			
			return true;
		}
	};

	/**
	 ** VALIDATORS
	 **/
	VALIDATORS = {
		
		/** CHECK WHEN PAYING CATEGORY IS SELECTED */
		payingCheck : function() {
			if (jQuery("#paying").is(':checked')) {
					jQuery("#nonPaying").removeAttr("checked");
					jQuery("#payingCategoryField").show();
					jQuery("#nonPayingCategory").val("");
				    jQuery("#nonPayingCategoryField").hide();
				    jQuery("#specialScheme").val("");
				    jQuery("#specialSchemeCategoryField").hide();
				    jQuery("#specialSchemes").removeAttr("checked");
					//jQuery("#selectedRegFeeValue").val(${initialRegFee});
					
					jQuery("#nhifNumberRow").hide();
					jQuery("#universityRow").hide();
	                jQuery("#studentIdRow").hide();
	                jQuery("#waiverNumberRow").hide();
			}
			else{
			jQuery("#payingCategoryField").hide();
			}
		},
		
		/** CHECK WHEN NONPAYING CATEGORY IS SELECTED */
		nonPayingCheck : function() {
			if (jQuery("#nonPaying").is(':checked')) {
					jQuery("#paying").removeAttr("checked");
				    jQuery("#nonPayingCategoryField").show();
				    jQuery("#specialSchemes").removeAttr("checked");
				    jQuery("#payingCategory").val("");
				    jQuery("#payingCategoryField").hide();
                    jQuery("#specialScheme").val("");
				    jQuery("#specialSchemeCategoryField").hide();
					//jQuery("#selectedRegFeeValue").val(0);
					
					var selectedNonPayingCategory=jQuery("#nonPayingCategory option:checked").val();
	                //if(MODEL.nonPayingCategoryMap[selectedNonPayingCategory]==="NHIF CIVIL SERVANT"){
	                if(selectedNonPayingCategory=="NHIF CIVIL SERVANT"){
	                jQuery("#nhifNumberRow").show();
	                }
	                else{
	                jQuery("#nhifNumberRow").hide();
	                }
	                
					jQuery("#universityRow").hide();
	                jQuery("#studentIdRow").hide();
	                jQuery("#waiverNumberRow").hide();
			}
			else{
			jQuery("#nonPayingCategoryField").hide();
			jQuery("#nhifNumberRow").hide();
			}
		},
		
		/** CHECK WHEN SPECIAL SCHEME CATEGORY IS SELECTED */
		specialSchemeCheck : function() {
			if (jQuery("#specialSchemes").is(':checked')) {
					jQuery("#paying").removeAttr("checked");
					jQuery("#payingCategory").val("");
					jQuery("#payingCategoryField").hide();
					jQuery("#nonPayingCategory").val("");
					jQuery("#nonPayingCategoryField").hide();
					jQuery("#nonPaying").removeAttr("checked");
					jQuery("#specialSchemeCategoryField").show();
					//jQuery("#selectedRegFeeValue").val(0);
					
					jQuery("#nhifNumberRow").hide();
					
					var selectedSpecialScheme=jQuery("#specialScheme option:checked").val();
	                //if(MODEL.specialSchemeMap[selectedSpecialScheme]==="STUDENT SCHEME"){
	                if(selectedSpecialScheme=="STUDENT SCHEME"){
	                jQuery("#universityRow").show();
	                jQuery("#studentIdRow").show();
	                }
	                else{
	                jQuery("#universityRow").hide();
	                jQuery("#studentIdRow").hide();
	                }
	                
	                //if(MODEL.specialSchemeMap[selectedSpecialScheme]==="WAIVER CASE"){
	                if(selectedSpecialScheme=="WAIVER CASE"){
	                jQuery("#waiverNumberRow").show();
	                }
	                else{
	                jQuery("#waiverNumberRow").hide();
	                }				
			}
			else{
			jQuery("#specialSchemeCategoryField").hide();
			jQuery("#universityRow").hide();
	        jQuery("#studentIdRow").hide();
	        jQuery("#waiverNumberRow").hide();
			}
		},
		
		mlcYesCheck : function () {
			if (jQuery("#mlcCaseYes").is(':checked')) {
			        jQuery("#mlcCaseNo").removeAttr("checked");
					jQuery("#mlc").show();	
			}
			else{
			jQuery("#mlc").hide();	
			}
		},
		
		mlcNoCheck : function () {
			if (jQuery("#mlcCaseNo").is(':checked')) {
			    jQuery("#mlcCaseYes").removeAttr("checked");	
				jQuery("#mlc").hide();	
			}
		},
		
		referredYesCheck : function () {
			if (jQuery("#referredYes").is(':checked')) {
			        jQuery("#referredNo").removeAttr("checked");
					jQuery("#referredFromColumn").show();
				    jQuery("#referralTypeRow").show();
				    jQuery("#referralDescriptionRow").show();	
			}
			else{
			jQuery("#referredFromColumn").hide();
			jQuery("#referralTypeRow").hide();
			jQuery("#referralDescriptionRow").hide();
			}
		},
		
		referredNoCheck : function () {
			if (jQuery("#referredNo").is(':checked')) {
			    jQuery("#referredYes").removeAttr("checked");	
				jQuery("#referredFromColumn").hide();
				jQuery("#referralTypeRow").hide();
				jQuery("#referralDescriptionRow").hide();	
			}
		},
		
		triageRoomCheck : function () {
			if (jQuery("#triageRoom").is(':checked')) {
			        jQuery("#opdRoom").removeAttr("checked");
			        jQuery("#specialClinicRoom").removeAttr("checked");
					jQuery("#triageField").show();
					jQuery("#opdWard").val("");	
					jQuery("#opdWardField").hide();	
					jQuery("#specialClinic").val("");	
					jQuery("#specialClinicField").hide();
					jQuery("#fileNumberField").hide();
			}
			else{
			jQuery("#triageField").hide();	
			}
		},
		
		opdRoomCheck : function () {
			if (jQuery("#opdRoom").is(':checked')) {
			        jQuery("#triageRoom").removeAttr("checked");
			        jQuery("#specialClinicRoom").removeAttr("checked");
			        jQuery("#triage").val("");	
			        jQuery("#triageField").hide();
					jQuery("#opdWardField").show();	
					jQuery("#specialClinic").val("");	
					jQuery("#specialClinicField").hide();
					jQuery("#fileNumberField").hide();
			}
			else{
			jQuery("#opdWardField").hide();	
			}
		},
		
		specialClinicRoomCheck : function () {
			if (jQuery("#specialClinicRoom").is(':checked')) {
			        jQuery("#triageRoom").removeAttr("checked");
			        jQuery("#opdRoom").removeAttr("checked");
			        jQuery("#triage").val("");	
			        jQuery("#triageField").hide();
			        jQuery("#opdWard").val("");	
			        jQuery("#opdWardField").hide();
					jQuery("#specialClinicField").show();
					jQuery("#fileNumberField").show();
			}
			else{
			jQuery("#specialClinicField").hide();
			jQuery("#fileNumberField").hide();	
			}
		},

		copyaddress : function () {
			if (jQuery("#sameAddress").is(':checked')) {
				jQuery("#relativePostalAddress").val(jQuery("#patientPostalAddress").val());
				
		}
		else {		jQuery("#relativePostalAddress").val('');
		}
		},

		/*
		 * Check patient gender
		 */
		genderCheck : function() {

			jQuery("#patientRelativeNameSection").empty();
			if (jQuery("#patientGender").val() == "M") {
				jQuery("#patientRelativeNameSection")
						.html(
								'<input type="radio" name="person.attribute.15" value="Son of" checked="checked"/> Son of');
			} else if(jQuery("#patientGender").val() == "F"){
				jQuery("#patientRelativeNameSection")
						.html(
								'<input type="radio" name="person.attribute.15" value="Daughter of"/> Daughter of <input type="radio" name="person.attribute.15" value="Wife of"/> Wife of');
			}
		}
		
	};
	
	function showOtherNationality(){
	var optionValue=jQuery("#patientNation option:selected" ).text();
	if(optionValue=="Other"){
	jQuery("#otherNationality").show();
	  }
	  else{
	  jQuery("#otherNationality").hide();
	  }
	}
	
	function submitNationalID(){
	PAGE.checkNationalID();
   }
	
	function validateNationalID(){
	var nId=jQuery("#nId").val();
	if(nId=="1"){
	document.getElementById("nationalIdValidationMessage").innerHTML="Patient already registered with this National ID";
	jQuery("#nationalIdValidationMessage").show();
    return false;					
    }
    else{
    jQuery("#nationalIdValidationMessage").hide();
    }  
   }
		          
		       
   function submitPassportNumber(){
   PAGE.checkPassportNumber();
   }
   
   function validatePassportNumber(){
   var pNum=jQuery("#pNum").val();
   if(pNum=="1"){
   document.getElementById("passportNumberValidationMessage").innerHTML="Patient already registered with this Passport Number";
   jQuery("#passportNumberValidationMessage").show();
   return false;
	}
	else{
	jQuery("#passportNumberValidationMessage").hide();
	}
   }
   
   function submitNationalIDAndPassportNumber(){
   PAGE.checkNationalIDAndPassportNumber();
   }
   
   function validateNationalIDAndPassportNumber(){
   var nId=jQuery("#nId").val();
   var pNum=jQuery("#pNum").val();
   if(nId=="1" && pNum=="1"){
   //alert("Patient already registered with the same National ID and Passport Number");	
   document.getElementById("nationalIdValidationMessage").innerHTML="Patient already registered with this National ID";
   document.getElementById("passportNumberValidationMessage").innerHTML="Patient already registered with this Passport Number";
   jQuery("#nationalIdValidationMessage").show();
   jQuery("#passportNumberValidationMessage").show();
   return false;
	}
   else if(nId=="1"){
   //alert("Patient already registered with the same National ID");
   document.getElementById("nationalIdValidationMessage").innerHTML="Patient already registered with this National ID";
   jQuery("#nationalIdValidationMessage").show();
   jQuery("#passportNumberValidationMessage").hide();
   return false;					
    }  
   else if(pNum=="1"){
   //alert("Patient already registered with the same Passport Number");	
   jQuery("#nationalIdValidationMessage").hide();
   jQuery("#passportNumberValidationMessage").show();
   return false;
	}
   else{
   jQuery("#nationalIdValidationMessage").hide();
   jQuery("#passportNumberValidationMessage").hide();
   return true;
	}
   }
	
	
	function payingCategorySelection(){
	var selectedPayingCategory=jQuery("#payingCategory option:checked").val();
	 //if(MODEL.payingCategoryMap[selectedPayingCategory]=="CHILD LESS THAN 5 YEARS"){
	 var estAge = jQuery("#estimatedAgeInYear").val();
	 if(selectedPayingCategory=="CHILD LESS THAN 5 YEARS"){
	 if(estAge<6){
	  jQuery("#selectedRegFeeValue").val('${childLessThanFiveYearRegistrationFee}');
	 }
	 else{
	 alert("This category is only valid for a child less than 5 years");
	 return false;
	 }
	 }
	 else{
	  
	  if(selectedPayingCategory=="EXPECTANT MOTHER"){
	  if (jQuery("#patientGender").val() == "M"){
	  alert("This category is only valid for female");
	  }
	  }
	  
	  
	  if(jQuery("#specialClinic").val()){
	   var initialRegFee=parseInt('${initialRegFee}');
	   var specialClinicRegFee=parseInt('${specialClinicRegFee}');
	   var totalRegFee= initialRegFee+specialClinicRegFee;
	   jQuery("#selectedRegFeeValue").val(totalRegFee);
	   }
	  else{
	   jQuery("#selectedRegFeeValue").val('${initialRegFee}');
	  }
	 }
	}
	
	function nonPayingCategorySelection(){
	var selectedNonPayingCategory=jQuery("#nonPayingCategory option:checked").val();
	//if(MODEL.nonPayingCategoryMap[selectedNonPayingCategory]=="NHIF CIVIL SERVANT"){
	if(selectedNonPayingCategory=="NHIF CIVIL SERVANT"){
	jQuery("#nhifNumberRow").show();
	}
	else{
	jQuery("#nhifNumberRow").hide();
	}
	
	var selectedNonPayingCategory=jQuery("#nonPayingCategory option:checked").val();
	//if(MODEL.nonPayingCategoryMap[selectedNonPayingCategory]=="TB PATIENT" || MODEL.nonPayingCategoryMap[selectedNonPayingCategory]=="CCC PATIENT"){
	if(selectedNonPayingCategory=="TB PATIENT" || selectedNonPayingCategory=="CCC PATIENT"){
	if(jQuery("#specialClinic").val()){
	jQuery("#selectedRegFeeValue").val('${specialClinicRegFee}');
	}
	else{
	jQuery("#selectedRegFeeValue").val(0);
	}
	}
	else{
	jQuery("#selectedRegFeeValue").val(0);
	}
	
	}
	
	function specialSchemeSelection(){
	var selectedSpecialScheme=jQuery("#specialScheme option:checked").val();
	
	if(selectedSpecialScheme=="DELIVERY CASE"){
	  if (jQuery("#patientGender").val() == "M"){
	  alert("This category is only valid for female");
	  }
	  }
	  
	//if(MODEL.specialSchemeMap[selectedSpecialScheme]=="STUDENT SCHEME"){
	if(selectedSpecialScheme=="STUDENT SCHEME"){
	jQuery("#universityRow").show();
	jQuery("#studentIdRow").show();
	}
	else{
	jQuery("#universityRow").hide();
	jQuery("#studentIdRow").hide();
	}
	  
	//if(MODEL.specialSchemeMap[selectedSpecialScheme]=="WAIVER CASE"){
	if(selectedSpecialScheme=="WAIVER CASE"){
	jQuery("#waiverNumberRow").show();
	}
	else{
	jQuery("#waiverNumberRow").hide();
	}
	
	jQuery("#selectedRegFeeValue").val(0);		
	}
	
	function triageRoomSelectionFor(){
	if(jQuery("#payingCategory").val()!=" "){
    var selectedPayingCategory=jQuery("#payingCategory option:checked").val();
    if(selectedPayingCategory=="CHILD LESS THAN 5 YEARS"){
	jQuery("#selectedRegFeeValue").val('${childLessThanFiveYearRegistrationFee}');
	}
    else{
	jQuery("#selectedRegFeeValue").val('${initialRegFee}');
    }
    }
    else if(jQuery("#nonPayingCategory").val()!=" "){
	jQuery("#selectedRegFeeValue").val(0);
    }
    else if(jQuery("#specialScheme").val()!=" "){
    jQuery("#selectedRegFeeValue").val(0);
    }
	}
	
	function opdRoomSelectionForReg(){
	if(jQuery("#payingCategory").val()!=" "){
    var selectedPayingCategory=jQuery("#payingCategory option:checked").val();
    if(selectedPayingCategory=="CHILD LESS THAN 5 YEARS"){
	jQuery("#selectedRegFeeValue").val('${childLessThanFiveYearRegistrationFee}');
	}
    else{
	jQuery("#selectedRegFeeValue").val('${initialRegFee}');
    }
    }
    else if(jQuery("#nonPayingCategory").val()!=" "){
	jQuery("#selectedRegFeeValue").val(0);
    }
    else if(jQuery("#specialScheme").val()!=" "){
    jQuery("#selectedRegFeeValue").val(0);
    }
	}
	
	function specialClinicSelectionForReg(){
	if(jQuery("#payingCategory").val()!=" "){
    var selectedPayingCategory=jQuery("#payingCategory option:checked").val();
    if(selectedPayingCategory=="CHILD LESS THAN 5 YEARS"){
	jQuery("#selectedRegFeeValue").val('${childLessThanFiveYearRegistrationFee}');
	}
    else{
    var initialRegFee=parseInt('${initialRegFee}');
	var specialClinicRegFee=parseInt('${specialClinicRegFee}');
	var totalRegFee= initialRegFee+specialClinicRegFee;
	jQuery("#selectedRegFeeValue").val(totalRegFee);
    }
    }
    else if(jQuery("#nonPayingCategory").val()!=" "){
    var selectedNonPayingCategory=jQuery("#nonPayingCategory option:checked").val();
	if(selectedNonPayingCategory=="TB PATIENT" || selectedNonPayingCategory=="CCC PATIENT"){
	jQuery("#selectedRegFeeValue").val('${specialClinicRegFee}');
	}
	else{
	jQuery("#selectedRegFeeValue").val(0);
	}
    }
    else if(jQuery("#specialScheme").val()!=" "){
    jQuery("#selectedRegFeeValue").val(0);
    }
	}
