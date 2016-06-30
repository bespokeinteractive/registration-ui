<openmrs:globalProperty var="userLocation" key="hospital.location_user" defaultValue="false"/>

<script type="text/javascript">
    var MODEL, _attributes;
    jQuery(document).ready(function () {


        var _attributes = new Array();
        <% patient.attributes.each { k, v -> %>
        _attributes[${k}] = '${v}';
        <%}%>

        var _observations = new Array();
        var observations = "${observations}";
        jQuery.each(observations, function (key, value) {
            _observations[key] = value;
        });

        /**
         ** VALUES FROM MODEL
         **/
        MODEL = {
            patientId: "${patient.patientId}",
            encounterId: "${encounterId}",
            patientIdentifier: "${patient.identifier}",
            patientName: "${patient.fullname}",
            patientAge: "${patient.age}",
            patientGender: "${patient.gender}",
            patientAddress: "${patient.address}",
            patientAttributes: _attributes,
            observations: _observations,
            currentDateTime: "${currentDateTime}",
            TRIAGE: "${TRIAGE}",
            OPDs: "${OPDs}",
            SPECIALCLINIC: "${SPECIALCLINIC}",
            MEDICOLEGALCASE: "${MEDICOLEGALCASE}",
            selectedTRIAGE: "${selectedTRIAGE}",
            selectedOPD: "${selectedOPD}",
            selectedSPECIALCLINIC: "${selectedSPECIALCLINIC}",
            selectedMLC: "${selectedMLC}",
            registrationFee: "${registrationFee}",
            dueDate: "${dueDate}",
            daysLeft: "${daysLeft}",
            firstTimeVisit: "${firstTimeVisit}",
            revisit: "${revisit}",
            reprint: "${reprint}",
            selectedPaymentCategory: "${selectedPaymentCategory}",
            specialSchemeName: "${specialSchemeName}",
            create: "${create}",
            creates: "${creates}"
        };


        jQuery("#save").hide();
        jQuery("#patientId").val(MODEL.patientId);
        jQuery("#revisit").val(MODEL.revisit);
        jQuery("#identifier").html(MODEL.patientIdentifier);
        jQuery("#age").html(MODEL.patientAge);
        jQuery("#name").html(MODEL.patientName);
        jQuery("#printablePaymentCategoryRow").hide();
        jQuery("#printableRoomToVisitRow").hide();
        jQuery("#fileNumberRowField").hide();
        jQuery("#printableFileNumberRow").hide();

        jQuery("#mlc").hide();

        jQuery("#buySlip").hide();

        jQuery("#specialSchemeNameField").hide();

        jQuery("#triageField").hide();
        jQuery("#opdWardField").hide();
        jQuery("#specialClinicField").hide();

        jQuery("#nationalId").html(MODEL.patientAttributes[20]);
        jQuery("#phoneNumber").html(MODEL.patientAttributes[16]);
        jQuery("#maritalStatus").html(MODEL.patientAttributes[26]);
        jQuery("#gender").html(MODEL.patientGender);
        jQuery("#datetime").html(MODEL.currentDateTime);
        jQuery("#patientName").html(MODEL.patientName);

        MODEL.TRIAGE = " ,Please Select Triage to Visit|" + MODEL.TRIAGE;
        PAGE.fillOptions("#triage", {
            data: MODEL.TRIAGE,
            delimiter: ",",
            optionDelimiter: "|"
        });

        MODEL.OPDs = " ,Please Select OPD to Visit|" + MODEL.OPDs;
        PAGE.fillOptions("#opdWard", {
            data: MODEL.OPDs,
            delimiter: ",",
            optionDelimiter: "|"
        });

        MODEL.SPECIALCLINIC = " ,Please Select Special Clinic to Visit|" + MODEL.SPECIALCLINIC;
        PAGE.fillOptions("#specialClinic", {
            data: MODEL.SPECIALCLINIC,
            delimiter: ",",
            optionDelimiter: "|"
        });

        MODEL.MEDICOLEGALCASE = " ,Please Select MEDICO LEGAL CASE|" + MODEL.MEDICOLEGALCASE;
        PAGE.fillOptions("#mlc", {
            data: MODEL.MEDICOLEGALCASE,
            delimiter: ",",
            optionDelimiter: "|"
        });

        // Set the selected triage
        if (!StringUtils.isBlank(MODEL.selectedTRIAGE)) {
            jQuery("#triageField").show();
            jQuery("#triage").val(MODEL.selectedTRIAGE);
            jQuery("#triage").attr("disabled", "disabled");
        }

        // Set the selected OPD
        if (!StringUtils.isBlank(MODEL.selectedOPD)) {
            jQuery("#opdWardField").show();
            jQuery("#opdWard").val(MODEL.selectedOPD);
            jQuery("#opdWard").attr("disabled", "disabled");
        }

        // Set the selected SPECIAL CLINIC
        if (!StringUtils.isBlank(MODEL.selectedSPECIALCLINIC)) {
            jQuery("#specialClinicField").show();
            jQuery("#specialClinic").val(MODEL.selectedSPECIALCLINIC);
            jQuery("#specialClinic").attr("disabled", "disabled");
        }

        if (!StringUtils.isBlank(MODEL.selectedMLC)) {
            jQuery("#mlc").show();
            jQuery("#mlc").val(MODEL.selectedMLC);
            jQuery("#mlc").attr("disabled", "disabled");
        }


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

        jQuery("#triageRoom").click(function () {
            VALIDATORS.triageRoomCheck();
        });
        jQuery("#opdRoom").click(function () {
            VALIDATORS.opdRoomCheck();
        });
        jQuery("#specialClinicRoom").click(function () {
            VALIDATORS.specialClinicRoomCheck();
        });

        if (!StringUtils.isBlank(MODEL.selectedTRIAGE) || !StringUtils.isBlank(MODEL.selectedOPD) || !StringUtils.isBlank(MODEL.selectedSPECIALCLINIC)) {
            jQuery("#triageRoomField").hide();
            jQuery("#opdRoomField").hide();
            jQuery("#specialClinicRoomField").hide();
        }


        if (MODEL.patientAttributes[14] == "Paying") {
            var a = MODEL.patientAttributes[14];
            var b = MODEL.patientAttributes[44];
            var c = a + "/" + b;
            jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + c + "</span>");
        }

        if (MODEL.patientAttributes[14] == "Non-Paying") {
            var a = MODEL.patientAttributes[14];
            var b = MODEL.patientAttributes[45];
            if (MODEL.patientAttributes[45] == "NHIF CIVIL SERVANT") {
                var c = MODEL.patientAttributes[34];
                var d = a + "/" + b + "/" + c;
                jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + d + "</span>");
            }
            else {
                var c = a + "/" + b;
                jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + c + "</span>");
            }
        }

        if (MODEL.patientAttributes[14] == "Special Schemes") {
            var a = MODEL.patientAttributes[14];
            var b = MODEL.patientAttributes[46];
            if (MODEL.patientAttributes[46] == "STUDENT SCHEME") {
                var c = MODEL.patientAttributes[47];
                var d = MODEL.patientAttributes[42];
                var e = a + "/" + b + "/" + c + "/" + d;
                jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + e + "</span>");
            }
            else if (MODEL.patientAttributes[46] == "WAIVER CASE") {
                var c = MODEL.patientAttributes[32];
                var d = a + "/" + b + "/" + c;
                jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + d + "</span>");
            }
            else {
                var c = a + "/" + b;
                jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + c + "</span>");
            }
        }
        jQuery("#printablePaymentCategoryRow").show();

        // Set data for first time visit,revisit,reprint
        if (MODEL.firstTimeVisit == "true") {
            jQuery("#reprint").hide();
            jQuery("#printableRegistrationFeeForFirstVisitAndReprintRow").hide();

            if (!StringUtils.isBlank(MODEL.selectedMLC)) {
                jQuery("#mlcCaseYesField").hide();
                jQuery("#mlcCaseNoRowField").hide();
            }
            else {
                jQuery("#medicoLegalCaseRowField").hide();
                jQuery("#mlcCaseNoRowField").hide();
            }

            jQuery("#triageRowField").hide();
            jQuery("#opdRowField").hide();
            jQuery("#specialClinicRowField").hide();

            jQuery("#printableRoomToVisitRow").show();
            if (!StringUtils.isBlank(MODEL.selectedTRIAGE)) {
                jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#triage option:checked").html() + "</span>");
            }
            if (!StringUtils.isBlank(MODEL.selectedOPD)) {
                jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#opdWard option:checked").html() + "</span>");
            }
            if (!StringUtils.isBlank(MODEL.selectedSPECIALCLINIC)) {
                jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#specialClinic option:checked").html() + "</span>");
                jQuery("#printableFileNumber").empty();
                if (MODEL.patientAttributes[43] != undefined) {
                    jQuery("#printableFileNumber").append("<span style='margin:5px;'>" + MODEL.patientAttributes[43] + "</span>");
                }
                jQuery("#printableFileNumberRow").show();
            }

        }
        else if (MODEL.revisit == "true") {
            jQuery("#reprint").hide();
            jQuery("#printableRegistrationFeeForRevisitRow").hide();
            jQuery("#selectedPaymentCategory").val(MODEL.patientAttributes[14]);
            if (MODEL.patientAttributes[14] == "Paying") {
                jQuery("#selectedPaymentSubCategory").val(MODEL.patientAttributes[44]);
            }
            if (MODEL.patientAttributes[14] == "Non-Paying") {
                jQuery("#selectedPaymentSubCategory").val(MODEL.patientAttributes[45]);
            }
            if (MODEL.patientAttributes[14] == "Special Schemes") {
                jQuery("#selectedPaymentSubCategory").val(MODEL.patientAttributes[46]);
            }

        }
        else if (MODEL.reprint == "true") {

            jQuery("#printableRegistrationFeeForFirstVisitAndReprintRow").hide();
            if (!StringUtils.isBlank(MODEL.selectedMLC)) {
                jQuery("#mlcCaseYesField").hide();
                jQuery("#mlcCaseNoRowField").hide();
            }
            else {
                jQuery("#medicoLegalCaseRowField").hide();
                jQuery("#mlcCaseNoRowField").hide();
            }

            jQuery("#triageRowField").hide();
            jQuery("#opdRowField").hide();
            jQuery("#specialClinicRowField").hide();

            if (!StringUtils.isBlank(MODEL.selectedMLC)) {
                jQuery("#mlcCaseNoRowField").hide();
            }
            else {
                jQuery("#medicoLegalCaseRowField").hide();
                jQuery("#mlcCaseNoRowField").hide();
            }

            jQuery("#printableRoomToVisitRow").show();
            if (!StringUtils.isBlank(MODEL.selectedTRIAGE)) {
                jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#triage option:checked").html() + "</span>");

            }
            if (!StringUtils.isBlank(MODEL.selectedOPD)) {
                jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#opdWard option:checked").html() + "</span>");
            }
            if (!StringUtils.isBlank(MODEL.selectedSPECIALCLINIC)) {
                jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#specialClinic option:checked").html() + "</span>");
                jQuery("#printableFileNumber").empty();
                if (MODEL.patientAttributes[43] != undefined) {
                    jQuery("#printableFileNumber").append("<span style='margin:5px;'>" + MODEL.patientAttributes[43] + "</span>");
                }
                jQuery("#printableFileNumberRow").show();
            }

            //alert("hmmm");
            if ((MODEL.create != 0) && (MODEL.creates != 0)) { //alert("hiii");
                jQuery("#patientrevisit").hide();
            }
            else { //alert("hello");
                jQuery("#patientrevisit").show();
            }

            jQuery("#printSlip").hide();
            jQuery("#save").hide();
        }

    });

    /**
     ** PAGE METHODS
     **/
    PAGE = {
        /** Validate and submit */
        submit: function (reprint) {

            if (PAGE.validate()) {

                // Hide print button
                jQuery("#printSlip").hide();
                jQuery("#reprint").hide();

                if (MODEL.revisit == "true") {

                    if (jQuery("#mlcCaseYes").is(':checked')) {
                        jQuery("#mlcCaseNoRowField").hide();
                        jQuery("#mlcCaseYesField").hide();
                        jQuery("#mlc").hide();
                        jQuery("#mlc").after("<span style='border:0px'>" + jQuery("#mlc option:checked").html() + "</span>");
                    }
                    else if (jQuery("#mlcCaseNo").is(':checked')) {
                        jQuery("#medicoLegalCaseRowField").hide();
                        jQuery("#mlcCaseNoRowField").hide();
                    }

                    jQuery("#triageRowField").hide();
                    jQuery("#opdRowField").hide();
                    jQuery("#specialClinicRowField").hide();

                    if (jQuery("#paying").is(':checked')) {
                        jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + jQuery("#paying").val() + "</span>");
                    }
                    if (jQuery("#nonPaying").is(':checked')) {
                        jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + jQuery("#nonPaying").val() + "</span>");
                    }

                    if (jQuery("#specialSchemes").is(':checked')) {
                        jQuery("#printablePaymentCategory").append("<span style='border:0px'>" + jQuery("#specialSchemes").val() + "</span>");
                    }

                    jQuery("#printablePaymentCategoryRow").show();

                    jQuery("#printableRoomToVisitRow").show();
                    if (jQuery("#triageRoom").is(':checked')) {
                        jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#triage option:checked").html() + "</span>");
                    }
                    if (jQuery("#opdRoom").is(':checked')) {
                        jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#opdWard option:checked").html() + "</span>");
                    }
                    if (jQuery("#specialClinicRoom").is(':checked')) {
                        jQuery("#printableRoomToVisit").append("<span style='border:0px'>" + jQuery("#specialClinic option:checked").html() + "</span>");
                        jQuery("#printableFileNumber").empty();
                        jQuery("#printableFileNumber").append("<span style='border:0px'>" + jQuery("#fileNumber").val() + "</span>");
                        jQuery("#fileNumberRowField").hide();
                        jQuery("#printableFileNumberRow").show();
                    }

                }

                // submit form and print
                if (!reprint) {
                    jQuery.ajax({
                        type: "GET",
                        url: '${ ui.actionLink("registration", "newPatientRegistrationForm", "savePatientInfo") }',
                        dataType: "json",
                        data: ({
                            patientId: MODEL.patientId,
                            encounterId: MODEL.encounterId

                        }),
                        success: function (data) {
                            PAGE.print();
                            window.location.href = '${ ui.pageLink("registration", "patientRegistration")}';
                        }
                    });
//                    jQuery("#patientInfoForm").ajaxSubmit({
//                        success: function (responseText, statusText, xhr) {
//
//                            if (responseText == "success") {
//                                alert("Hit the function ");
//                                PAGE.print();
//                                window.location.href = getContextPath() + "/findPatient.htm";
//                            }
//                        }
//                    });
                } else {
                    PAGE.print();
//                    window.location.href = getContextPath() + "/findPatient.htm";
                    window.location.href = '${ ui.pageLink("registration", "patientRegistration")}';
                }

            }
        },

        // Print the slip
        print: function () {
            var myStyle = '<link rel="stylesheet" href="http://localhost:8080/openmrs/ms/uiframework/resource/registration/styles/onepcssgrid.css" />';
            var printDiv = jQuery("#patientInfoPrintArea").html();
            var printWindow = window.open('', '', 'height=500,width=400');
            
			printWindow.document.write('<html><head><title>Patient Information</title>');
            printWindow.document.write('<body style="font-family: Dot Matrix Normal,Arial,Helvetica,sans-serif; font-size: 12px; font-style: normal;">');
            printWindow.document.write(printDiv);
            printWindow.document.write('</body>');
            printWindow.document.write('</html>');
            printWindow.print();
            printWindow.close();

//            jQuery("#patientInfoPrintArea").printArea({
//                mode: "popup",
//                popClose: true
//            });
        },

        // harsh #244 Added a save button.
        save: function () {
            if (PAGE.validate()) {
                var save = document.getElementById("save");
                if (save == save) {
                    document.getElementById("save").disabled = true;
                }
                jQuery("#patientInfoForm").ajaxSubmit({
                    success: function (responseText, statusText, xhr) {
                        if (responseText == "success") {

                            window.location.href = getContextPath() + "/findPatient.htm";
                        }
                    }
                });
            }
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
                            jQuery(divId).append("<option value='" + value + "'>" + value + "</option>");
                        }
                    });
                } else {
                    jQuery.each(option.data, function (index, value) {
                        if (value.length > 0) {
                            jQuery(divId).append("<option value='" + option.index[index] + "'>" + value + "</option>");
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
                            jQuery(divId).append("<option value='" + optionValue + "'>" + optionLabel + "</option>");
                        }
                    }
                });
            }
        },

        /** Buy A New Slip */
        buySlip: function () {
            jQuery.ajax({
                type: "GET",
                url: openmrsContextPath + "/module/registration/ajax/buySlip.htm",
                data: ({
                    patientId: MODEL.patientId
                }),
                success: function (data) {
                    window.location.href = window.location.href;
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(thrownError);
                }
            });
        },

        /** Validate Form */
        validate: function () {


            if (MODEL.revisit == "true") {


                if (jQuery("#mlcCaseYes").attr('checked') == false
                        && jQuery("#mlcCaseNo").attr('checked') == false) {
                    alert("You did not choose any of the Medico Legal Case ");
                    return false;
                } else {

                    if (jQuery("#mlcCaseYes").is(':checked')) {
                        if (StringUtils.isBlank(jQuery("#mlc").val())) {
                            alert("Please select the medico legal case");
                            return false;
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
                        if (StringUtils.isBlank(jQuery("#triage").val())) {
                            alert("Please select the triage room to visit");
                            return false;
                        }
                    }
                    else if (jQuery("#opdRoom").attr('checked')) {
                        if (StringUtils.isBlank(jQuery("#opdWard").val())) {
                            alert("Please select the OPD room to visit");
                            return false;
                        }
                    }
                    else {
                        if (StringUtils.isBlank(jQuery("#specialClinic").val())) {
                            alert("Please select the Special Clinic to visit");
                            return false;
                        }
                        /*
                         if (StringUtils.isBlank(jQuery("#fileNumber").val())) {
                         alert("Please enter the File Number");
                         return false;
                         }
                         */
                    }
                }
            }

            return true;
        }
    };

    //ghanshyam  20-may-2013 #1648 capture Health ID and Registration Fee Type
    VALIDATORS = {

        /** CHECK WHEN PAYING CATEGORY IS SELECTED */
        payingCheck: function () {
            if (jQuery("#paying").is(':checked')) {
                jQuery("#nonPaying").removeAttr("checked");

                jQuery("#specialSchemes").removeAttr("checked");
                jQuery("#specialSchemeName").val("");
                jQuery("#specialSchemeNameField").hide();
            }
        },

        /** CHECK WHEN NONPAYING CATEGORY IS SELECTED */
        nonPayingCheck: function () {
            if (jQuery("#nonPaying").is(':checked')) {
                jQuery("#paying").removeAttr("checked");

                jQuery("#specialSchemes").removeAttr("checked");
                jQuery("#specialSchemeName").val("");
                jQuery("#specialSchemeNameField").hide();
            }
        },

        /** CHECK WHEN SPECIAL SCHEME CATEGORY IS SELECTED */
        specialSchemeCheck: function () {
            if (jQuery("#specialSchemes").is(':checked')) {
                jQuery("#paying").removeAttr("checked");

                jQuery("#nonPaying").removeAttr("checked");
                jQuery("#specialSchemeNameField").show();
            }
            else {
                jQuery("#specialSchemeName").val("");
                jQuery("#specialSchemeNameField").hide();
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

        triageRoomCheck: function () {
            if (jQuery("#triageRoom").is(':checked')) {
                jQuery("#opdRoom").removeAttr("checked");
                jQuery("#specialClinicRoom").removeAttr("checked");
                jQuery("#triageField").show();
                jQuery("#opdWard").val("");
                jQuery("#opdWardField").hide();
                jQuery("#specialClinic").val("");
                jQuery("#specialClinicField").hide();
                jQuery("#fileNumberRowField").hide();
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
                jQuery("#fileNumberRowField").hide();
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
                if (!StringUtils.isBlank(jQuery("#specialClinic").val())) {
                    jQuery("#fileNumberRowField").show();
                }
            }
            else {
                jQuery("#specialClinicField").hide();
                jQuery("#fileNumberRowField").hide();
            }
        },


        categoryCheck: function () {

            if (jQuery("#paymentCategory").val() == "Paying") {

                jQuery("#specialSchemeName").val("");
                jQuery("#specialSchemeNameField").hide();

            } else if (jQuery("#paymentCategory").val() == "Non-Paying") {
                jQuery("#specialSchemeName").val("");
                jQuery("#specialSchemeNameField").hide();


            } else if (jQuery("#paymentCategory").val() == "Special Schemes") {
                jQuery("#specialSchemeNameField").show();
            }
        },
    };

    function triageRoomSelection() {
        if (MODEL.patientAttributes[14] == "Paying") {
            if ((MODEL.create == 0)) {  //alert("Patient Revisit within 24 hr");
                // alert("hello");
                jQuery("#selectedRegFeeValue").val(0);
                jQuery("#patientrevisit").show();
                if (MODEL.patientAttributes[44] == "CHILD LESS THAN 5 YEARS") {
                    jQuery("#selectedRegFeeValue").val(0);
                }
            }
            else {
                jQuery("#selectedRegFeeValue").val('${reVisitFee}');
                if (MODEL.patientAttributes[44] == "CHILD LESS THAN 5 YEARS") {
                    jQuery("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
                }
            }
        }

        if (MODEL.patientAttributes[14] == "Non-Paying") {
            jQuery("#selectedRegFeeValue").val(0);
        }

        if (MODEL.patientAttributes[14] == "Special Schemes") {
            jQuery("#selectedRegFeeValue").val(0);
        }

        var selectedRegFeeValue = jQuery("#selectedRegFeeValue").val();
        jQuery("#printableRegistrationFee").empty();
        jQuery("#printableRegistrationFee").append("<span style='margin:5px;'>" + selectedRegFeeValue + "</span>");

    }

    function opdRoomSelection() {
        if ((MODEL.patientAttributes[14] == "Paying")) {
            //	alert("hii");
            if ((MODEL.create == 0)) {
                // alert("Patient Revisit within 24 hr");
                jQuery("#selectedRegFeeValue").val(0);
                jQuery("#patientrevisit").show();

                if (MODEL.patientAttributes[44] == "CHILD LESS THAN 5 YEARS") {
                    jQuery("#selectedRegFeeValue").val(0);
                    //jQuery("#selectedRegFeeValue").show("(Patient Revisit within 24 hr)");
                }
            }
            else {
                jQuery("#selectedRegFeeValue").val('${reVisitFee}');
                if (MODEL.patientAttributes[44] == "CHILD LESS THAN 5 YEARS") {
                    jQuery("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
                }
            }
        }

        if (MODEL.patientAttributes[14] == "Non-Paying") {
            jQuery("#selectedRegFeeValue").val(0);
        }

        if (MODEL.patientAttributes[14] == "Special Schemes") {
            jQuery("#selectedRegFeeValue").val(0);
        }

        var selectedRegFeeValue = jQuery("#selectedRegFeeValue").val();
        jQuery("#printableRegistrationFee").empty();
        jQuery("#printableRegistrationFee").append("<span style='margin:5px;'>" + selectedRegFeeValue + "</span>");

    }

    function specialClinicSelection() {

        if (!StringUtils.isBlank(jQuery("#specialClinic").val())) {
            jQuery("#fileNumberRowField").show();
            if (MODEL.patientAttributes[43] != null) {
                jQuery("#fileNumber").val(MODEL.patientAttributes[43]);
                jQuery("#fileNumber").attr("disabled", "disabled");
            }
        }
        else {
            jQuery("#fileNumberRowField").hide();
        }

        if (MODEL.patientAttributes[14] == "Paying") {
            if ((MODEL.create == 0)) {    //alert("Patient Revisit within 24 hr");
                jQuery("#selectedRegFeeValue").val(0);
                jQuery("#patientrevisit").show();
                if (MODEL.patientAttributes[44] == "CHILD LESS THAN 5 YEARS") {
                    jQuery("#selectedRegFeeValue").val(0);
                }
            }
            else {
                var reVisitRegFee = parseInt('${reVisitFee}');
                var specialClinicRegFee = parseInt('${specialClinicRegFee}');
                var totalRegFee = reVisitRegFee + specialClinicRegFee;
                jQuery("#selectedRegFeeValue").val(totalRegFee);
                if (MODEL.patientAttributes[44] == "CHILD LESS THAN 5 YEARS") {
                    jQuery("#selectedRegFeeValue").val(${childLessThanFiveYearRegistrationFee});
                }
            }
        }

        if (MODEL.patientAttributes[14] == "Non-Paying") {
            jQuery("#selectedRegFeeValue").val(0);
            if (MODEL.patientAttributes[45] == "TB PATIENT") {
                jQuery("#selectedRegFeeValue").val(${specialClinicRegFee});
            }
            if (MODEL.patientAttributes[45] == "CCC PATIENT") {
                jQuery("#selectedRegFeeValue").val(${specialClinicRegFee});
            }
        }

        if (MODEL.patientAttributes[14] == "Special Schemes") {
            jQuery("#selectedRegFeeValue").val(0);
        }

        var selectedRegFeeValue = jQuery("#selectedRegFeeValue").val();
        jQuery("#printableRegistrationFee").empty();
        jQuery("#printableRegistrationFee").append("<span style='margin:5px;'>" + selectedRegFeeValue + "</span>");

    }
</script>

<style>
.donotprint {
    display: none;
}
.spacer {

    font-family: "Dot Matrix Normal", Arial, Helvetica, sans-serif;
    font-style: normal;
    font-size: 12px;
}
.printfont {
    font-family: "Dot Matrix Normal", Arial, Helvetica, sans-serif;
    font-style: normal;
    font-size: 12px;
}
.printlabel{
	display: inline-block;
	width: 200px;
}
.printdata{
	display: inline-block;
}
</style>

<div class="onepcssgrid-1000">
    <div id="patientInfoPrintArea" style="width: 1000px; font-size: 0.2em">
        <center>
            <center>
                <img width="60" height="60" align="center" title="OpenMRS" alt="OpenMRS"
                     src="${ui.resourceLink('registration', 'images/kenya_logo.bmp')}">
            </center>

        </center>

        <form id="patientInfoForm" method="POST" class="spacer">
            <h3><center><u><b>${userLocation}</b></u></center></h3>
            <h4 style="font-size: 1.4em;"><center><b>${typeOfSlip}</b></center></h4>
			<div style="display: block;	margin-left: auto; margin-right: auto; width: 350px">
            <div class="onerow" align="left">
                <div class="col2" align="left" style="display:inline-block; width: 150px">
					<b>Previous Day of Visit:</b>
				</div>
				
                <div class="col2" align="left" style="display: inline-block; width: 150px;">
					<span id="datetime"></span>
				</div>				
            </div>

            <div class="onerow" align="left">
                <div class="col2" align="left" style="display:inline-block; width: 150px"><b>Name:</b></div>
                <div class="col2" align="left" style="display:inline-block; width: 150px"><span id="patientName"></span></div>
            </div>

            <div class="onerow" align="left">
                <div class="col2" align="left" style="display:inline-block; width: 150px"><b>Patient ID:</b></div>
                <div class="col2" align="left" style="display:inline-block; width: 150px""><span id="identifier"></span></div>
            </div>

            <div class="onerow" align="left">
                <div class="col2" align="left" style="display:inline-block; width: 150px"><b>Age:</b></div>
                <div class="col2" align="left" style="display:inline-block; width: 150px""><span id="age"></span></div>
            </div>

            <div class="onerow" align="left">
                <div class="col2" align="left" style="display:inline-block; width: 150px"><b>Gender:</b></div>
                <div class="col2" align="left" style="display:inline-block; width: 150px""><span id="gender"></span></div>
            </div>

            <div class="onerow" align="left" id="printablePaymentCategoryRow">             
                <div class="col2" align="left" style="display:inline-block; width: 150px"><b>Payment Category:</b></div>
                <div class="col2" align="left" style="display:inline-block; width: 150px""><div id="printablePaymentCategory"></div></div>
            </div>

            <div class="onerow" align="left" id="medicoLegalCaseRowField">
                <div class="col2" align="left" style="display:inline-block; width: 150px"><b>Medical Legal Case:</b></div>
                <div class="col2" align="left">
                    <div id="mlcCaseYesField">
                        <input id="mlcCaseYes" type="checkbox" name="mlcCaseYes"/> Yes
                        <select id="mlc" name="patient.mlc" style='width: 152px;'></select>
                    </div>

                    <div id="mlcCaseNoRowField">
                        <div id="mlcCaseNoField">
                            <input id="mlcCaseNo" type="checkbox" name="mlcCaseNo"/> No
                        </div>

                    </div>

                </div>

                <div class="col4 last">&nbsp;</div>
            </div>


            <div class="onerow" align="left" id="triageRowField">
                <div class="col4">&nbsp;</div>

                <div class="col2" align="left" style="display:inline-block; width: 150px"><b>Room to Visit:</b></div>

                <div class="col2" align="left">
                    <div id="triageRoomField">
                        <input id="triageRoom" type="checkbox" name="triageRoom"/> Triage Room &nbsp;
                        <div id="triageField">
                            <select id="triage" name="patient.triage" onchange="triageRoomSelection();"
                                    style='width: 152px;'></select>
                        </div>
                    </div>

                    <div id="opdRowField">
                        <div id="opdRoomField">
                            <input id="opdRoom" type="checkbox" name="opdRoom"/> OPD Room&nbsp;
                            <div id="opdWardField">
                                <select id="opdWard" name="patient.opdWard" onchange="opdRoomSelection();"
                                        style='width: 152px;'></select>
                            </div>
                        </div>
                    </div>

                    <div id="specialClinicRowField">
                        <div id="specialClinicRoomField">
                            <input id="specialClinicRoom" type="checkbox"
                                   name="specialClinicRoom"/> Special Clinic&nbsp;
                            <div id="specialClinicField">
                                <select id="specialClinic" name="patient.specialClinic"
                                        onchange="specialClinicSelection();" style='width: 152px;'></select>
                            </div>
                        </div>
                    </div>

                    <div id="fileNumberRowField">
                        <div>
                            <div id="fileNumberField">
                                <input id="fileNumber" name="person.attribute.43" placeholder="File Numer"
                                       style='width: 152px;'/><span>*</span>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="col4 last">&nbsp;</div>
            </div>

            <div class="onerow" align="left" id="printableRegistrationFeeForRevisitRow">

                <div class="col2" align="left" style="display:inline-block; width: 150px"><b>Registration Fee:</b></div>

                <div class="col2" align="left" style="display:inline-block;">
                    ${registrationFee}.00
                </div>
            </div>

            <div class="onerow" align="left" id="printableRegistrationFeeForFirstVisitAndReprintRow">
                <div class="col2" align="left" style="display:inline-block; width: 150px"><b>Registration Fee:</b></div>

                <div class="col2" align="left" id="printableRegistrationFee"></div>
            </div>

            <div class="onerow" align="left" id="patientrevisit" style="display:none">
                <div class="col2" align="left" style="display:inline-block; width: 150px">&nbsp;</div>

                <div class="col2" align="left" style="display:inline-block; width: 175px"><font color="#ff0000 ">(Patient Revisit with in 24 hr)</font></div>

                
            </div>
			
			 <div class="onerow" align="left" id="printableSpacing">
                <div class="col2" align="left" style="display:inline-block; width: 150px">&nbsp;</div>
                <div class="col2" align="left" style="display:inline-block; width: 150px"></div>
            </div>

            <div class="onerow" align="left" id="printableUserRow">

                <div class="col2" align="left" style="display:inline-block; width: 150px"><b>You were served by:</b></div>

                <div class="col2" align="left" style="display:inline-block;">
                    ${user}
                </div>

                <div class="col4 last">&nbsp;</div>
            </div>

            <div class="onerow" align="left">
                <div class="col4">&nbsp;</div>

                <div class="col2" align="left">
                    <input type="hidden" id="selectedPaymentCategory" name="patient.selectedPaymentCategory"/>
                </div>

                <div class="col2" align="left">
                    <input type="hidden" id="selectedPaymentSubCategory" name="patient.selectedPaymentSubCategory"/>
                </div>

                <div class="col4 last">
                    <input type="hidden" id="selectedRegFeeValue" name="patient.registration.fee"/>
                </div>
            </div>

            <div class="onerow">
                <div class="col4">&nbsp;</div>

                <div class="col2">
                    <span class="button task" id="printSlip" onClick="PAGE.submit(false);" style="width: 45px;">
						<i class="icon-print small"></i>
						Print
					</span>
                </div>

                <div class="col2">
                    <span class="button task" id="reprint" onClick="PAGE.submit(true);" style="width: 60px;">
						<i class="icon-print small"></i>
						Reprint
					</span>
                </div>

                <div class="col4 last">
                    <input id="buySlip" type="button" value="Buy a new slip"
                           onClick="PAGE.buySlip();"/>
                    <input id="save" type="button" value="Save" onClick="PAGE.save();"/>
                    <span id="validationDate"></span>
                </div>
            </div>
		</div>
        </form>
    </div>

</div>

</div>
