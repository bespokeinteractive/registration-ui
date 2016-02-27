<% ui.decorateWith("appui", "standardEmrPage", [title: "Edit Patient Details"]) %>

<%
    ui.includeCss("registration", "onepcssgrid.css")
    ui.includeCss("registration", "main.css")
    ui.includeCss("registration", "jquery.steps.css")

%>

<%
    ui.includeJavascript("registration", "custom.js")
    ui.includeJavascript("registration", "jquery.cookie-1.3.1.js")
    ui.includeJavascript("registration", "jquery.steps.min.js")
    ui.includeJavascript("registration", "modernizr-2.6.2.min.js")
    ui.includeJavascript("registration", "jquery.validate.min.js")
    ui.includeJavascript("registration", "validations.js")
    ui.includeJavascript("registration", "jquery.loadmask.min.js")
    ui.includeJavascript("registration", "jquery.formfilling.js")
%>

<%
    ui.includeJavascript("uicommons", "navigator/validators.js", Integer.MAX_VALUE - 19)
    ui.includeJavascript("uicommons", "navigator/navigator.js", Integer.MAX_VALUE - 20)
    ui.includeJavascript("uicommons", "navigator/navigatorHandlers.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/navigatorModels.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/exitHandlers.js", Integer.MAX_VALUE - 22)
%>

<openmrs:require privilege="Add Patients" otherwise="/login.htm" redirect="/findPatient.htm"/>

<%
    def hospitalName = context.administrationService.getGlobalProperty("hospitalcore.hospitalName")
%>

