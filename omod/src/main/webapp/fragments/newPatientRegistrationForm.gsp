<script type="text/javascript">
    var MODEL;
    jQuery(document).ready(function () {

        // Districts
        var _districts = new Array();
        var districts = "${districts}";
        <% districts.each { d -> %>
        _districts.push("${d}");
        <% } %>



        // Upazilas
        var _upazilas = new Array();
        var upazilas = "${upazilas}";
        <% upazilas.each { d -> %>
        _upazilas.push("${d}");
        <% } %>


        // Paying Category Map
        var _payingCategoryMap = new Array();
        var payingCategoryMap = "${payingCategoryMap}";
        jQuery.each(payingCategoryMap, function (key, value) {
            _payingCategoryMap[key] = value;
        });


        // NonPaying Category Map
        var _nonPayingCategoryMap = new Array();
        var nonPayingCategoryMap = "${nonPayingCategoryMap}";
        jQuery.each(nonPayingCategoryMap, function (key, value) {
            _nonPayingCategoryMap[key] = value;
        });


        // Special Scheme Map
        var _specialSchemeMap = new Array();
        var specialSchemeMap = "${specialSchemeMap}";
        jQuery.each(specialSchemeMap, function (key, value) {
            _specialSchemeMap[key] = value;
        });
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


        jQuery(function () {
            jQuery("#tabs").tabs().addClass("ui-tabs-vertical ui-helper-clearfix");
            jQuery("#tabs li").removeClass("ui-corner-top").addClass("ui-corner-left");
        });

        jQuery('#birthdate').datepicker({
            yearRange: 'c-100:c',
            maxDate: '0',
            dateFormat: 'dd/mm/yy',
            changeMonth: true,
            changeYear: true,
            constrainInput: false
        }).on("change", function (dateText) {
//            display("Got change event from field "+this.value);
            jQuery("#birthdate").val(this.value);
            PAGE.checkBirthDate();
        });


        //jQuery('#birthdate').change(PAGE.checkBirthDate);
        MODEL.religions = "Religion, |"
                + MODEL.religions;
        PAGE.fillOptions("#patientReligion", {
            data: MODEL.religions,
            delimiter: ",",
            optionDelimiter: "|"
        });
        PAGE.fillOptions("#districts", {
            data: MODEL.districts
        });
        PAGE.fillOptions("#upazilas", {
            data: typeof(MODEL.upazilas[0]) == "undefined" ? MODEL.upazilas : MODEL.upazilas[0].split(',')
        });

        selectedDistrict = jQuery("#districts option:checked").val();
        selectedUpazila = jQuery("#upazilas option:checked").val();
        var loc = ('${location}');
        var districtArr = loc.split("@");
        for (var i = 0; i < districtArr.length; i++) {
            var dis = districtArr[i];
            var subcountyArr = dis.split("/");
            if (subcountyArr[0] == selectedDistrict) {
                for (var j = 1; j < subcountyArr.length; j++) {

                    var locationArr = subcountyArr[j].split(".");

                    if (locationArr[0] == selectedUpazila) {
                        var _locations = new Array();
                        for (var k = 1; k < locationArr.length; k++) {
                            _locations.push(locationArr[k]);

                            PAGE.fillOptions("#locations", {
                                data: _locations
                            });

                        }
                    }
                }
            }
        }
        ;
        MODEL.payingCategory = " , |"
                + MODEL.payingCategory;
        PAGE.fillOptions("#payingCategory", {
            data: MODEL.payingCategory,
            delimiter: ",",
            optionDelimiter: "|"
        });

        MODEL.nonPayingCategory = " , |"
                + MODEL.nonPayingCategory;
        PAGE.fillOptions("#nonPayingCategory", {
            data: MODEL.nonPayingCategory,
            delimiter: ",",
            optionDelimiter: "|"
        });

        MODEL.specialScheme = ", |"
                + MODEL.specialScheme;
        PAGE.fillOptions("#specialScheme", {
            data: MODEL.specialScheme,
            delimiter: ",",
            optionDelimiter: "|"
        });

        MODEL.universities = " , |"
                + MODEL.universities;
        PAGE.fillOptions("#university", {
            data: MODEL.universities,
            delimiter: ",",
            optionDelimiter: "|"
        });

        MODEL.TRIAGE = " , |"
                + MODEL.TRIAGE;
        PAGE.fillOptions("#triage", {
            data: MODEL.TRIAGE,
            delimiter: ",",
            optionDelimiter: "|"
        });
        MODEL.OPDs = " , |"
                + MODEL.OPDs;
        PAGE.fillOptions("#opdWard", {
            data: MODEL.OPDs,
            delimiter: ",",
            optionDelimiter: "|"
        });
        MODEL.SPECIALCLINIC = ", |"
                + MODEL.SPECIALCLINIC;
        PAGE.fillOptions("#specialClinic", {
            data: MODEL.SPECIALCLINIC,
            delimiter: ",",
            optionDelimiter: "|"
        });
        MODEL.TEMPORARYCAT = " , |"
                + MODEL.TEMPORARYCAT;
        PAGE.fillOptions("#mlc", {
            data: MODEL.TEMPORARYCAT,
            delimiter: ",",
            optionDelimiter: "|"
        });

        MODEL.referredFrom = " ,Referred From|"
                + MODEL.referredFrom;
        PAGE.fillOptions("#referredFrom", {
            data: MODEL.referredFrom,
            delimiter: ",",
            optionDelimiter: "|"
        });
        MODEL.referralType = " ,Referral Type|"
                + MODEL.referralType;
        PAGE.fillOptions("#referralType	", {
            data: MODEL.referralType,
            delimiter: ",",
            optionDelimiter: "|"
        });

        /* jQuery("#searchbox").showPatientSearchBox(
         {
         searchBoxView: hospitalName + "/registration",
         resultView: "/module/registration/patientsearch/"
         + hospitalName + "/findCreate",
         success: function (data) {
         PAGE.searchPatientSuccess(data);
         },
         beforeNewSearch: PAGE.searchPatientBefore
         });*/


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
        jQuery("#paying").click(function () {
            VALIDATORS.payingCheck();
        });
        jQuery("#nonPaying").click(function () {
            VALIDATORS.nonPayingCheck();
        });
        jQuery("#specialSchemes").click(function () {
            VALIDATORS.specialSchemeCheck();
        });

        jQuery("#mlcCaseYes").click(function () {
            VALIDATORS.mlcYesCheck();
        });

        jQuery("#mlcCaseNo").click(function () {
            VALIDATORS.mlcNoCheck();
        });

        jQuery("#referredYes").click(function () {
            VALIDATORS.referredYesCheck();
        });

        jQuery("#referredNo").click(function () {
            VALIDATORS.referredNoCheck();
        });

        jQuery("#triageRoom").click(function () {
            VALIDATORS.triageRoomCheck();
        });

        jQuery("#opdRoom").click(function () {
            VALIDATORS.opdRoomCheck();
        });

        jQuery("#specialClinicRoom").click(function () {
            VALIDATORS.specialClinicRoomCheck();
        });

        jQuery("#sameAddress").click(function () {
            VALIDATORS.copyaddress();
        });


        // hide free reason

//        jQuery("#calendarButton").click(function () {
//            jQuery("#calendar").datepicker("show");
//        });
//        jQuery("#calendar").change(function () {
//            jQuery("#birthdate").val(jQuery(this).val());
//            PAGE.checkBirthDate();
//        });
//        jQuery("#birthdate").click(function () {
//            jQuery("#birthdate").select();
//        });
//        jQuery("#patientGender").change(function () {
//            VALIDATORS.genderCheck();
//        });


        //end of doc ready
    });

    /**
     ** FORM
     **/
    PAGE = {
        /** SUBMIT */
        submit: function () {

            // Capitalize fullname and relative name
//            relativeNameInCaptital = StringUtils.capitalize(jQuery("#patientRelativeName").val());
            relativeNameInCaptital = (jQuery("#patientRelativeName").val()).toUpperCase();
            jQuery("#patientRelativeName").val(relativeNameInCaptital);

            // Validate and submit
            if (this.validateRegisterForm()) {

                jQuery("#patientRegistrationForm").submit();

                /*jQuery("#patientRegistrationForm")
                 .mask(
                 "<img src='" + '
                ${ ui.resourceLink("registration", "images/ajax-loader.gif") }' + "/>&nbsp;");


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
                 */
            }
        },

        checkNationalID: function () {
            nationalId = jQuery("#patientNationalId").val();
            jQuery.ajax({
                type: "GET",
                url: '${ ui.actionLink("registration", "registrationUtils", "main") }',
                dataType: "json",
                data: ({
                    nationalId: nationalId
                }),
                success: function (data) {
//                    jQuery("#divForNationalId").html(data);
                    validateNationalID(data);
                }
            });
        },

        checkPassportNumber: function () {
            passportNumber = jQuery("#passportNumber").val();
            jQuery.ajax({
                type: "GET",
                url: '${ ui.actionLink("registration", "registrationUtils", "main") }',
                dataType: "json",
                data: ({
                    passportNumber: passportNumber
                }),
                success: function (data) {
//                    jQuery("#divForpassportNumber").html(data);
                    validatePassportNumber(data);
                }
            });
        },

        //This function is not used.left for future use if required
        checkNationalIDAndPassportNumber: function () {
            nationalId = jQuery("#patientNationalId").val();
            passportNumber = jQuery("#passportNumber").val();
            jQuery.ajax({
                type: "GET",
                url: '${ ui.actionLink("registration", "registrationUtils", "main") }',
                dataType: "json",
                data: ({
                    nationalId: nationalId,
                    passportNumber: passportNumber
                }),
                success: function (data) {
//                    jQuery("#validationMessage").html(data);
                    validateNationalIDAndPassportNumber(data);
                }
            });
        },

        /** VALIDATE BIRTHDATE */
        checkBirthDate: function () {
            var submitted = jQuery("#birthdate").val();
            jQuery.ajax({
                type: "GET",
                url: '${ ui.actionLink("registration", "registrationUtils", "processPatientBirthDate") }',
                dataType: "json",
                data: ({
                    birthdate: submitted
                }),
                success: function (data) {
                    if (data.datemodel.error == undefined) {
                        if (data.datemodel.estimated == "true") {
                            jQuery("#birthdateEstimated").val("true")
                        } else {
                            jQuery("#birthdateEstimated").val("false");
                        }
                        jQuery("#estimatedAge").html(data.datemodel.age);
                        jQuery("#estimatedAgeInYear").val(data.datemodel.ageInYear);
                        jQuery("#birthdate").val(data.datemodel.birthdate);
                        jQuery("#calendar").val(data.datemodel.birthdate);

                    } else {
                        alert(data.datemodel.error);
                        jQuery("#birthdate").val("");
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
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
        fillOptions: function (divId, option) {
            jQuery(divId).empty();
            if (option.delimiter == undefined) {
                if (option.index == undefined) {
                    jQuery.each(option.data, function (index, value) {
                        if (value.length > 0) {
                            jQuery(divId).append(
                                    "<option value='" + value + "'>" + value
                                    + "</option>");
                        }
                    });
                } else {
                    jQuery.each(option.data, function (index, value) {
                        if (value.length > 0) {
                            jQuery(divId).append(
                                    "<option value='" + option.index[index] + "'>"
                                    + value + "</option>");
                        }
                    });
                }
            } else {
                options = option.data.split(option.optionDelimiter);
                jQuery.each(options, function (index, value) {
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
        changeDistrict: function () {

            // get the list of upazilas
            upazilaList = "";
            selectedDistrict = jQuery("#districts option:checked").val();
            jQuery.each(MODEL.districts, function (index, value) {
                if (value == selectedDistrict) {
                    upazilaList = MODEL.upazilas[index];
                }
            });

            // fill upazilas into upazila dropdown
            this.fillOptions("#upazilas", {
                data: upazilaList.split(",")
            });


            selectedUpazila = jQuery("#upazilas option:checked").val();

            var loc = ('${location}');
            var districtArr = loc.split("@");
            for (var i = 0; i < districtArr.length; i++) {
                var dis = districtArr[i];
                var subcountyArr = dis.split("/");
                if (subcountyArr[0] == selectedDistrict) {
                    for (var j = 1; j < subcountyArr.length; j++) {

                        var locationArr = subcountyArr[j].split(".");

                        if (locationArr[0] == selectedUpazila) {
                            var _locations = new Array();
                            for (var k = 1; k < locationArr.length; k++) {
                                _locations.push(locationArr[k]);

                                PAGE.fillOptions("#locations", {
                                    data: _locations
                                });

                            }
                        }
                    }
                }
            }


        },

        /** CHANGE UPAZILA */
        changeUpazila: function () {
            selectedDistrict = jQuery("#districts option:checked").val();
            selectedUpazila = jQuery("#upazilas option:checked").val();
            var loc = ('${location}');
            var districtArr = loc.split("@");
            for (var i = 0; i < districtArr.length; i++) {
                var dis = districtArr[i];
                var subcountyArr = dis.split("/");
                if (subcountyArr[0] == selectedDistrict) {
                    for (var j = 1; j < subcountyArr.length; j++) {

                        var locationArr = subcountyArr[j].split(".");

                        if (locationArr[0] == selectedUpazila) {
                            var _locations = new Array();
                            for (var k = 1; k < locationArr.length; k++) {
                                _locations.push(locationArr[k]);

                                PAGE.fillOptions("#locations", {
                                    data: _locations
                                });

                            }
                        }
                    }
                }
            }
        },

        /** SHOW OR HIDE REFERRAL INFO */
        toogleReferralInfo: function (obj) {
            checkbox = jQuery(obj);
            if (checkbox.is(":checked")) {
                jQuery("#referralDiv").show();
            } else {
                jQuery("#referralDiv").hide();
            }
        },

        /** CALLBACK WHEN SEARCH PATIENT SUCCESSFULLY */
        searchPatientSuccess: function (data) {
            jQuery("#numberOfFoundPatients")
                    .html(
                    "Similar Patients: "
                    + data.totalRow
                    + "(<a href='javascript:PAGE.togglePatientResult();'>Show/Hide</a>)");
        },

        /** CALLBACK WHEN BEFORE SEARCHING PATIENT */
        searchPatientBefore: function (data) {
            jQuery("#numberOfFoundPatients")
                    .html(
                    "<center><img src='" + openmrsContextPath + "/moduleResources/hospitalcore/ajax-loader.gif" + "'/></center>");
            jQuery("#patientSearchResult").hide();
        },

        /** TOGGLE PATIENT RESULT */
        togglePatientResult: function () {
            jQuery("#patientSearchResult").toggle();
        },

        /** VALIDATE FORM */
        validateRegisterForm: function () {

//            if (StringUtils.isBlank(jQuery("#surName").val())) {
            if (!(jQuery("#surName").val().trim())) {
                alert("Please enter the surname of the patient");
                return false;
            }
            else {
                value = jQuery("#surName").val();
                value = value.substr(0, 1).toUpperCase() + value.substr(1);
                jQuery("#surName").val(value);
                //if(/^[a-zA-Z0-9- ]*\$/.test(value) == false) {
                if (/^[a-zA-Z- ]*\$/.test(value) == false) {
                    alert('Please enter surname in correct format');
                    return false;
                }

            }

//            if (StringUtils.isBlank(jQuery("#firstName").val())) {
            if (!(jQuery("#firstName").val().trim())) {
                alert("Please enter the first name of the patient");
                return false;
            }
            else {
                value = jQuery("#firstName").val();
                value = value.substr(0, 1).toUpperCase() + value.substr(1);
                jQuery("#firstName").val(value);
                //if(/^[a-zA-Z0-9- ]*\$/.test(value) == false) {
                if (/^[a-zA-Z- ]*\$/.test(value) == false) {
                    alert("Please enter firstname in correct format");
                    return false;
                }

            }

//            if (!StringUtils.isBlank(jQuery("#otherName").val())) {
            if ((jQuery("#otherName").val())) {
                value = jQuery("#otherName").val();
                value = value.substr(0, 1).toUpperCase() + value.substr(1);
                jQuery("#otherName").val(value);
                //if(/^[a-zA-Z0-9- ]*\$/.test(value) == false) {
                if (/^[a-zA-Z- ]*\$/.test(value) == false) {
                    alert('Please enter othername in correct format');
                    return false;
                }
            }

            if (!(jQuery("#birthdate").val().trim())) {
                alert("Please enter age or DOB of the patient");
                return false;
            }

            if (jQuery("#patientGender").val() == "Any") {
                alert("Please select gender of the patient");
                return false;
            }
            else {
                var selectedPayingCategory = jQuery("#payingCategory option:checked").val();
                var selectedSpecialScheme = jQuery("#specialSchemes option:checked").val();
                if (selectedPayingCategory == "EXPECTANT MOTHER") {
                    if (jQuery("#patientGender").val() == "M") {
                        alert("Selected Payment category is only valid for Female");
                        return false;
                    }
                }

                if (selectedPayingCategory == "DELIVERY CASE") {
                    if (jQuery("#patientGender").val() == "M") {
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


//            if (StringUtils.isBlank(jQuery("#patientPostalAddress").val())) {
            if (!(jQuery("#patientPostalAddress").val().trim())) {
                alert("Please enter the physical address of the patient");
                return false;
            }
            else {
                if (jQuery("#patientPostalAddress").val().length > 255) {
                    alert("Physical Address should not exceed more than 255 characters");
                    return false;
                }
            }

            if (jQuery("#patientGender").val() == "M" && jQuery("#maritalStatus").val() == "Widow") {
                alert("Widow marital status is only for Female");
                return false;
            }

            if (jQuery("#patientGender").val() == "F" && jQuery("#maritalStatus").val() == "Widower") {
                alert("Widower marital status is only for Male");
                return false;
            }

//            if (!StringUtils.isBlank(jQuery("#patientPhoneNumber").val())) {
            if ((jQuery("#patientPhoneNumber").val().trim())) {
//                if (!StringUtils.isDigit(jQuery("#patientPhoneNumber").val())) {
                if (isNaN(jQuery("#patientPhoneNumber").val())) {
                    alert("Please enter the patient's contact number in correct format");
                    return false;
                }
            }

//            if (!StringUtils.isBlank(jQuery("#patientEmail").val())) {
            if ((jQuery("#patientEmail").val().trim())) {
                var x = jQuery("#patientEmail").val();
                var regExpForEmail =
                <%= "/^([\\w-]+(?:\\.[\\w-]+)*)@((?:[\\w-]+\\.)*\\w[\\w-]{0,66})\\.([a-z]{2,6}(?:\\.[a-z]{2})?)\$/i;" %>
                if (regExpForEmail.test(x)) {
                    return true;
                }
                else {
                    alert("Please enter the patient's e-mail address in correct format");
                    return false;
                }

            }

            if (jQuery("#paying").attr('checked') == false
                    && jQuery("#nonPaying").attr('checked') == false
                    && jQuery("#specialSchemes").attr('checked') == false) {
                alert("You did not choose any of the payment categories");
                return false;
            }
            else {
                if (jQuery("#paying").attr('checked')) {
//                    if (StringUtils.isBlank(jQuery("#payingCategory").val())) {
                    if (!(jQuery("#payingCategory").val().trim())) {
                        alert("Please select the Paying Category");
                        return false;
                    }
                    else {
                        var selectedPayingCategory = jQuery("#payingCategory option:checked").val();
                        var estAge = jQuery("#estimatedAgeInYear").val();
                        if (selectedPayingCategory == "CHILD LESS THAN 5 YEARS") {
                            if (estAge < 6) {

                            }
                            else {
                                alert("Selected Payment category is only valid for a child less than 5 years");
                                return false;
                            }
                        }
                    }
                }
                else if (jQuery("#nonPaying").attr('checked')) {
//                    if (StringUtils.isBlank(jQuery("#nonPayingCategory").val())) {
                    if (!(jQuery("#nonPayingCategory").val().trim())) {
                        alert("Please select the Non-Paying Category");
                        return false;
                    }
                    else {
                        var selectedNonPayingCategory = jQuery("#nonPayingCategory option:checked").val();
                        //if(MODEL.nonPayingCategoryMap[selectedNonPayingCategory]=="NHIF CIVIL SERVANT"){
                        if (selectedNonPayingCategory == "NHIF CIVIL SERVANT") {
//                            if (StringUtils.isBlank(jQuery("#nhifNumber").val())) {
                            if (!(jQuery("#nhifNumber").val().trim())) {
                                alert("Please enter the NHIF Number");
                                return false;
                            }
                        }
                    }
                }
                else if (jQuery("#specialSchemes").attr('checked')) {
//                    if (StringUtils.isBlank(jQuery("#specialScheme").val())) {
                    if (!(jQuery("#specialScheme").val().trim())) {
                        alert("Please select the Special Scheme");
                        return false;
                    }
                    else {
                        var selectedSpecialScheme = jQuery("#specialScheme option:checked").val();
                        //if(MODEL.specialSchemeMap[selectedSpecialScheme]=="STUDENT SCHEME"){
                        if (selectedSpecialScheme == "STUDENT SCHEME") {
//                            if (StringUtils.isBlank(jQuery("#university").val())) {
                            if (!(jQuery("#university").val().trim())) {
                                alert("Please select the University");
                                return false;
                            }
//                            if (StringUtils.isBlank(jQuery("#studentId").val())) {
                            if (!(jQuery("#studentId").val().trim())) {
                                alert("Please enter the Student ID");
                                return false;
                            }
                        }
                        //if(MODEL.specialSchemeMap[selectedSpecialScheme]=="WAIVER CASE"){
                        if (selectedSpecialScheme == "WAIVER CASE") {
//                            if (StringUtils.isBlank(jQuery("#waiverNumber").val())) {
                            if (!(jQuery("#waiverNumber").val().trim())) {
                                alert("Please enter the Waiver Number");
                                return false;
                            }
                        }
                    }
                }
            }

//            if (StringUtils.isBlank(jQuery("#patientRelativeName").val())) {
            if (!(jQuery("#patientRelativeName").val().trim())) {
                alert("Please enter the patient's relative name");
                return false;
            }
            else {
                value = jQuery("#patientRelativeName").val();
                //value = value.substr(0, 1).toUpperCase() + value.substr(1);
                //jQuery("#patientRelativeName").val(value);
                if (<%= "/^[a-zA-Z- ]*\$/" %>.
                test(value) == false
            )
                {
                    alert("Please enter patient's relative name in correct format");
                    return false;
                }
            }

            if (jQuery("#relationshipType").val() == "Relationship") {
                alert("Please enter the patient's relationship type with the NOK");
                return false;
            }

            if (jQuery("#relativePostalAddress").val().length > 255) {
                alert("Kin Physical Address should not exceed more than 255 characters");
                return false;
            }

            if (jQuery("#mlcCaseYes").attr('checked') == false
                    && jQuery("#mlcCaseNo").attr('checked') == false) {
                alert("You did not choose any of the Medico Legal Case");
                return false;
            }
            else {
                if (jQuery("#mlcCaseYes").is(':checked')) {
//                    if (StringUtils.isBlank(jQuery("#mlc").val())) {
                    if (!(jQuery("#mlc").val().trim())) {
                        alert("Please select the medico legal case");
                        return false;
                    }
                }
            }

            if (jQuery("#referredYes").attr('checked') == false
                    && jQuery("#referredNo").attr('checked') == false) {
                alert("You did not choose any of the Referral Information");
                return false;
            }
            else {

                if (jQuery("#referredYes").attr('checked')) {

//                    if (StringUtils.isBlank(jQuery("#referredFrom").val())) {
                    if (!(jQuery("#referredFrom").val().trim())) {
                        alert("Please enter referral from of the patient");
                        return false;
                    }
                    else {

//                        if (StringUtils.isBlank(jQuery("#referralType").val())) {
                        if (!(jQuery("#referralType").val().trim())) {
                            alert("Please enter referral type of the patient");
                            return false;
                        }
                    }

                }

            }

            if (jQuery("#triageRoom").attr('checked') == false
                    && jQuery("#opdRoom").attr('checked') == false
                    && jQuery("#specialClinicRoom").attr('checked') == false) {
                alert("You did not choose any of the room");
                return false;
            } else {
                if (jQuery("#triageRoom").attr('checked')) {
//                    if (StringUtils.isBlank(jQuery("#triage").val())) {
                    if (!(jQuery("#triage").val().trim())) {
                        alert("Please select the triage room to visit");
                        return false;
                    }
                }
                else if (jQuery("#opdRoom").attr('checked')) {
//                    if (StringUtils.isBlank(jQuery("#opdWard").val())) {
                    if (!(jQuery("#opdWard").val().trim())) {
                        alert("Please select the OPD room to visit");
                        return false;
                    }
                }
                else {
//                    if (StringUtils.isBlank(jQuery("#specialClinic").val())) {
                    if (!(jQuery("#specialClinic").val().trim())) {
                        alert("Please select the Special Clinic to visit");
                        return false;
                    }
                    else {
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
            if (validateNationalIDAndPassportNumber()) {
                return true;
            }
            else {
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
        payingCheck: function () {
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
            else {
                jQuery("#payingCategoryField").hide();
            }
        },

        /** CHECK WHEN NONPAYING CATEGORY IS SELECTED */
        nonPayingCheck: function () {
            if (jQuery("#nonPaying").is(':checked')) {
                jQuery("#paying").removeAttr("checked");
                jQuery("#nonPayingCategoryField").show();
                jQuery("#specialSchemes").removeAttr("checked");
                jQuery("#payingCategory").val("");
                jQuery("#payingCategoryField").hide();
                jQuery("#specialScheme").val("");
                jQuery("#specialSchemeCategoryField").hide();
                //jQuery("#selectedRegFeeValue").val(0);

                var selectedNonPayingCategory = jQuery("#nonPayingCategory option:checked").val();
                //if(MODEL.nonPayingCategoryMap[selectedNonPayingCategory]==="NHIF CIVIL SERVANT"){
                if (selectedNonPayingCategory == "NHIF CIVIL SERVANT") {
                    jQuery("#nhifNumberRow").show();
                }
                else {
                    jQuery("#nhifNumberRow").hide();
                }

                jQuery("#universityRow").hide();
                jQuery("#studentIdRow").hide();
                jQuery("#waiverNumberRow").hide();
            }
            else {
                jQuery("#nonPayingCategoryField").hide();
                jQuery("#nhifNumberRow").hide();
            }
        },

        /** CHECK WHEN SPECIAL SCHEME CATEGORY IS SELECTED */
        specialSchemeCheck: function () {
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

                var selectedSpecialScheme = jQuery("#specialScheme option:checked").val();
                //if(MODEL.specialSchemeMap[selectedSpecialScheme]==="STUDENT SCHEME"){
                if (selectedSpecialScheme == "STUDENT SCHEME") {
                    jQuery("#universityRow").show();
                    jQuery("#studentIdRow").show();
                }
                else {
                    jQuery("#universityRow").hide();
                    jQuery("#studentIdRow").hide();
                }

                //if(MODEL.specialSchemeMap[selectedSpecialScheme]==="WAIVER CASE"){
                if (selectedSpecialScheme == "WAIVER CASE") {
                    jQuery("#waiverNumberRow").show();
                }
                else {
                    jQuery("#waiverNumberRow").hide();
                }
            }
            else {
                jQuery("#specialSchemeCategoryField").hide();
                jQuery("#universityRow").hide();
                jQuery("#studentIdRow").hide();
                jQuery("#waiverNumberRow").hide();
            }
        },

        mlcYesCheck: function () {
            if (jQuery("#mlcCaseYes").is(':checked')) {
                jQuery("#mlcCaseNo").removeAttr("checked");
                jQuery("#mlc").show();
            }
            else {
                jQuery("#mlc").hide();
            }
        },

        mlcNoCheck: function () {
            if (jQuery("#mlcCaseNo").is(':checked')) {
                jQuery("#mlcCaseYes").removeAttr("checked");
                jQuery("#mlc").hide();
            }
        },

        referredYesCheck: function () {
            if (jQuery("#referredYes").is(':checked')) {
                jQuery("#referredNo").removeAttr("checked");
                jQuery("#referredFromColumn").show();
                jQuery("#referralTypeRow").show();
                jQuery("#referralDescriptionRow").show();
            }
            else {
                jQuery("#referredFromColumn").hide();
                jQuery("#referralTypeRow").hide();
                jQuery("#referralDescriptionRow").hide();
            }
        },

        referredNoCheck: function () {
            if (jQuery("#referredNo").is(':checked')) {
                jQuery("#referredYes").removeAttr("checked");
                jQuery("#referredFromColumn").hide();
                jQuery("#referralTypeRow").hide();
                jQuery("#referralDescriptionRow").hide();
            }
        },

        triageRoomCheck: function () {
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
            else {
                jQuery("#triageField").hide();
            }
        },

        opdRoomCheck: function () {
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
            else {
                jQuery("#opdWardField").hide();
            }
        },

        specialClinicRoomCheck: function () {
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
            else {
                jQuery("#specialClinicField").hide();
                jQuery("#fileNumberField").hide();
            }
        },

        copyaddress: function () {
            if (jQuery("#sameAddress").is(':checked')) {
                jQuery("#relativePostalAddress").val(jQuery("#patientPostalAddress").val());

            }
            else {
                jQuery("#relativePostalAddress").val('');
            }
        },

        /*
         * Check patient gender
         */
        genderCheck: function () {

            jQuery("#patientRelativeNameSection").empty();
            if (jQuery("#patientGender").val() == "M") {
                jQuery("#patientRelativeNameSection")
                        .html(
                        '<input type="radio" name="person.attribute.15" value="Son of" checked="checked"/> Son of');
            } else if (jQuery("#patientGender").val() == "F") {
                jQuery("#patientRelativeNameSection")
                        .html(
                        '<input type="radio" name="person.attribute.15" value="Daughter of"/> Daughter of <input type="radio" name="person.attribute.15" value="Wife of"/> Wife of');
            }
        }

    };

    function showOtherNationality() {
        var optionValue = jQuery("#patientNation option:selected").text();
        if (optionValue == "Other") {
            jQuery("#otherNationality").show();
        }
        else {
            jQuery("#otherNationality").hide();
        }
    }

    function submitNationalID() {
        PAGE.checkNationalID();
    }

    function validateNationalID(data) {

        if (data.nid == "1") {
            document.getElementById("nationalIdValidationMessage").innerHTML = "Patient already registered with this National ID";
            jQuery("#nationalIdValidationMessage").show();
            return false;
        }
        else {
            jQuery("#nationalIdValidationMessage").hide();
        }
    }


    function submitPassportNumber() {
        PAGE.checkPassportNumber();
    }

    function validatePassportNumber(data) {

        if (data.pnum == "1") {
            document.getElementById("passportNumberValidationMessage").innerHTML = "Patient already registered with this Passport Number";
            jQuery("#passportNumberValidationMessage").show();
            return false;
        }
        else {
            jQuery("#passportNumberValidationMessage").hide();
        }
    }

    function submitNationalIDAndPassportNumber() {
        PAGE.checkNationalIDAndPassportNumber();
    }


    function payingCategorySelection() {
        var selectedPayingCategory = jQuery("#payingCategory option:checked").val();
        //if(MODEL.payingCategoryMap[selectedPayingCategory]=="CHILD LESS THAN 5 YEARS"){
        var estAge = jQuery("#estimatedAgeInYear").val();
        if (selectedPayingCategory == "CHILD LESS THAN 5 YEARS") {
            if (estAge < 6) {
                jQuery("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
            }
            else {
                alert("This category is only valid for a child less than 5 years");
                return false;
            }
        }
        else {

            if (selectedPayingCategory == "EXPECTANT MOTHER") {
                if (jQuery("#patientGender").val() == "M") {
                    alert("This category is only valid for female");
                }
            }


            if (jQuery("#specialClinic").val()) {
                var initialRegFee = parseInt('${initialRegFee}');
                var specialClinicRegFee = parseInt('${specialClinicRegFee}');
                var totalRegFee = initialRegFee + specialClinicRegFee;
                jQuery("#selectedRegFeeValue").val(totalRegFee);
            }
            else {
                jQuery("#selectedRegFeeValue").val(${initialRegFee});
            }
        }
    }

    function nonPayingCategorySelection() {
        var selectedNonPayingCategory = jQuery("#nonPayingCategory option:checked").val();
        //if(MODEL.nonPayingCategoryMap[selectedNonPayingCategory]=="NHIF CIVIL SERVANT"){
        if (selectedNonPayingCategory == "NHIF CIVIL SERVANT") {
            jQuery("#nhifNumberRow").show();
        }
        else {
            jQuery("#nhifNumberRow").hide();
        }

        var selectedNonPayingCategory = jQuery("#nonPayingCategory option:checked").val();
        //if(MODEL.nonPayingCategoryMap[selectedNonPayingCategory]=="TB PATIENT" || MODEL.nonPayingCategoryMap[selectedNonPayingCategory]=="CCC PATIENT"){
        if (selectedNonPayingCategory == "TB PATIENT" || selectedNonPayingCategory == "CCC PATIENT") {
            if (jQuery("#specialClinic").val()) {
                jQuery("#selectedRegFeeValue").val(${specialClinicRegFee});
            }
            else {
                jQuery("#selectedRegFeeValue").val(0);
            }
        }
        else {
            jQuery("#selectedRegFeeValue").val(0);
        }

    }

    function specialSchemeSelection() {
        var selectedSpecialScheme = jQuery("#specialScheme option:checked").val();

        if (selectedSpecialScheme == "DELIVERY CASE") {
            if (jQuery("#patientGender").val() == "M") {
                alert("This category is only valid for female");
            }
        }

        //if(MODEL.specialSchemeMap[selectedSpecialScheme]=="STUDENT SCHEME"){
        if (selectedSpecialScheme == "STUDENT SCHEME") {
            jQuery("#universityRow").show();
            jQuery("#studentIdRow").show();
        }
        else {
            jQuery("#universityRow").hide();
            jQuery("#studentIdRow").hide();
        }

        //if(MODEL.specialSchemeMap[selectedSpecialScheme]=="WAIVER CASE"){
        if (selectedSpecialScheme == "WAIVER CASE") {
            jQuery("#waiverNumberRow").show();
        }
        else {
            jQuery("#waiverNumberRow").hide();
        }

        jQuery("#selectedRegFeeValue").val(0);
    }

    function triageRoomSelectionFor() {
        if (jQuery("#payingCategory").val() != " ") {
            var selectedPayingCategory = jQuery("#payingCategory option:checked").val();
            if (selectedPayingCategory == "CHILD LESS THAN 5 YEARS") {
                jQuery("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
            }
            else {
                jQuery("#selectedRegFeeValue").val(${initialRegFee});
            }
        }
        else if (jQuery("#nonPayingCategory").val() != " ") {
            jQuery("#selectedRegFeeValue").val(0);
        }
        else if (jQuery("#specialScheme").val() != " ") {
            jQuery("#selectedRegFeeValue").val(0);
        }
    }

    function opdRoomSelectionForReg() {
        if (jQuery("#payingCategory").val() != " ") {
            var selectedPayingCategory = jQuery("#payingCategory option:checked").val();
            if (selectedPayingCategory == "CHILD LESS THAN 5 YEARS") {
                jQuery("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
            }
            else {
                jQuery("#selectedRegFeeValue").val(${initialRegFee});
            }
        }
        else if (jQuery("#nonPayingCategory").val() != " ") {
            jQuery("#selectedRegFeeValue").val(0);
        }
        else if (jQuery("#specialScheme").val() != " ") {
            jQuery("#selectedRegFeeValue").val(0);
        }
    }

    function specialClinicSelectionForReg() {
        if (jQuery("#payingCategory").val() != " ") {
            var selectedPayingCategory = jQuery("#payingCategory option:checked").val();
            if (selectedPayingCategory == "CHILD LESS THAN 5 YEARS") {
                jQuery("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
            }
            else {
                var initialRegFee = parseInt('${initialRegFee}');
                var specialClinicRegFee = parseInt('${specialClinicRegFee}');
                var totalRegFee = initialRegFee + specialClinicRegFee;
                jQuery("#selectedRegFeeValue").val(totalRegFee);
            }
        }
        else if (jQuery("#nonPayingCategory").val() != " ") {
            var selectedNonPayingCategory = jQuery("#nonPayingCategory option:checked").val();
            if (selectedNonPayingCategory == "TB PATIENT" || selectedNonPayingCategory == "CCC PATIENT") {
                jQuery("#selectedRegFeeValue").val(${specialClinicRegFee});
            }
            else {
                jQuery("#selectedRegFeeValue").val(0);
            }
        }
        else if (jQuery("#specialScheme").val() != " ") {
            jQuery("#selectedRegFeeValue").val(0);
        }
    }

</script>
<style>
.ui-tabs-vertical {
    width: 55em;
}

.ui-tabs-vertical .ui-tabs-nav {
    padding: .2em .1em .2em .2em;
    float: left;
    width: 12em;
}

.ui-tabs-vertical .ui-tabs-nav li {
    clear: left;
    width: 100%;
    border-bottom-width: 1px !important;
    border-right-width: 0 !important;
    margin: 0 -1px .2em 0;
}

.ui-tabs-vertical .ui-tabs-nav li a {
    display: block;
}

.ui-tabs-vertical .ui-tabs-nav li.ui-tabs-active {
    padding-bottom: 0;
    padding-right: .1em;
    border-right-width: 1px;
}

.ui-tabs-vertical .ui-tabs-panel {
    padding: 1em;
    float: right;
    width: 40em;
}

.form-textbox {
    height: 12px !important;
    font-size: 12px !important;
}

.form-combo {
    height: 25px !important;
    font-size: 10px !important;
    max-width: 100%;
}

</style>

<div class="onepcssgrid-1200">
    <h6 align="center" style="color:black">PATIENT REGISTRATION<br></h6>
    <h6 align="center">Patient Identifier</b><label style="color:red">* ${patientIdentifier} </label></h6>


    <form id="patientRegistrationForm" method="POST">
        <div id="tabs" class="feature-tabs">
            <ul>
                <li><a href="#tabs-1">Demographics</a></li>
                <li><a href="#tabs-2">Contact Info</a></li>
                <li><a href="#tabs-3">Patient Category</a></li>
            </ul>

            <div id="tabs-1">
                <h2>Patient Demographics</h2>

                <div class="onerow">
                    <div class="col4"><label>Surname*(required)</label></div>


                    <div class="col4"><label>First Name*(required)</label></div>

                    <div class="col4 last"><label>Other Name</label></div>
                </div>

                <div class="onerow">
                    <div class="col4"><input type="text" id="surName" name="patient.surName"
                                             class="form-textbox"/><input hidden name="patient.identifier"
                                                                          value="${patientIdentifier}"/>
                    </div>

                    <div class="col4"><input type="text" id="firstName" name="patient.firstName" class="form-textbox"/>
                    </div>

                    <div class="col4 last"><input type="text" id="otherName" name="patient.otherName"
                                                  class="form-textbox"/></div>
                </div>


                <div class="onerow">
                    <div class="col4"><label>Gender*(required)</label></div>

                    <div class="col4"><label>Marital Status*</label></div>

                    <div class="col4 last"><label>Age or D.O.B*</label></div>
                </div>

                <div class="onerow">
                    <div class="col4">
                        <select id="patientGender" name="patient.gender" class="form-combo">
                            <option value="Any"></option>
                            <option value="M">Male</option>
                            <option value="F">Female</option>
                        </select>
                    </div>

                    <div class="col4">
                        <select id="maritalStatus" name="person.attribute.26" style='width: 152px;' class="form-combo">
                            <option value="Marital"></option>
                            <option value="Single">Single</option>
                            <option value="Married">Married</option>
                            <option value="Divorced">Divorced</option>
                            <option value="Widow">Widow</option>
                            <option value="Widower">Widower</option>
                            <option value="Separated">Separated</option>
                        </select>
                    </div>

                    <div class="col4 last">
                        <input
                                id="birthdate" name="patient.birthdate" class="form-textbox"/>
                        <inputbirthdateEstimated
                                id="" type="hidden"
                                name="patient.birthdateEstimate" value="true"/>
                    </div>
                </div>

                <div class="onerow">&nbsp;
                    <div class="col4"><label>Religion</label></div>

                    <div class="col4">&nbsp;
                        <input type="hidden" id="estimatedAgeInYear" name="estimatedAgeInYear"/>
                    </div>

                    <div class="col4 last">&nbsp;
                        <span id="estimatedAge"/>
                    </div>
                </div>

                <div class="onerow">
                    <div class="col4">
                        <select id="patientReligion" name="person.attribute.${personAttributeReligion.id}"
                                class="form-combo">
                        </select>
                    </div>

                    <div class="col4">

                    </div>

                    <div class="col4 last">

                    </div>
                </div>

                <div class="onerow">
                    <div class="col4"><label>Nationality</label></div>

                    <div class="col4"><label>National ID:</label></div>

                    <div class="col4 last"><label>Passport No.</label></div>
                </div>


                <div class="onerow">
                    <div class="col4">
                        <select id="patientNation" name="person.attribute.27" style="width: 152px;"
                                onchange="showOtherNationality();" class="form-combo">
                            <option value="Kenya">Kenya</option>
                            <option value="East Africa">East Africa</option>
                            <option value="Kenyan">Africa</option>
                            <option value="Algeria">Algeria</option>
                            <option value="Angola">Angola</option>
                            <option value="Benin">Benin</option>
                            <option value="Botswana">Botswana</option>
                            <option value="Burkina Faso">Burkina Faso</option>
                            <option value="Burundi">Burundi</option>
                            <option value="Cameroon">Cameroon</option>
                            <option value="Cape Verde">Cape Verde</option>
                            <option value="Central African Republic">Central African Republic</option>
                            <option value="Chad">Chad</option>
                            <option value="Comoros">Comoros</option>
                            <option value="Cote d'Ivoire">Cote d'Ivoire</option>
                            <option value="Democratic Republic of Congo">Democratic Republic of Congo</option>
                            <option value="Djibouti">Djibouti</option>
                            <option value="Egypt">Egypt</option>
                            <option value="Equatorial Guinea">Equatorial Guinea</option>
                            <option value="Eritrea">Eritrea</option>
                            <option value="Ethiopia">Ethiopia</option>
                            <option value="Gabon">Gabon</option>
                            <option value="Gambia">Gambia</option>
                            <option value="Ghana">Ghana</option>
                            <option value="Guinea">Guinea</option>
                            <option value="Guinea-Bissau">Guinea-Bissau</option>
                            <option value="Lesotho">Lesotho</option>
                            <option value="Liberia">Liberia</option>
                            <option value="Libya">Libya</option>
                            <option value="Madagascar">Madagascar</option>
                            <option value="Malawi">Malawi</option>
                            <option value="Mali">Mali</option>
                            <option value="Mauritania">Mauritania</option>
                            <option value="Mauritius">Mauritius</option>
                            <option value="Morocco">Morocco</option>
                            <option value="Mozambique">Mozambique</option>
                            <option value="Namibia">Namibia</option>
                            <option value="Niger">Niger</option>
                            <option value="Nigeria">Nigeria</option>
                            <option value="Republic of Congo">Republic of Congo</option>
                            <option value="Rwanda">Rwanda</option>
                            <option value="Sao Tome and Principe">Sao Tome and Principe</option>
                            <option value="Senegal">Senegal</option>
                            <option value="Seychelles">Seychelles</option>
                            <option value="Sierra Leone">Sierra Leone</option>
                            <option value="Somalia">Somalia</option>
                            <option value="South Africa">South Africa</option>
                            <option value="South Sudan">South Sudan</option>
                            <option value="Sudan">Sudan</option>
                            <option value="Swaziland">Swaziland</option>
                            <option value="Tanzania">Tanzania</option>
                            <option value="Togo">Togo</option>
                            <option value="Tunisia">Tunisia</option>
                            <option value="Uganda">Uganda</option>
                            <option value="Zambia">Zambia</option>
                            <option value="Zimbabwe">Zimbabwe</option>
                            <option value="Other">Other</option>
                        </select>

                    </div>

                    <div class="col4">
                        <input id="patientNationalId" name="person.attribute.20" onblur="submitNationalID();"
                               class="form-textbox"/>
                        <span style="color: red;" id="nationalIdValidationMessage"></span>

                        <div id="divForNationalId"></div>
                    </div>

                    <div class="col4 last">
                        <input id="passportNumber" name="person.attribute.38" onblur="submitPassportNumber();"
                               class="form-textbox"/>
                        <span style="color: red;" id="passportNumberValidationMessage"></span>

                        <div id="divForpassportNumber"></div>
                    </div>
                </div>

                <div class="onerow">
                    <div class="col4">
                        <span id="otherNationality"><input id="otherNationalityId" name="person.attribute.39"
                                                           placeholder="If others,please specify" class="form-textbox"/>
                        </span>
                    </div>

                    <div class="col4"></div>

                    <div class="col4 last"></div>
                </div>

            </div>

            <div id="tabs-2">
                <h2>Patient Contact Information</h2>

                <div class="onerow">
                    <div class="col4"><label>Contact Number</label></div>

                    <div class="col4"><label>Email Address</label></div>

                    <div class="col4 last"><label>Physical Address</label></div>
                </div>

                <div class="onerow">
                    <div class="col4">
                        <input id="patientPhoneNumber" name="person.attribute.16" class="form-textbox"/>
                    </div>

                    <div class="col4">
                        <input id="patientEmail" name="person.attribute.37" class="form-textbox"/>
                    </div>

                    <div class="col4 last">
                        <input id="patientPostalAddress" name="patient.address.postalAddress" class="form-textbox"/>
                    </div>
                </div>

                <div class="onerow">
                    <div class="col4"><label>County</label></div>

                    <div class="col4"><label>Sub-County</label></div>

                    <div class="col4 last"><label>Location</label></div>
                </div>

                <div class="onerow">
                    <div class="col4">
                        <select id="districts" name="patient.address.district" onChange="PAGE.changeDistrict();"
                                class="form-combo"></select>
                    </div>

                    <div class="col4">
                        <select id="upazilas" name="patient.address.upazila" onChange="PAGE.changeUpazila();"
                                class="form-combo"></select>
                    </div>

                    <div class="col4 last">
                        <select id="locations" name="patient.address.location" class="form-combo"></select>
                    </div>
                </div>

                <div class="onerow">
                    <div class="col4"><label>Chiefdom</label></div>

                    <div class="col4"><label></label></div>

                    <div class="col4 last"><label></label></div>
                </div>

                <div class="onerow">
                    <div class="col4">
                        <input id="chiefdom" name="person.attribute.${personAttributeChiefdom.id}"
                               class="form-textbox"/>
                    </div>

                    <div class="col4">

                    </div>

                    <div class="col4 last">

                    </div>
                </div>
            </div>

            <div id="tabs-3">
                <h2>Patient Category</h2>

                <div class="onerow">
                    <div class="col4"><input id="paying" type="checkbox" name="person.attribute.14"
                                             value="Paying"/> Paying</div>

                    <div class="col4"><input id="nonPaying" type="checkbox" name="person.attribute.14"
                                             value="Non-Paying"/> Non-Paying</div>

                    <div class="col4 last"><input id="specialSchemes" type="checkbox" name="person.attribute.14"
                                                  value="Special Schemes"/> Special Schemes</div>
                </div>

                <div class="onerow">
                    <div class="col4">&nbsp;
                        <span id="payingCategoryField"><select id="payingCategory" name="person.attribute.44"
                                                               onchange="payingCategorySelection();"
                                                               class="form-combo"></select></span>

                    </div>

                    <div class="col4">&nbsp;
                        <span id="nonPayingCategoryField"><select id="nonPayingCategory" name="person.attribute.45"
                                                                  onchange="nonPayingCategorySelection();"
                                                                  class="form-combo"></select></span>
                    </div>

                    <div class="col4 last">&nbsp;
                        <span id="specialSchemeCategoryField"><select id="specialScheme" name="person.attribute.46"
                                                                      onchange="specialSchemeSelection();"
                                                                      style='width: 152px;' class="form-combo"></select>
                        </span>
                    </div>
                </div>

                <div class="onerow">
                    <div class="col4">
                        &nbsp;
                    </div>

                    <div class="col4">&nbsp;
                        <span id="nhifNumberRow"><input type="text" id="nhifNumber" name="person.attribute.34"
                                                        placeholder="NHIF NUMBER" class="form-textbox"/></span>
                    </div>

                    <div class="col4 last">&nbsp;
                        <span id="universityRow">
                            <span id="universityField"><select id="university" name="person.attribute.47"
                                                               class="form-combo"></select></span>
                        </span>
                    </div>
                </div>

                <div class="onerow">
                    <div class="col4">
                        &nbsp;
                    </div>

                    <div class="col4">&nbsp;

                    </div>

                    <div class="col4 last">&nbsp;
                        <span id="studentIdRow">
                            <input type="text" id="studentId" name="person.attribute.42" placeholder="StudentID"
                                   class="form-textbox"/>
                        </span>
                        <span id="waiverNumberRow">
                            <input type="text" id="waiverNumber" name="person.attribute.32" placeholder="Waiver Number"
                                   class="form-textbox"/>
                        </span>
                    </div>
                </div>

                <h2>Next of Kin Details</h2>

                <div class="onerow">
                    <div class="col4"><label>Relative Name</label></div>

                    <div class="col4"><label>Relationship</label></div>

                    <div class="col4 last"><label>Physical Address</label></div>
                </div>

                <div class="onerow">
                    <div class="col4">
                        <input id="patientRelativeName" name="person.attribute.8" class="form-textbox"/>
                    </div>

                    <div class="col4">
                        <select id="relationshipType" name="person.attribute.15" style='width: 152px;'
                                class="form-combo">
                            <option value="Relationship"></option>
                            <option value="Parent">Parent</option>
                            <option value="Spouse">Spouse</option>
                            <option value="Guardian">Guardian</option>
                            <option value="Friend">Friend</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <div class="col4 last">
                        <input type="text" id="relativePostalAddress" name="person.attribute.28" class="form-textbox"/>
                    </div>
                </div>

                <div class="onerow">
                    <div class="col4"><label></label></div>

                    <div class="col4"><label></label></div>

                    <div class="col4 last"><input id="sameAddress" type="checkbox"/> Same as Patient</div>
                </div>

                <h2>Visit Information</h2>

                <div class="onerow">
                    <div class="col4"><label>Medical Legal Case</label></div>

                    <div class="col4"><label>Refferal Information</label></div>

                    <div class="col4 last"><label>Room to Visit</label></div>
                </div>

                <div class="onerow">
                    <div class="col4">
                        <input id="mlcCaseYes" type="checkbox" name="mlcCaseYes"/> Yes&nbsp;<br/>
                        <input id="mlcCaseNo" type="checkbox" name="mlcCaseNo"/> No&nbsp;
                    </div>

                    <div class="col4">
                        <input id="referredYes" type="checkbox" name="referredYes"/> Yes&nbsp;<br/>
                        <input id="referredNo" type="checkbox" name="referredNo"/> No&nbsp;
                    </div>

                    <div class="col4 last">
                        <input id="triageRoom" type="checkbox" name="triageRoom"/> Triage Room &nbsp;<br/>
                        <input id="opdRoom" type="checkbox" name="opdRoom"/> OPD Room&nbsp;<br/>
                        <input id="specialClinicRoom" type="checkbox" name="specialClinicRoom"/> Special Clinic&nbsp;
                    </div>
                </div>

                <div class="onerow">
                    <div class="col4">&nbsp;
                        <select id="mlc" name="patient.mlc" class="form-combo"></select>
                    </div>

                    <div class="col4">&nbsp;
                        <span id="referredFromColumn"><select id="referredFrom" name="patient.referred.from"
                                                              class="form-combo"></select></span>
                        <span id="referralTypeRow">
                            <select id="referralType" name="patient.referred.reason" class="form-combo"></select>
                        </span>
                        <span id="referralDescriptionRow">
                            <input id="referralDescription" name="patient.referred.description" placeholder="Comments"
                                   class="form-textbox"/>
                        </span>
                    </div>

                    <div class="col4 last">&nbsp;
                        <span id="triageField"><select id="triage" name="patient.triage" class="form-combo"
                                                       onchange="triageRoomSelectionForReg();"></select></span>
                        <span id="opdWardField"><select id="opdWard" name="patient.opdWard" class="form-combo"
                                                        onchange="opdRoomSelectionForReg();"></select></span>
                        <span id="specialClinicField"><select id="specialClinic" name="patient.specialClinic"
                                                              class="form-combo"
                                                              onchange="specialClinicSelectionForReg();"></select>
                            <span id="fileNumberField"><input id="fileNumber" name="person.attribute.43"
                                                              placeholder="File Number" class="form-textbox"/></span>
                        </span>
                    </div>
                </div>

                <div class="onerow">
                    <div class="col4"><label></label></div>

                    <div class="col4"></div>

                    <div class="col4 last"><label></label></div>
                </div>

                <div class="onerow">
                    <div class="col3">&nbsp;
                        <input type="hidden" id="selectedRegFeeValue" name="patient.registration.fee"/>
                    </div>

                    <div class="col3">&nbsp;
                        <input type="button" value="Next" onclick="PAGE.submit();" style="font-weight:bold"/>
                    </div>

                    <div class="col3">&nbsp;<input type="button" value="Reset"
                                                   onclick="window.location.href = window.location.href"/></div>

                    <div class="col3 last">&nbsp;</div>
                </div>
            </div>

        </div>
    </form>
</div>