<head>
    <script type="text/javascript">
        var MODEL;
        var emrMessages = {};
        emrMessages["requiredField"] = "Required";

        var NavigatorController
        jq(function () {
            NavigatorController = new KeyboardController();
        });

        jQuery(document).ready(function () {

            if ('${status}' === 'error') {
                jq().toastmessage('showNoticeToast', '${message}');

            }

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
            <% payingCategoryMap.each { k, v -> %>
            _payingCategoryMap[${k}] = '${v}';
            <%}%>


            // NonPaying Category Map
            var _nonPayingCategoryMap = new Array();
            var nonPayingCategoryMap = "${nonPayingCategoryMap}";
            <% nonPayingCategoryMap.each { k, v -> %>
            _nonPayingCategoryMap[${k}] = '${v}';
            <%}%>

            // Special Scheme Map
            var _specialSchemeMap = new Array();
            var specialSchemeMap = "${specialSchemeMap}";
            <% specialSchemeMap.each { k, v -> %>
            _specialSchemeMap[${k}] = '${v}';
            <%}%>

            var _attributes = new Array();
            <% patient.attributes.each { k, v -> %>
            _attributes[${k}] = '${v}';
            <%}%>

            /**
             ** MODEL FROM CONTROLLER
             **/
            MODEL = {
                patientIdentifier: "${patient.identifier}",
                districts: _districts,
                upazilas: _upazilas,
                patientAttributes: _attributes,
                ////ghanshyam,16-dec-2013,3438 Remove the interdependency
                TRIAGE: "",
                OPDs: "",
                SPECIALCLINIC: "",
                payingCategory: "${payingCategory}",
                nonPayingCategory: "${nonPayingCategory}",
                specialScheme: "${specialScheme}",
                payingCategoryMap: _payingCategoryMap,
                nonPayingCategoryMap: _nonPayingCategoryMap,
                specialSchemeMap: _specialSchemeMap,
                universities: "${universities}",
                referredFrom: "",
                referralType: "",
                TEMPORARYCAT: "",
                religions: "${religionList}"
            }

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
            MODEL.payingCategory = ", |"
                    + MODEL.payingCategory;
            PAGE.fillOptions("#payingCategory", {
                data: MODEL.payingCategory,
                delimiter: ",",
                optionDelimiter: "|"
            });

            MODEL.nonPayingCategory = ", |"
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

            MODEL.universities = ", |"
                    + MODEL.universities;
            PAGE.fillOptions("#university", {
                data: MODEL.universities,
                delimiter: ",",
                optionDelimiter: "|"
            });

            MODEL.TRIAGE = ", |"
                    + MODEL.TRIAGE;
            PAGE.fillOptions("#triage", {
                data: MODEL.TRIAGE,
                delimiter: ",",
                optionDelimiter: "|"
            });
            MODEL.OPDs = ", |"
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
            MODEL.TEMPORARYCAT = ", |"
                    + MODEL.TEMPORARYCAT;
            PAGE.fillOptions("#mlc", {
                data: MODEL.TEMPORARYCAT,
                delimiter: ",",
                optionDelimiter: "|"
            });

            MODEL.referredFrom = ",Referred From|"
                    + MODEL.referredFrom;
            PAGE.fillOptions("#referredFrom", {
                data: MODEL.referredFrom,
                delimiter: ",",
                optionDelimiter: "|"
            });

            MODEL.referralType = ",Referral Type|"
                    + MODEL.referralType;
            PAGE.fillOptions("#referralType	", {
                data: MODEL.referralType,
                delimiter: ",",
                optionDelimiter: "|"
            });


            var g = "${patient.gender}";
            var genderValue = document.getElementById('patientGender');
            if (g === "Male") {
                genderValue.value = 'M';
            } else if (g === "Female") {
                genderValue.value = 'F';
            }

            var currentMaritalStatus = document.getElementById('maritalStatus');
            currentMaritalStatus.value = "${patient.attributes[26]}";

            //set the current religion
            document.getElementById('patientReligion').value = checkForNulls("${patient.attributes[40]}");

            document.getElementById('birthdate').value = "${patient.birthdate}";


            //set the nationality
            var currentNationality = document.getElementById('patientNation');

            currentNationality.value = "${patient.attributes[27]}";

            //set the national ID
            document.getElementById('patientNationalId').value = checkForNulls("${patient.attributes[20]}");

            //set the Passport Number
            document.getElementById('passportNumber').value = checkForNulls("${patient.attributes[38]}");

            //set the Patient Phone Number
            document.getElementById('patientPhoneNumber').value = checkForNulls("${patient.attributes[16]}");

            //set the Patient Email Address
            document.getElementById('patientEmail').value = checkForNulls("${patient.attributes[37]}");

            //set the Patient Physical Address
            document.getElementById('patientPostalAddress').value = "${patient.physicalAddress}";
            //set the Patient County
            document.getElementById('districts').value = "${patient.subCounty}";
            //set the Patient SubCounty
            document.getElementById('upazilas').value = "${patient.county}";
            PAGE.changeUpazila();
            //set the Patient Location
            document.getElementById('locations').value = "${patient.location}";
            //set the Patient Village
            document.getElementById('chiefdom').value = checkForNulls("${patient.attributes[41]}");


            //set the Patient Relative Name
            document.getElementById('patientRelativeName').value = checkForNulls("${patient.attributes[8]}");

            //set the Patient Relative Relationship Type
            document.getElementById('relationshipType').value = checkForNulls("${patient.attributes[15]}");
            //set the Patient Relative Physical Address
            document.getElementById('relativePostalAddress').value = checkForNulls("${patient.attributes[28]}");


            //TODO  - binding the Patient Payment Category values post updates
            PAGE.checkBirthDate();
            //set the Patient Payment Category
            var paymentCategory = checkForNulls("${patient.attributes[14]}");
            console.log(paymentCategory)
            //set the Payment Category - Paying Specific
            var payingCategorySpecific = checkForNulls("${patient.attributes[44]}");
            console.log(payingCategorySpecific)
            //set the Payment Category - Non-Paying Specific
            var nonPayingSpecific = checkForNulls("${patient.attributes[45]}");
            console.log(nonPayingSpecific)
            //set the Payment Category - Special scheme Specific
            var specialSchemeSpecific = checkForNulls("${patient.attributes[46]}");
            console.log(specialSchemeSpecific)
            //set NHIF number if available
            var nhifNumber = checkForNulls("${patient.attributes[34]}");
            console.log(nhifNumber)

            //set student college if present
            var studentUniversity = checkForNulls("${patient.attributes[47]}");
            console.log(studentUniversity)
            //set student id if present
            var studentUniversityId = checkForNulls("${patient.attributes[42]}");
            console.log(studentUniversityId)
            //set waiver number if waiver case
            var waiverNumber = checkForNulls("${patient.attributes[32]}");
            console.log(waiverNumber)

            if (paymentCategory == 'Paying') {
                alert("is a paying person");
                jQuery('input[name=paym_1][value="1"]').attr('checked', 'checked');
                LoadPayCatg();


                if (payingCategorySpecific == 'GENERAL') {
                    alert("is a general person");
                    jQuery('input[name=paym_2][value="1"]').attr('checked', 'checked');


                } else if (payingCategorySpecific == 'CHILD LESS THAN 5 YEARS') {
                    alert("is a child person");
                    jQuery('input[name=paym_2][value="2"]').attr('checked', 'checked');


                } else if (payingCategorySpecific == 'EXPECTANT MOTHER') {
                    alert("is a mother person");
                    jQuery('input[name=paym_2][value="3"]').attr('checked', 'checked');

                }


            } else if (paymentCategory == 'Non-Paying'){
                alert("is a non-paying person");
                jQuery('input[name=paym_1][value="2"]').attr('checked', 'checked');
                LoadPayCatg();
                if (nonPayingSpecific == 'NHIF CIVIL SERVANT') {
                    alert("is a civil servernt person");
                    jQuery('input[name=paym_2][value="1"]').attr('checked', 'checked');
                    LoadPayCatgMode();
                    jQuery("#modesummary").val(nhifNumber);




                } else if (nonPayingSpecific == 'CCC PATIENT') {
                    alert("is a ccc patient person");
                    jQuery('input[name=paym_2][value="2"]').attr('checked', 'checked');
                    LoadPayCatgMode();

                } else if (nonPayingSpecific == 'TB PATIENT') {
                    alert("is a tb person");
                    jQuery('input[name=paym_2][value="3"]').attr('checked', 'checked');
                    LoadPayCatgMode();
                } else if (nonPayingSpecific == 'PRISONER') {
                    alert("is a prisoner person");
                    jQuery('input[name=paym_2][value="4"]').attr('checked', 'checked');
                    LoadPayCatgMode();
                }
            } else if (paymentCategory == 'Special Schemes') {
                alert("is a special scheme person");
                jQuery('input[name=paym_1][value="3"]').attr('checked', 'checked');
                LoadPayCatg();
                if (specialSchemeSpecific == 'STUDENT SCHEME') {
                    alert('student scheme');
                    jQuery('input[name=paym_2][value="1"]').attr('checked', 'checked');
                    LoadPayCatgMode();
                    document.getElementById('university').value = studentUniversity;
                    document.getElementById('modesummary').value = studentUniversityId;


                } else if (specialSchemeSpecific == 'WAIVER CASE') {
                    alert('waiver case');
                    jQuery('input[name=paym_2][value="2"]').attr('checked', 'checked');
                    LoadPayCatgMode();
                    jQuery("#modesummary").val(waiverNumber);

                } else if (specialSchemeSpecific == 'DELIVERY CASE') {
                    alert('delivery case');
                    jQuery('input[name=paym_2][value="3"]').attr('checked', 'checked');
                    LoadPayCatgMode();
                }
            }


            jQuery('input:text[id]').focus(function (event) {
                var checkboxID = jQuery(event.target).attr('id');
                jQuery('#' + checkboxID).removeClass("red-border");
            });

            jQuery('select').focus(function (event) {
                var checkboxID = jQuery(event.target).attr('id');
                jQuery('#' + checkboxID).removeClass("red-border");
            });

            jQuery('input:text[id]').focusout(function (event) {
                var arr = ["surName", "firstName", "birthdate", "patientRelativeName", "patientPostalAddress", "otherNationalityId", ""];
                var idd = jQuery(event.target).attr('id');

                if (jQuery.inArray(idd, arr) != -1) {
                    if (jQuery('#' + idd).val().trim() == "") {
                        jQuery('#' + idd).addClass("red-border");
                    }
                    else {
                        jQuery('#' + idd).removeClass("red-border");
                    }
                }
            });

            jQuery('input:text[id]').focusout(function (event) {
                var arr = ["firstName", "", "", "", "", ""];
                var idd = jQuery(event.target).attr('id');

                if (jQuery.inArray(idd, arr) != -1) {
                    if (idd == 'firstName') {
                        jQuery('#summ_idnt').text("${patient.identifier}");
                        jQuery('#summ_name').text(jQuery('#surName').val() + ', ' + jQuery('#firstName').val());
                    }
                }
            });

            jQuery('select').focusout(function (event) {
                var arr = ["patientGender", "paymode1", "legal1", "refer1", "rooms1", "relationshipType", "upazilas", "modetype1", "value4"];
                var idd = jQuery(event.target).attr('id');

                if (jQuery.inArray(idd, arr) != -1) {
                    if (jQuery('#' + idd).val() == 0 || jQuery('#' + idd).val().trim() == "") {
                        jQuery('#' + idd).addClass("red-border");
                    }
                    else {
                        jQuery('#' + idd).removeClass("red-border");
                    }

                    if (idd == 'patientGender') {
                        jQuery('#summ_gend').text(jQuery('#patientGender option:selected').text());
                    }
                }
            });

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

            jQuery('#payingCategory option').eq(1).prop('selected', true);
            jQuery('#university option').eq(1).prop('selected', true);
            jQuery('#refer1 option').eq(2).prop('selected', true);
            jQuery('#legal1 option').eq(2).prop('selected', true);

            jQuery("#nhifNumberRow").hide();
            jQuery("#universityRow").hide();
            jQuery("#studentIdRow").hide();
            jQuery("#waiverNumberRow").hide();

            LoadLegalCases();
            LoadReferralCases();
            showOtherNationality();
//            LoadPayCatg();
            LoadRoomsTypes();

            //stans
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

        function checkForNulls(data) {
            if (data === "null") {
                return "";
            } else {
                return data;
            }
        }

        /**
         ** FORM
         **/
        PAGE = {
            /** SUBMIT */
            submit: function () {
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

                            jQuery("#summ_ages").html(data.datemodel.age.substr(1, 1000));
                            jQuery("#estimatedAge").html(data.datemodel.age);
                            jQuery("#estimatedAgeInYear").val(data.datemodel.ageInYear);
                            jQuery("#birthdate").val(data.datemodel.birthdate);
                            jQuery("#calendar").val(data.datemodel.birthdate);

                        } else {
                            jq().toastmessage('showNoticeToast', 'Age in wrong format');
                            jQuery("#birthdate").val("");
                            goto_previous_tab(5);
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
                var i = 0;
                var tab1 = 0;
                var tab2 = 0;
                var tab3 = 0;
                var tab4 = 0;

                var select1 = jQuery('input[name=paym_1]:checked', '#patientRegistrationForm').val();
                var select2 = jQuery('input[name=paym_2]:checked', '#patientRegistrationForm').val();

                var str1 = '';

                //            if (StringUtils.isBlank(jQuery("#surName").val())) {
                if (!(jQuery("#surName").val().trim())) {
                    jQuery('#surName').addClass("red-border");
                    tab1++;
                    i++;
                }
                else {
                    value = jQuery("#surName").val();
                    value = value.substr(0, 1).toUpperCase() + value.substr(1);
                    jQuery("#surName").val(value);
                    //if(/^[a-zA-Z0-9- ]*\$/.test(value) == false) {
                    if (/^[a-zA-Z- ]*\$/.test(value) == false) {
                        jQuery('#surName').addClass("red-border");
                        tab1++;
                        i++;
                    }
                    else {
                        jQuery('#surName').removeClass("red-border");
                    }

                }

                //if (StringUtils.isBlank(jQuery("#firstName").val())) {
                if (!(jQuery("#firstName").val().trim())) {
                    jQuery('#firstName').addClass("red-border");
                    tab1++;
                    i++;
                }
                else {
                    value = jQuery("#firstName").val();
                    value = value.substr(0, 1).toUpperCase() + value.substr(1);
                    jQuery("#firstName").val(value);
                    //if(/^[a-zA-Z0-9- ]*\$/.test(value) == false) {
                    if (/^[a-zA-Z- ]*\$/.test(value) == false) {
                        jQuery('#firstName').addClass("red-border");
                        tab1++;
                        i++;
                    }
                    else {
                        jQuery('#firstName').removeClass("red-border");
                    }
                }

                //            if (!StringUtils.isBlank(jQuery("#otherName").val())) {
                if ((jQuery("#otherName").val())) {
                    value = jQuery("#otherName").val();
                    value = value.substr(0, 1).toUpperCase() + value.substr(1);
                    jQuery("#otherName").val(value);
                    //if(/^[a-zA-Z0-9- ]*\$/.test(value) == false) {
                    if (/^[a-zA-Z- ]*\$/.test(value) == false) {
                        jQuery('#otherName').addClass("red-border");
                        tab1++;
                        i++;
                    }
                    else {
                        jQuery('#otherName').removeClass("red-border");
                    }
                }

                if (!(jQuery("#birthdate").val().trim())) {
                    jQuery('#birthdate').addClass("red-border");
                    tab1++;
                    i++;
                }
                else {
                    jQuery('#birthdate').removeClass("red-border");
                }

                if (jQuery("#patientGender").val() == 0 || jQuery("#patientGender").val().trim() == "") {
                    jQuery('#patientGender').addClass("red-border");
                    i++;
                    tab1++;
                }
                else if (select1 == 1 && select2 == 3 && jQuery("#patientGender").val() == "M") {
                    str1 = 'The selected Scheme Doesnt Match the Gender Selected. ';
                    jQuery('#patientGender').addClass("red-border");
                    i++;
                    tab1++;
                }
                else if (jQuery("#patientGender").val() == "M" && jQuery("#maritalStatus").val() == "Widow") {
                    str1 = str1 + 'Widow marital status is only for Female. ';
                    jQuery('#maritalStatus').addClass("red-border");
                    i++;
                    tab1++;
                }
                else if (jQuery("#patientGender").val() == "F" && jQuery("#maritalStatus").val() == "Widower") {
                    str1 = str1 + 'Widower marital status is only for Male. ';
                    jQuery('#maritalStatus').addClass("red-border");
                    i++;
                    tab1++;
                }
                else {
                    jQuery('#patientGender').removeClass("red-border");
                }


                //TAB2
                if (!(jQuery("#patientPostalAddress").val().trim())) {
                    jQuery('#patientPostalAddress').addClass("red-border");
                    tab2++;
                    i++;
                }
                else if (jQuery("#patientPostalAddress").val().length > 255) {
                    str1 = str1 + 'Too much information provided for Physical Address. ';
                    jQuery('#patientPostalAddress').addClass("red-border");
                    tab2++;
                    i++;
                }
                else {
                    jQuery('#patientPostalAddress').removeClass("red-border");
                }

                if ((jQuery("#patientEmail").val().trim())) {
                    var x = jQuery("#patientEmail").val();
                    var regExpForEmail =
                    <%= "/^([\\w-]+(?:\\.[\\w-]+)*)@((?:[\\w-]+\\.)*\\w[\\w-]{0,66})\\.([a-z]{2,6}(?:\\.[a-z]{2})?)\$/i;" %>
                    if (regExpForEmail.test(x)) {
                        jQuery('#patientEmail').removeClass("red-border");
                    }
                    else {
                        str1 = str1 + "Please enter the patient's e-mail address in correct format. ";
                        jQuery('#patientEmail').addClass("red-border");
                        i++;
                        tab2++;
                    }

                }

                //NOK HERE
                if (!(jQuery("#patientRelativeName").val().trim())) {
                    jQuery('#patientRelativeName').addClass("red-border");
                    i++;
                    tab2++;
                }
                else {
                    value = jQuery("#patientRelativeName").val();
                    //value = value.substr(0, 1).toUpperCase() + value.substr(1);
                    //jQuery("#patientRelativeName").val(value);
                    if (<%= "/^[a-zA-Z- ]*\$/" %>.
                    test(value) == false
                )
                    {
                        jQuery('#patientRelativeName').addClass("red-border");
                        i++;
                        tab2++;
                    }
                else
                    {
                        jQuery('#patientRelativeName').removeClass("red-border");
                    }
                }

                if (jQuery("#relationshipType").val() == 0 || jQuery("#relationshipType").val().trim() == "") {
                    jQuery('#relationshipType').addClass("red-border");
                    i++;
                    tab2++;
                }
                else {
                    jQuery('#relationshipType').removeClass("red-border");
                }

                if (jQuery("#relativePostalAddress").val().length > 255) {
                    str1 = str1 + "Next of Kin Physical Address should not exceed more than 255 characters. ";
                    jQuery('#relativePostalAddress').addClass("red-border");
                    i++;
                    tab2++;
                }
                else {
                    jQuery('#relativePostalAddress').removeClass("red-border");
                }

                //TAB3
                /*
                 if (jQuery("#legal1").val() == 0) {
                 jQuery('#legal1').addClass("red-border");
                 i++;
                 tab3++;
                 }
                 else {
                 jQuery('#legal1').removeClass("red-border");
                 }

                 if ((jQuery("#legal1").val() == 1 && jQuery("#mlc").val().trim() == "") || jQuery('#mlc').val() == null) {
                 jQuery('#mlc').addClass("red-border");
                 i++;
                 tab3++;
                 }
                 else {
                 jQuery('#mlc').removeClass("red-border");
                 }

                 if (jQuery("#refer1").val() == 0) {
                 jQuery('#refer1').addClass("red-border");
                 i++;
                 tab3++;
                 }
                 else {
                 jQuery('#refer1').removeClass("red-border");
                 }

                 if ((jQuery("#refer1").val() == 1 && jQuery("#referredFrom").val().trim() == "") || jQuery('#referredFrom').val() == null) {
                 jQuery('#referredFrom').addClass("red-border");
                 i++;
                 tab3++;
                 }
                 else {
                 jQuery('#referredFrom').removeClass("red-border");
                 }

                 if ((jQuery("#refer1").val() == 1 && jQuery("#referralType").val().trim() == "") || jQuery('#referralType').val() == null) {
                 jQuery('#referralType').addClass("red-border");
                 i++;
                 tab3++;
                 }
                 else {
                 jQuery('#referralType').removeClass("red-border");
                 }


                 if (jQuery("#rooms1").val() == "") {
                 jQuery('#rooms1').addClass("red-border");
                 i++;
                 tab3++;
                 }
                 else {
                 jQuery('#rooms1').removeClass("red-border");
                 }


                 if (jQuery("#rooms2").val() == 0 || jQuery("#rooms2").val() == "" || jQuery("#rooms2").val() == null) {
                 jQuery('#rooms2').addClass("red-border");
                 i++;
                 tab3++;
                 }
                 else {
                 jQuery('#rooms2').removeClass("red-border");
                 }

                 if (jQuery("#rooms1").val() == 3 && jQuery("#rooms3").val().trim() == "") {
                 jQuery('#rooms3').addClass("red-border");
                 i++;
                 tab3++;
                 }
                 else {
                 jQuery('#rooms3').removeClass("red-border");
                 }


                 //submitNationalIDAndPassportNumber();
                 //            if (validateNationalIDAndPassportNumber()) {
                 //                return true;
                 //            }
                 //            else {
                 //                return false;
                 //            }
                 */

                if (i == 0) {
                    return true;
                }
                else {
                    var str0 = "<div id='form-verification-x' onclick='verification_close();'>&#215;</div><p>Please fill in correctly the fields marked with * and highlighted in red. Also ensure that date fields have been entered in specified format</p>"

                    if (str1 != "") {
                        str0 = str0 + '<p><span style="color:#f00;"><i class="icon-quote-left" style="font-size: 18px">&nbsp;</i>Also Note: </span>' + str1 + '</p>'
                    }

                    jQuery('#form-verification-failed').html(str0);
                    jQuery('#form-verification-failed').show();
                    jQuery('html, body').animate({scrollTop: 100}, 'slow');
                    return false;
                }
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

                    var selectedNonPayingCategory = jQuery("#nonPayingCategory option:checked").val();
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

                    jQuery("#nhifNumberRow").hide();

                    var selectedSpecialScheme = jQuery("#specialScheme option:checked").val();
                    if (selectedSpecialScheme == "STUDENT SCHEME") {
                        jQuery("#universityRow").show();
                        jQuery("#studentIdRow").show();
                    }
                    else {
                        jQuery("#universityRow").hide();
                        jQuery("#studentIdRow").hide();
                    }

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
                jQuery('#otherNationalityId').removeClass("disabled");

            }
            else {
                jQuery("#otherNationality").hide();
                jQuery('#otherNationalityId').addClass("disabled");
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
            var select1 = jQuery('input[name=paym_1]:checked', '#patientRegistrationForm').val();
            var select2 = jQuery('input[name=paym_2]:checked', '#patientRegistrationForm').val();

            var selectedPayingCategory = jQuery("#payingCategory option:checked").val();
            //if(MODEL.payingCategoryMap[selectedPayingCategory]=="CHILD LESS THAN 5 YEARS"){
            var estAge = jQuery("#estimatedAgeInYear").val();	//come back here


            if (select1 == 1 && select2 == 2) {
                if (estAge < 6) {
                    jQuery("#selectedRegFeeValue").val(0);
                }
            }
            else {

                if (select1 == 1 && select2 == 3) {
                    if (jQuery("#patientGender").val() == "M") {
                        alert("This category is only valid for female");
                    }
                }


                if (select1 == 3) {
                    var initialRegFee = 0;
                    var specialClinicRegFee = 0;
                    var totalRegFee = initialRegFee + specialClinicRegFee;
                    jQuery("#selectedRegFeeValue").val(totalRegFee);
                }
                else {
                    jQuery("#selectedRegFeeValue").val(0);
                }
            }


            if (select1 == 1) {
                jQuery('#payingCategory option').eq(select2).prop('selected', true);
                jQuery('#nonPayingCategory option').eq(0).prop('selected', true);
                jQuery('#specialScheme option').eq(0).prop('selected', true);

                jQuery('#summ_pays').text('Paying / ' + jQuery('#payingCategory option:selected').text());
            }
            else if (select1 == 2) {
                jQuery('#nonPayingCategory option').eq(select2).prop('selected', true);
                jQuery('#payingCategory option').eq(0).prop('selected', true);
                jQuery('#specialScheme option').eq(0).prop('selected', true);

                jQuery('#summ_pays').text('Non-Paying / ' + jQuery('#nonPayingCategory option:selected').text());
            }
            else {
                jQuery('#specialScheme option').eq(select2).prop('selected', true);
                jQuery('#payingCategory option').eq(0).prop('selected', true);
                jQuery('#nonPayingCategory option').eq(0).prop('selected', true);

                jQuery('#summ_pays').text('Special Scheme / ' + jQuery('#specialScheme option:selected').text());
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
                    jQuery("#selectedRegFeeValue").val(0);
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
                    jQuery("#selectedRegFeeValue").val(0);
                }
                else {
                    jQuery("#selectedRegFeeValue").val(0);
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
                    jQuery("#selectedRegFeeValue").val(0);
                }
                else {
                    jQuery("#selectedRegFeeValue").val(0);
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
                    jQuery("#selectedRegFeeValue").val(0);
                }
                else {
                    var initialRegFee = 0;
                    var specialClinicRegFee = 0;
                    var totalRegFee = initialRegFee + specialClinicRegFee;
                    jQuery("#selectedRegFeeValue").val(totalRegFee);
                }
            }
            else if (jQuery("#nonPayingCategory").val() != " ") {
                var selectedNonPayingCategory = jQuery("#nonPayingCategory option:checked").val();
                if (selectedNonPayingCategory == "TB PATIENT" || selectedNonPayingCategory == "CCC PATIENT") {
                    jQuery("#selectedRegFeeValue").val(0);
                }
                else {
                    jQuery("#selectedRegFeeValue").val(0);
                }
            }
            else if (jQuery("#specialScheme").val() != " ") {
                jQuery("#selectedRegFeeValue").val(0);
            }
        }
        function LoadPayCatg() {
            jQuery("#paym_201").attr('checked', 'checked');

            var selectn = jQuery('input[name=paym_1]:checked', '#patientRegistrationForm').val();
            if (selectn == 1) {
                jQuery('#ipaym_11').text('GENERAL');
                jQuery('#ipaym_12').text('CHILD UNDER 5YRS');
                jQuery('#ipaym_13').text('EXPECTANT MOTHER');

                jQuery('#tasktitle').text('Paying Category');

                jQuery("#paying").attr('checked', 'checked');
                jQuery("#nonPaying").attr('checked', false);
                jQuery("#specialSchemes").attr('checked', false);
            }
            else if (selectn == 2) {
                jQuery('#ipaym_11').text('NHIF/CIVIL SERVANT');
                jQuery('#ipaym_12').text('CCC PATIENT');
                jQuery('#ipaym_13').text('TB PATIENT');

                jQuery('#tasktitle').text('Non-Paying Category');

                jQuery("#nonPaying").attr('checked', 'checked');
                jQuery("#paying").attr('checked', false);
                jQuery("#specialSchemes").attr('checked', false);

            }
            else if (selectn == 3) {
                jQuery('#ipaym_11').text('STUDENT SCHEME');
                jQuery('#ipaym_12').text('WAIVER CASE');
                jQuery('#ipaym_13').text('DELIVERY CASE');
                jQuery('#tasktitle').text('Special Schemes');

                jQuery("#specialSchemes").attr('checked', 'checked');
                jQuery("#paying").attr('checked', false);
                jQuery("#nonPaying").attr('checked', false);
            }

        }

        function LoadPayCatgMode() {
            var select1 = jQuery('input[name=paym_1]:checked', '#patientRegistrationForm').val();
            var select2 = jQuery('input[name=paym_2]:checked', '#patientRegistrationForm').val();

            if ((select1 == 2) && (select2 == 1)) {
                jQuery("#modesummary").attr("readonly", false);
                jQuery("#modesummary").val("");
                jQuery('#universitydiv').hide();
                jQuery('#summtitle1').text('NHIF Summary');
                jQuery('#modesummary').attr("placeholder", "NHIF Number");
            }
            else if ((select1 == 3) && (select2 == 1)) {
                jQuery("#modesummary").attr("readonly", false);
                jQuery("#modesummary").val("");
                jQuery('#universitydiv').show();
                jQuery('#summtitle1').text('Student Summary');
                jQuery('#modesummary').attr("placeholder", "Student Number");
            }
            else if ((select1 == 3) && (select2 == 2)) {
                jQuery("#modesummary").attr("readonly", false);
                jQuery("#modesummary").val("");
                jQuery('#universitydiv').hide();
                jQuery('#summtitle1').text('Waiver Summary');
                jQuery('#modesummary').attr("placeholder", "Waiver Number");
            }
            else {
                jQuery("#modesummary").attr("readonly", false);
                jQuery("#modesummary").val("N/A");
                jQuery('#universitydiv').hide();
                jQuery('#summtitle1').text('Summary');
                jQuery('#modesummary').attr("placeholder", "Enter Value");

            }

            if (select1 == 1) {
                jQuery('#payingCategory option').eq(select2).prop('selected', true);
                jQuery('#nonPayingCategory option').eq(0).prop('selected', true);
                jQuery('#specialScheme option').eq(0).prop('selected', true);

                jQuery('#summ_pays').text('Paying / ' + jQuery('#payingCategory option:selected').text());
            }
            else if (select1 == 2) {
                jQuery('#nonPayingCategory option').eq(select2).prop('selected', true);
                jQuery('#payingCategory option').eq(0).prop('selected', true);
                jQuery('#specialScheme option').eq(0).prop('selected', true);

                jQuery('#summ_pays').text('Non-Paying / ' + jQuery('#nonPayingCategory option:selected').text());
            }
            else {
                jQuery('#specialScheme option').eq(select2).prop('selected', true);
                jQuery('#payingCategory option').eq(0).prop('selected', true);
                jQuery('#nonPayingCategory option').eq(0).prop('selected', true);

                jQuery('#summ_pays').text('Special Scheme / ' + jQuery('#specialScheme option:selected').text());
            }

            payingCategorySelection();

            jQuery('#summ_fees').text(jQuery('#selectedRegFeeValue').val() + '.00');
        }

        function LoadPaymodes() {
            jQuery('#modetype1').empty();

            if (jQuery("#paymode1").val() == 1) {
                var myOptions = {1: 'GENERAL', 2: 'CHILD UNDER 5YRS', 3: 'EXPECTANT MOTHER'};

                var mySelect = jQuery('#modetype1');
                jQuery.each(myOptions, function (val, text) {
                    mySelect.append(
                            jQuery('<option></option>').val(val).html(text)
                    );
                });
            }
            else if (jQuery("#paymode1").val() == 2) {
                var myOptions = {4: 'PULSE', 5: 'CCC PATIENT', 6: 'TB PATIENT'};

                var mySelect = jQuery('#modetype1');
                jQuery.each(myOptions, function (val, text) {
                    mySelect.append(
                            jQuery('<option></option>').val(val).html(text)
                    );
                });
            }
            else if (jQuery("#paymode1").val() == 3) {
                var myOptions = {7: 'BLOOD OXYGEN SATURATION', 8: 'WAIVER CASE', 9: 'DELIVERY CASE'};

                var mySelect = jQuery('#modetype1');
                jQuery.each(myOptions, function (val, text) {
                    mySelect.append(
                            jQuery('<option></option>').val(val).html(text)
                    );
                });
            }
            else {
                var myOptions = {0: ''};

                var mySelect = jQuery('#modetype1');
                jQuery.each(myOptions, function (val, text) {
                    mySelect.append(
                            jQuery('<option></option>').val(val).html(text)
                    );
                });
            }

            LoadModeChange();
        }

        function LoadModeChange() {
            if (jQuery("#modetype1").val() == 8) {
                jQuery("#modesummary").attr("readonly", false);
                jQuery("#modesummary").val("");
                jQuery('#forpaymode1').text('Waiver Number');
            }
            else {
                jQuery("#modesummary").attr("readonly", false);
                jQuery("#modesummary").val("N/A");
                jQuery('#forpaymode1').text('Summary');
            }
        }

        function LoadLegalCases() {
            jQuery('#mlc').empty();

            if (jQuery("#legal1").val() == 1) {
                PAGE.fillOptions("#mlc", {
                    data: MODEL.TEMPORARYCAT,
                    delimiter: ",",
                    optionDelimiter: "|"
                });

                jQuery("#mlcCaseYes").attr('checked', 'checked');
                jQuery("#mlcCaseNo").attr('checked', false);
            }
            else {
                var myOptions = {" ": 'N/A'};
                var mySelect = jQuery('#mlc');
                jQuery.each(myOptions, function (val, text) {
                    mySelect.append(
                            jQuery('<option></option>').val(val).html(text)
                    );
                });

                jQuery("#mlcCaseYes").attr('checked', false);
                jQuery("#mlcCaseNo").attr('checked', 'checked');
            }
        }
        function LoadReferralCases() {
            jQuery('#referredFrom').empty();
            jQuery('#referralType').empty();

            if (jQuery("#refer1").val() == 1) {
                PAGE.fillOptions("#referredFrom", {
                    data: MODEL.referredFrom,
                    delimiter: ",",
                    optionDelimiter: "|"
                });

                jQuery("#referralDescription").attr("readonly", false);
                jQuery("#referralDescription").val("");

                PAGE.fillOptions("#referralType", {
                    data: MODEL.referralType,
                    delimiter: ",",
                    optionDelimiter: "|"
                });

                jQuery("#referredYes").attr('checked', 'checked');
                jQuery("#referredNo").attr('checked', false);
                jQuery("#referraldiv").show();
                jQuery('#referralDescription').removeClass("disabled");
            }
            else {
                var myOptions = {" ": 'N/A'};
                var mySelect = jQuery('#referredFrom');
                jQuery.each(myOptions, function (val, text) {
                    mySelect.append(
                            jQuery('<option></option>').val(val).html(text)
                    );
                });

                mySelect = jQuery('#referralType');
                jQuery.each(myOptions, function (val, text) {
                    mySelect.append(
                            jQuery('<option></option>').val(val).html(text)
                    );
                });

                jQuery("#referralDescription").attr("readonly", true);
                jQuery("#referralDescription").val("N/A");

                jQuery("#referredNo").attr('checked', 'checked');
                jQuery("#referredYes").attr('checked', false);
                jQuery("#referraldiv").hide();
                jQuery('#referralDescription').addClass("disabled");
            }
        }

        function LoadRoomsTypes() {
            jQuery('#rooms2').empty();
            if (jQuery("#rooms1").val() == 1) {
                PAGE.fillOptions("#rooms2", {
                    data: MODEL.TRIAGE,
                    delimiter: ",",
                    optionDelimiter: "|"
                });
                jQuery("#rooms3").attr("readonly", true);
                jQuery("#rooms3").val("N/A");
                jQuery('#froom2').html('Triage Rooms<span>*</span>');

                jQuery("#triageRoom").attr('checked', 'checked');
                jQuery("#opdRoom").attr('checked', false);
                jQuery("#specialClinicRoom").attr('checked', false);
                jQuery('#referralDescription').removeClass("required");
            }
            else if (jQuery("#rooms1").val() == 2) {
                PAGE.fillOptions("#rooms2", {
                    data: MODEL.OPDs,
                    delimiter: ",",
                    optionDelimiter: "|"
                });

                jQuery("#rooms3").attr("readonly", true);
                jQuery("#rooms3").val("N/A");
                jQuery('#froom2').html('OPD Rooms<span>*</span>');

                jQuery("#triageRoom").attr('checked', false);
                jQuery("#opdRoom").attr('checked', 'checked');
                jQuery("#specialClinicRoom").attr('checked', false);
                jQuery('#referralDescription').removeClass("required");
            }
            else if (jQuery("#rooms1").val() == 3) {
                PAGE.fillOptions("#rooms2", {
                    data: MODEL.SPECIALCLINIC,
                    delimiter: ",",
                    optionDelimiter: "|"
                });

                jQuery("#rooms3").attr("readonly", false);
                jQuery("#rooms3").val("");
                jQuery('#froom2').html('Special Clinic<span>*</span>');

                jQuery("#triageRoom").attr('checked', false);
                jQuery("#opdRoom").attr('checked', false);
                jQuery("#specialClinicRoom").attr('checked', 'checked');
                jQuery('#referralDescription').addClass("required");
            }
            else {
                var myOptions = {0: 'N/A'};
                var mySelect = jQuery('#rooms2');
                jQuery.each(myOptions, function (val, text) {
                    mySelect.append(
                            jQuery('<option></option>').val(val).html(text)
                    );
                });

                jQuery("#rooms3").attr("readonly", true);
                jQuery("#rooms3").val("N/A");

                jQuery("#triageRoom").attr('checked', false);
                jQuery("#opdRoom").attr('checked', false);
                jQuery("#specialClinicRoom").attr('checked', false);
                jQuery('#referralDescription').removeClass("required");
            }
        }

        function verification_close() {
            jQuery('#form-verification-failed').hide();
        }
        ;

        function goto_next_tab(current_tab) {
            if (current_tab == 1) {
                var currents = '';

                while (jQuery(':focus') != jQuery('#patientPhoneNumber')) {
                    if (currents == jQuery(':focus').attr('id')) {
                        NavigatorController.stepForward();
                        jQuery("#ui-datepicker-div").hide();
                        break;
                    }
                    else {
                        currents = jQuery(':focus').attr('id');
                    }

                    if (jQuery(':focus').attr('id') == 'patientPhoneNumber') {
                        jQuery("#ui-datepicker-div").hide();
                        break;
                    }
                    else {
                        NavigatorController.stepForward();
                    }
                }
                // jQuery(':focus')

                //NavigatorController.getFieldById('passportNumber').select();

            }
            else if (current_tab == 2) {
                var currents = '';

                while (jQuery(':focus') != jQuery('#modesummary')) {
                    if (currents == jQuery(':focus').attr('id')) {
                        NavigatorController.stepForward();
                        break;
                    }
                    else {
                        currents = jQuery(':focus').attr('id');
                    }

                    if (jQuery(':focus').attr('id') == 'modesummary') {
                        break;
                    }
                    else {
                        NavigatorController.stepForward();
                    }
                }
            }
        }

        function goto_previous_tab(current_tab) {
            if (current_tab == 2) {
                while (jQuery(':focus') != jQuery('#passportNumber')) {
                    if (jQuery(':focus').attr('id') == 'passportNumber' || jQuery(':focus').attr('id') == 'otherNationalityId') {
                        jQuery("#ui-datepicker-div").hide();
                        break;
                    }
                    else {
                        NavigatorController.stepBackward();
                    }
                }
            }
            else if (current_tab == 3) {
                while (jQuery(':focus') != jQuery('#relativePostalAddress')) {
                    if (jQuery(':focus').attr('id') == 'relativePostalAddress') {
                        jQuery("#ui-datepicker-div").hide();
                        break;
                    }
                    else {
                        NavigatorController.stepBackward();
                    }
                }
            }
            else if (current_tab == 4) {
                jQuery('#rooms3').focus();

            }
            else if (current_tab == 5) {
                while (jQuery(':focus') != jQuery('#maritalStatus')) {
                    if (jQuery(':focus').attr('id') == 'birthdate') {
                        jQuery("#ui-datepicker-div").hide();
                        break;
                    }
                    else {
                        NavigatorController.stepBackward();
                    }
                }
            }

        }
    </script>
    <style>
    body {
        margin-top: 20px;
    }

    .toast-item {
        background-color: #222;
    }

    .col1, .col2, .col3, .col4, .col5, .col6, .col7, .col8, .col9, .col10, .col11, .col12 {
        color: #555;
        text-align: left;
    }

    input[type="text"],
    input[type="password"] {
        width: 100% !important;
        border: 1px solid #aaa;
        border-radius: 5px !important;
        box-shadow: none !important;
        box-sizing: border-box !important;
        height: 38px !important;
        line-height: 18px !important;
        padding: 8px 10px !important;
    }

    input[type="textarea"] {
        width: 100% !important;
        border: 1px solid #aaa;
        border-radius: 5px !important;
        box-shadow: none !important;
        box-sizing: border-box !important;
        height: 38px !important;
        line-height: 18px !important;
        padding: 8px 10px !important;
    }

    textarea {
        border: 1px solid #aaa;
        border-radius: 5px !important;
        box-shadow: none !important;
        box-sizing: border-box !important;
        line-height: 18px !important;
        padding: 8px 10px !important;
    }

    form select {
        width: 100%;
        border: 1px solid #e4e4e4;
        border-radius: 5px !important;
        box-shadow: none !important;
        box-sizing: border-box !important;
        height: 38px !important;
        line-height: 18px !important;
        padding: 8px 10px !important;
    }

    .boostr {
        border-left: 1px solid #e4e4e4 !important;
        margin-top: 4px !important;
        padding-left: 10px !important;
        right: 10px !important;
    }

    label span {
        color: #ff0000;
        padding-left: 5px;
    }

    @media all and (max-width: 768px) {
        .onerow {
            margin: 0 0 100px;
        }
    }

    .cell {
        border-top: 1px solid #d3d3d3;
        padding: 20px;
    }

    td.border {
        border-width: 1px;
        border-right: 0px;
        border-bottom: 1px;
        border-color: lightgrey;
        border-style: solid;
    }

    td.bottom {
        border-width: 1px;
        border-bottom: 1px;
        border-right: 0px;
        border-top: 0px;
        border-left: 0px;
        border-color: lightgrey;
        border-style: solid;
    }

    .floatLeft {
        width: 47%;
        float: left;
    }

    .floatRight {
        width: 52%;
        float: right;
    }

    .floatBottom {
        position: absolute;
        bottom: 0;
        height: 100px;
        margin-top: 100px;
        right: 50%;
    }

    .container {
        overflow: hidden;
    }

    input, select, textarea {

        border-width: 1px;
        border-right: 1px;
        border-left: 1px;
        border-top: 1px;
        border-bottom: 1px;
        border-color: black;
        border-style: solid;

    }

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
        width: 45em;
    }

    .red-border {
        border: 1px solid #f00 !important;
    }

    .myh2,
    .tasks-list {
        margin: 0;
        padding: 0;
        border: 0;
        font-size: 100%;
        font: inherit;
        vertical-align: baseline;
    }

    .tasks {
        font: 13px/20px 'Lucida Grande', Verdana, sans-serif;
        color: #404040;
        width: 100%;
        background: white;
        border: 1px solid #cdd3d7;
        border-radius: 4px;
        -webkit-box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    }

    .tasks-header {
        position: relative;
        line-height: 24px;
        padding: 7px 15px;
        color: #5d6b6c;
        text-shadow: 0 1px rgba(255, 255, 255, 0.7);
        background: #f0f1f2;
        border-bottom: 1px solid #d1d1d1;
        border-radius: 3px 3px 0 0;
        background-image: -webkit-linear-gradient(top, #f5f7fd, #e6eaec);
        background-image: -moz-linear-gradient(top, #f5f7fd, #e6eaec);
        background-image: -o-linear-gradient(top, #f5f7fd, #e6eaec);
        background-image: linear-gradient(to bottom, #f5f7fd, #e6eaec);
        -webkit-box-shadow: inset 0 1px rgba(255, 255, 255, 0.5), 0 1px rgba(0, 0, 0, 0.03);
        box-shadow: inset 0 1px rgba(255, 255, 255, 0.5), 0 1px rgba(0, 0, 0, 0.03);
    }

    .tasks-title {
        line-height: inherit;
        font-size: 14px;
        font-weight: bold;
        color: inherit;
    }

    .tasks-lists {
        position: absolute;
        top: 50%;
        right: 10px;
        margin-top: -11px;
        padding: 10px 4px;
        width: 19px;
        height: 3px;
        font: 0/0 serif;
        text-shadow: none;
        color: transparent;
    }

    .tasks-lists:before {
        content: '';
        display: block;
        height: 3px;
        background: #8c959d;
        border-radius: 1px;
        -webkit-box-shadow: 0 6px #8c959d, 0 -6px #8c959d;
        box-shadow: 0 6px #8c959d, 0 -6px #8c959d;
    }

    .tasks-list-item {
        display: block;
        line-height: 24px;
        padding: 5px 10px;
        cursor: pointer;
        -webkit-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        user-select: none;
    }

    .tasks-list-item + .tasks-list-item {
        border-top: 1px solid #f0f2f3;
    }

    .tasks-list-cb {
        display: none;
    }

    .tasks-list-mark {
        position: relative;
        display: inline-block;
        vertical-align: top;
        margin-right: 0px;
        width: 16px;
        height: 20px;
        border: 2px solid #c4cbd2;
        border-radius: 12px;
    }

    .tasks-list-mark:before {
        content: '';
        display: none;
        position: absolute;
        top: 50%;
        left: 50%;
        margin: -5px 0 0 -6px;
        height: 4px;
        width: 8px;
        border: solid #39ca74;
        border-width: 0 0 4px 4px;
        -webkit-transform: rotate(-45deg);
        -moz-transform: rotate(-45deg);
        -ms-transform: rotate(-45deg);
        -o-transform: rotate(-45deg);
        transform: rotate(-45deg);
    }

    .tasks-list-cb:checked ~ .tasks-list-mark {
        border-color: #39ca74;
    }

    .tasks-list-cb:checked ~ .tasks-list-mark:before {
        display: block;
    }

    .tasks-list-desc {
        font-weight: bold;
        color: #555;
    }

    .tasks-list-cb:checked ~ .tasks-list-desc {
        color: #34bf6e;
    }

    #form-verification-x {
        color: #f00;
        cursor: pointer;
        float: right;
        margin: -10px -22px 0;
    }

    .form-verifier-js {
        padding: 10px 30px;
        -webkit-box-sizing: border-box;
        -moz-box-sizing: border-box;
        -ms-box-sizing: border-box;
        box-sizing: border-box;
        box-shadow: 0 11px 5px -10px rgba(0, 0, 0, 0.3);
        border: 1px solid #F00;
        margin-bottom: 15px;
        display: none;
    }

    .form-verifier-js p {
        padding-top: 5px;
        padding-bottom: 0px;
        margin-bottom: 5px;

    }

    .form-duplicate-js {
        padding: 1px 30px 1px 30px;
        -webkit-box-sizing: border-box;
        -moz-box-sizing: border-box;
        -ms-box-sizing: border-box;
        box-sizing: border-box;
        box-shadow: 0 11px 5px -10px rgba(0, 0, 0, 0.3);
        border: 1px solid #F00;
        margin-bottom: 15px;
    }

    .form-duplicate-js p {
        padding-top: 5px;
        padding-bottom: 0px;
        margin-bottom: 5px;

    }

    .dashboard .info-section {
        margin: 0 5px 5px;
    }

    .dashboard .info-body li {
        padding-bottom: 2px;
    }

    .dashboard .info-body li span {
        margin-right: 10px;
    }

    .dashboard .info-body li small {

    }

    .dashboard .info-body li div {
        width: 150px;
        display: inline-block;
    }

    .addon {
        display: inline-block;
        float: right;
        margin: 10px 0 0 190px;
        position: absolute;
    }
    </style>

</head>


<div class="container">
    <div class="example">
        <ul id="breadcrumbs">
            <li>
                <a href="${ui.pageLink('referenceapplication', 'home')}">
                    <i class="icon-home small"></i></a>
            </li>
            <li>
                <i class="icon-chevron-right link"></i>
                <a href="${ui.pageLink('registration', 'patientRegistration')}">Registration</a>
            </li>
            <li>
                <i class="icon-chevron-right link"></i>
                <a style="cursor:pointer;">Edit Patient</a>
            </li>

            <li>&nbsp;</li>

        </ul>
    </div>

    <div class="patient-header new-patient-header">
        <div class="demographics">
            <h1 class="name" style="border-bottom: 1px solid #ddd;">
                <span>EDIT PATIENT DETAILS &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
            </h1>

            <br>

        </div>

        <div class="identifiers">
            <em>Patient Identifier:</em>
            <span>* ${patient.identifier}</span>
        </div>


        <div class="onepcssgrid-1000">
            <br/><br/>

            <div id="form-verification-failed" class="form-verifier-js">
                <p>Please fill correctly the fields marked with * and/or ensure that dates have been entered in specified format.</p>
            </div>

            <div id="content" class="container">
                <form class="simple-form-ui" id="patientRegistrationForm" method="post">

                    <section id="charges-info2" style="width:74%">
                        <span class="title">Patient Details</span>
                        <fieldset class="no-confirmation">
                            <legend>Demographics</legend>

                            <p>

                            <div class="onerow">
                                <div class="col4">
                                    <label>Surname <span>*</span></label></div>

                                <div class="col4"><label>First Name <span>*</span></label></div>

                                <div class="col4 last"><label>Other Name</label></div>
                            </div>

                            <div class="onerow">
                                <div class="col4">
                                    <field><input type="text" id="surName" name="patient.surName"
                                                  class="required form-textbox1" value="${patient.surName}"/></field>
                                    <input type="hidden" id="selectedRegFeeValue" name="patient.registration.fee"/>
                                    <input type="hidden" id="patientIdnts" name="patient.identifier" value="0"/>
                                </div>

                                <div class="col4">
                                    <field><input type="text" id="firstName" name="patient.firstName"
                                                  class="required form-textbox1" value="${patient.firstName}"/></field>
                                </div>

                                <div class="col4 last">
                                    <field><input type="text" id="otherName" name="patient.otherName"
                                                  class="form-textbox1" value="${patient.otherName}"/></field>
                                </div>
                            </div>

                            <div class="onerow">
                                <div class="col4"><label>Gender<span>*</span></label></div>

                                <div class="col4"><label>Marital Status</label></div>

                                <div class="col4 last"><label>Age or D.O.B<span>*</span></label></div>
                            </div>

                            <div class="onerow">
                                <div class="col4">
                                    <span class="select-arrow" style="width: 100%">
                                        <field>
                                            <select id="patientGender" name="patient.gender"
                                                    class="required form-combo1">
                                                <option value=""></option>
                                                <option value="M">Male</option>
                                                <option value="F">Female</option>
                                            </select>
                                        </field>

                                    </span>
                                </div>

                                <div class="col4">
                                    <span class="select-arrow" style="width: 100%">
                                        <field>
                                            <select id="maritalStatus" name="person.attribute.26" class="form-combo1">
                                                <option value="Marital"></option>
                                                <option value="Single">Single</option>
                                                <option value="Married">Married</option>
                                                <option value="Divorced">Divorced</option>
                                                <option value="Widow">Widow</option>
                                                <option value="Widower">Widower</option>
                                                <option value="Separated">Separated</option>
                                            </select>
                                        </field>
                                    </span>
                                </div>

                                <div class="col4 last">
                                    <field>
                                        <div class="addon"><i class="icon-calendar small">&nbsp;</i></div>
                                        <input type="text" id="birthdate" name="patient.birthdate"
                                               class="required form-textbox1"/>
                                    </field>
                                    <input id="birthdateEstimated" type="hidden" name="patient.birthdateEstimate"
                                           value="true"/>
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
                                    <span class="select-arrow" style="width: 100%">
                                        <field>
                                            <select id="patientReligion"
                                                    name="person.attribute.${personAttributeReligion.id}"
                                                    class="form-combo1">
                                            </select>
                                        </field>
                                    </span>
                                </div>

                                <div class="col4">
                                    &nbsp;
                                </div>

                                <div class="col4 last">
                                    &nbsp;
                                </div>
                            </div>

                            <div class="onerow">
                                <div class="col4"><label>Nationality</label></div>

                                <div class="col4"><label>National ID:</label></div>

                                <div class="col4 last"><label>Passport No.</label></div>
                            </div>


                            <div class="onerow">
                                <div class="col4">
                                    <span class="select-arrow" style="width: 100%">
                                        <field>
                                            <select id="patientNation" name="person.attribute.27"
                                                    onchange="showOtherNationality();" class="form-combo1">
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
                                        </field>
                                    </span>
                                </div>

                                <div class="col4">
                                    <field>
                                        <input type="text" id="patientNationalId" name="person.attribute.20"
                                               onblur="submitNationalID();" class="form-textbox1"/>
                                    </field>
                                    <span type="text" style="color: red;" id="nationalIdValidationMessage"></span>

                                    <div id="divForNationalId"></div>
                                </div>

                                <div class="col4 last">
                                    <field>
                                        <input type="text" id="passportNumber" name="person.attribute.38"
                                               onblur="submitPassportNumber();" class="form-textbox1"/>
                                    </field>
                                    <span style="color: red;" id="passportNumberValidationMessage"></span>

                                    <div id="divForpassportNumber"></div>
                                </div>
                            </div>

                            <div class="onerow">
                                <div class="col4" style="padding-top: 5px;">
                                    <span id="otherNationality">
                                        <label for="otherNationalityId" style="margin:0px;">Specify Other</label>
                                        <field><input type="text" id="otherNationalityId" name="person.attribute.39"
                                                      placeholder="Please specify" class="form-textbox"/></field>

                                    </span>
                                </div>

                                <div class="col4">&nbsp;</div>

                                <div class="col4 last">&nbsp;</div>
                            </div>

                            <div class="onerow" style="margin-top: 50px">
                                <a class="button confirm" style="float:right; display:inline-block;"
                                   onclick="goto_next_tab(1);">
                                    <span>NEXT PAGE</span>
                                </a>
                            </div>
                        </p>

                            <div class="selectdiv" id="selected-diagnoses"></div>

                        </fieldset>
                        <fieldset style="min-width: 500px; width: auto" class="no-confirmation">
                            <legend>Contact Info</legend>

                            <p>


                            <h2>Patient Contact Information</h2>

                            <div class="onerow">
                                <div class="col4"><label>Contact Number</label></div>

                                <div class="col4"><label>Email Address</label></div>

                                <div class="col4 last"><label>Physical Address <span>*</span></label></div>
                            </div>

                            <div class="onerow">
                                <div class="col4">
                                    <field><input type="text" id="patientPhoneNumber" name="person.attribute.16"
                                                  class="form-textbox1"/></field>
                                </div>

                                <div class="col4">
                                    <field><input type="text" id="patientEmail" name="person.attribute.37"
                                                  class="form-textbox1"/></field>
                                </div>

                                <div class="col4 last">
                                    <field><input type="text" id="patientPostalAddress"
                                                  name="patient.address.postalAddress" class="required form-textbox1"/>
                                    </field>
                                </div>
                            </div>

                            <div class="onerow">
                                <div class="col4"><label>County</label></div>

                                <div class="col4"><label>Sub-County</label></div>

                                <div class="col4 last"><label>Location</label></div>
                            </div>

                            <div class="onerow">
                                <div class="col4">
                                    <span class="select-arrow" style="width: 100%">
                                        <field>
                                            <select id="districts" name="patient.address.district"
                                                    onChange="PAGE.changeDistrict();"
                                                    class="form-combo1">
                                            </select>
                                        </field>
                                    </span>
                                </div>

                                <div class="col4">
                                    <span class="select-arrow" style="width: 100%">
                                        <field>
                                            <select id="upazilas" name="patient.address.upazila"
                                                    onChange="PAGE.changeUpazila();" class="form-combo1"></select>
                                        </field>
                                    </span>

                                </div>

                                <div class="col4 last">
                                    <span class="select-arrow" style="width: 100%">
                                        <field>
                                            <select id="locations" name="patient.address.location"
                                                    class="form-combo1"></select>
                                        </field>
                                    </span>
                                </div>
                            </div>

                            <div class="onerow">
                                <div class="col4"><label>Village</label></div>

                                <div class="col4"><label></label></div>

                                <div class="col4 last"><label></label></div>
                            </div>

                            <div class="onerow">
                                <div class="col4">
                                    <field>
                                        <input type="text" id="chiefdom"
                                               name="person.attribute.${personAttributeChiefdom.id}"
                                               class="form-textbox1"/>
                                    </field>
                                </div>

                                <div class="col4">&nbsp;</div>

                                <div class="col4 last">&nbsp;</div>
                            </div>

                            <h2>&nbsp;</h2>

                            <h2>Next of Kin Details</h2>

                            <div class="onerow">
                                <div class="col4"><label>Relative Name <span>*</span></label></div>

                                <div class="col4"><label>Relationship <span>*</span></label></div>

                                <div class="col4 last"><label>Physical Address</label></div>
                            </div>

                            <div class="onerow">
                                <div class="col4">
                                    <field><input type="text" id="patientRelativeName" name="person.attribute.8"
                                                  class="required form-textbox1"/></field>
                                </div>

                                <div class="col4">
                                    <span class="select-arrow" style="width: 100%">
                                        <field>
                                            <select id="relationshipType" name="person.attribute.15"
                                                    class="required form-combo1">
                                                <option value=""></option>
                                                <option value="Parent">Parent</option>
                                                <option value="Spouse">Spouse</option>
                                                <option value="Guardian">Guardian</option>
                                                <option value="Friend">Friend</option>
                                                <option value="Other">Other</option>
                                            </select>
                                        </field>
                                    </span>
                                </div>

                                <div class="col4 last">
                                    <field><input type="text" id="relativePostalAddress" name="person.attribute.28"
                                                  class="form-textbox1"/></field>
                                </div>
                            </div>

                            <div class="onerow" style="margin-top: 10px">
                                <div class="col4"><label></label></div>

                                <div class="col4"><label></label></div>

                                <div class="col4 last">
                                    <field>
                                        <input id="sameAddress" type="checkbox"/> Same as Patient
                                    </field>
                                </div>
                            </div>

                            <div class="onerow" style="margin-top: 50px">
                                <a class="button task" onclick="goto_previous_tab(2);">
                                    <span style="padding: 15px;">PREVIOUS</span>
                                </a>

                                <a class="button confirm" style="float:right; display:inline-block;"
                                   onclick="goto_next_tab(2);">
                                    <span>NEXT PAGE</span>
                                </a>
                            </div>
                        </p>
                        </fieldset>


                        <fieldset style="min-width: 500px; width: auto" class="no-confirmation">
                            <p>
                                <legend>Payment Category</legend>

                            <div>
                                <h2>Patient Payment Category</h2>

                                <div class="onerow">
                                    <div class="col4">
                                        <div class="tasks">
                                            <header class="tasks-header">
                                                <span class="tasks-title">Patients Category</span>
                                                <a class="tasks-lists"></a>
                                            </header>

                                            <div class="tasks-list">
                                                <label class="tasks-list-item">
                                                    <input style="display:none!important" type="radio" name="paym_1"
                                                           value="1" onchange="LoadPayCatg();" class="tasks-list-cb"
                                                           checked>
                                                    <span class="tasks-list-mark"></span>
                                                    <span class="tasks-list-desc">PAYING</span>
                                                </label>
                                                <label class="tasks-list-item">
                                                    <input style="display:none!important" type="radio" name="paym_1"
                                                           value="2" onchange="LoadPayCatg();" class="tasks-list-cb">
                                                    <span class="tasks-list-mark"></span>
                                                    <span class="tasks-list-desc">NON-PAYING</span>
                                                </label>
                                                <label class="tasks-list-item">
                                                    <input style="display:none!important" type="radio" name="paym_1"
                                                           value="3" onchange="LoadPayCatg();" class="tasks-list-cb">
                                                    <span class="tasks-list-mark"></span>
                                                    <span class="tasks-list-desc">SPECIAL SCHEMES</span>
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col4">
                                        <div class="tasks">
                                            <header class="tasks-header">
                                                <span id="tasktitle" class="tasks-title">Paying Category</span>
                                                <a class="tasks-lists"></a>
                                            </header>

                                            <div class="tasks-list">
                                                <label class="tasks-list-item">
                                                    <input style="display:none!important" type="radio" name="paym_2"
                                                           id="paym_201" value="1" onchange="LoadPayCatgMode();"
                                                           class="tasks-list-cb" checked>
                                                    <span class="tasks-list-mark"></span>
                                                    <span class="tasks-list-desc" id="ipaym_11">GENERAL</span>
                                                </label>
                                                <label class="tasks-list-item">
                                                    <input style="display:none!important" type="radio" name="paym_2"
                                                           id="paym_202" value="2" onchange="LoadPayCatgMode();"
                                                           class="tasks-list-cb">
                                                    <span class="tasks-list-mark"></span>
                                                    <span class="tasks-list-desc" id="ipaym_12">CHILD UNDER 5YRS</span>
                                                </label>
                                                <label class="tasks-list-item">
                                                    <input style="display:none!important" type="radio" name="paym_2"
                                                           id="paym_203" value="3" onchange="LoadPayCatgMode();"
                                                           class="tasks-list-cb">
                                                    <span class="tasks-list-mark"></span>
                                                    <span class="tasks-list-desc" id="ipaym_13">EXPECTANT MOTHER</span>
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col4 last">
                                        <div class="tasks">
                                            <header class="tasks-header">
                                                <span id="summtitle1" class="tasks-title">Summary</span>
                                                <a class="tasks-lists"></a>
                                            </header>
                                        </div>

                                        <span id="universitydiv" class="select-arrow" style="width: 100%">
                                            <field><select style="width: 101%;" name="person.attribute.47"
                                                           id="university">&nbsp;</select></field>
                                        </span>

                                        <field><input type="text" id="modesummary" name="modesummary" value="N/A"
                                                      placeholder="WAIVER NUMBER" readonly=""
                                                      style="width: 101%!important"/></field>
                                    </div>
                                </div>


                                <h2></h2>

                                <div class="onerow" style="margin-top: 150px">
                                    <a class="button task ui-tabs-anchor" onclick="goto_previous_tab(3);">
                                        <span style="padding: 15px;">PREVIOUS</span>
                                    </a>

                                    <a class="button confirm" onclick="PAGE.submit();"
                                       style="float:right; display:inline-block; margin-left: 5px;">
                                        <span>FINISH</span>
                                    </a>

                                    <a class="button cancel" onclick="window.location.href = window.location.href"
                                       style="float:right; display:inline-block;"/>
                                    <span>RESET</span>
                                </a>
                                </div>

                                <div class="onerow" style="display:none!important;">
                                    <div class="col4">
                                        <input id="paying" type="checkbox" name="person.attribute.14" value="Paying"
                                               checked/> Paying
                                    </div>

                                    <div class="col4">
                                        <input id="nonPaying" type="checkbox" name="person.attribute.14"
                                               value="Non-Paying"/> Non-Paying
                                    </div>

                                    <div class="col4 last">
                                        <input id="specialSchemes" type="checkbox" name="person.attribute.14"
                                               value="Special Schemes"/> Special Schemes
                                    </div>

                                    <input type="checkbox" name="mlcCaseYes" id="mlcCaseYes">
                                    <input id="mlcCaseNo" type="checkbox" name="mlcCaseNo"/>
                                    <input id="referredYes" type="checkbox" name="referredYes"/>
                                    <input id="referredNo" type="checkbox" name="referredNo"/>

                                    <input id="triageRoom" type="checkbox" name="triageRoom"/>
                                    <input id="opdRoom" type="checkbox" name="opdRoom"/>
                                    <input id="specialClinicRoom" type="checkbox" name="specialClinicRoom"/>
                                </div>

                                <div class="onerow" style="display:none!important;">
                                    <div class="col4">&nbsp;
                                        <span id="payingCategoryField">
                                            <span class="select-arrow" style="width: 100%">
                                                <select id="payingCategory" name="person.attribute.44"
                                                        onchange="payingCategorySelection();"
                                                        class="form-combo1" style="display:block!important"></select>
                                            </span>
                                        </span>

                                    </div>

                                    <div class="col4">&nbsp;
                                        <span id="nonPayingCategoryField">
                                            <span class="select-arrow" style="width: 100%">
                                                <select id="nonPayingCategory" name="person.attribute.45"
                                                        onchange="nonPayingCategorySelection();"
                                                        class="form-combo1" style="display:block!important"></select>
                                            </span>
                                        </span>

                                    </div>

                                    <div class="col4 last">&nbsp;
                                        <span id="specialSchemeCategoryField">
                                            <span class="select-arrow" style="width: 100%">
                                                <select id="specialScheme" name="person.attribute.46"
                                                        onchange="specialSchemeSelection();"
                                                        class="form-combo1" style="display:block!important"></select>
                                            </span>

                                        </span>
                                    </div>
                                </div>
                            </div>
                        </p>
                        </fieldset>

                    </section>


                    <div id="confirmation" style="width:74%; padding-top: 0px;">
                        <span id="confirmation_label" class="title">Confirmation</span>

                        <div class="dashboard onerow">
                            <div class="info-section">
                                <div class="info-header">
                                    <i class="icon-diagnosis"></i>

                                    <h3>Patient Summary</h3>
                                </div>

                                <div class="info-body">
                                    <ul>
                                        <li><span class="status active"></span>

                                            <div>Patient ID:</div>        <small id="summ_idnt">/</small></li>
                                        <li><span class="status active"></span>

                                            <div>Names:</div>            <small id="summ_name">/</small></li>
                                        <li><span class="status active"></span>

                                            <div>Age:</div>                <small id="summ_ages">/</small></li>
                                        <li><span class="status active"></span>

                                            <div>Gender:</div>            <small id="summ_gend">/</small></li>
                                        <li><span class="status active"></span>

                                            <div>Pay Category:</div>    <small id="summ_pays">/</small></li>
                                        <li><span class="status active"></span>

                                            <div>Registration Fee:</div>    <small id="summ_fees">/</small></li>
                                    </ul>

                                </div>
                            </div>
                        </div>

                        <div class="onerow" style="margin-top: 150px">
                            <a class="button task ui-tabs-anchor" onclick="goto_previous_tab(4);">
                                <span style="padding: 15px;">PREVIOUS</span>
                            </a>

                            <a class="button confirm" onclick="PAGE.submit();"
                               style="float:right; display:inline-block; margin-left: 5px;">
                                <span>FINISH</span>
                            </a>

                            <a class="button cancel" onclick="window.location.href = window.location.href"
                               style="float:right; display:inline-block;"/>
                            <span>RESET</span>
                        </a>
                        </div>
                    </div>
                </form>
            </div>

        </div>
    </div>
</div>