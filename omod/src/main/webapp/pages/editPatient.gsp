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

<openmrs:require privilege="Add Patients" otherwise="/login.htm" redirect="/findPatient.htm" />

<%
	def hospitalName = context.administrationService.getGlobalProperty("hospitalcore.hospitalName")
%>

<head>
	<script>
	
	</script>
	
	<style>
		body {
			margin-top: 20px;
		}

		.col1, .col2, .col3, .col4, .col5, .col6, .col7, .col8, .col9, .col10, .col11, .col12 {
			color: #555;
			text-align: left;
		}

		input[type="text"],
		input[type="password"] {
			 width: 100%!important;
			 border: 1px solid #aaa;
			 border-radius: 5px!important;
			 box-shadow: none!important;
			 box-sizing: border-box!important;
			 height: 38px!important;
			 line-height: 18px!important;
			 padding: 8px 10px!important;
		 }
		input[type="textarea"] {
			width: 100%!important;
			border: 1px solid #aaa;
			border-radius: 5px!important;
			box-shadow: none!important;
			box-sizing: border-box!important;
			height: 38px!important;
			line-height: 18px!important;
			padding: 8px 10px!important;
		}
		textarea{
			border: 1px solid #aaa;
			border-radius: 5px!important;
			box-shadow: none!important;
			box-sizing: border-box!important;
			line-height: 18px!important;
			padding: 8px 10px!important;
		}

		form select {
			width:100%;
			border: 1px solid #e4e4e4;
			border-radius: 5px!important;
			box-shadow: none!important;
			box-sizing: border-box!important;
			height: 38px!important;
			line-height: 18px!important;
			padding: 8px 10px!important;
		}
		.boostr{
			border-left: 1px solid #e4e4e4!important;
			margin-top: 4px!important;
			padding-left: 10px!important;
			right: 10px!important;
		}
		label span{
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
		#form-verification-x{
			color: #f00;
			cursor: pointer;
			float: right;
			margin: -10px -22px 0;
		}
		.form-verifier-js {
			padding:10px 30px;
			-webkit-box-sizing:border-box;
			-moz-box-sizing:border-box;
			-ms-box-sizing:border-box;
			box-sizing:border-box;
			box-shadow:0 11px 5px -10px rgba(0,0,0,0.3);
			border: 1px solid #F00;
			margin-bottom: 15px;
			display:none;
		}
		.form-verifier-js p {
			padding-top:5px;
			padding-bottom:0px;
			margin-bottom: 5px;
			
		}
		.form-duplicate-js {
			padding:1px 30px 1px 30px;
			-webkit-box-sizing:border-box;
			-moz-box-sizing:border-box;
			-ms-box-sizing:border-box;
			box-sizing:border-box;
			box-shadow:0 11px 5px -10px rgba(0,0,0,0.3);
			border: 1px solid #F00;
			margin-bottom: 15px;
		}
		.form-duplicate-js p {
			padding-top:5px;
			padding-bottom:0px;
			margin-bottom: 5px;
			
		}
		.dashboard .info-section {
			margin: 0 5px 5px;
		}
		.dashboard .info-body li{
			padding-bottom: 2px;
		}

		.dashboard .info-body li span{
			margin-right:10px;
		}

		.dashboard .info-body li small{
			
		}

		.dashboard .info-body li div{
			width: 150px;
			display: inline-block;
		}
	</style>

</head>



<script type="text/javascript">

    var MODEL;
    jQuery(document).ready(function () {


        // Districts
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
         ** Ghanshyam - Sagar :  date- 15 Dec, 2012. Redmine issue's for Bangladesh : #510 and #511 and #512
         **/
        MODEL = {
            patientId: "${patient.patientId}",
            patientIdentifier: "${patient.identifier}",
            surName: "${patient.surName}",
            firstName: "${patient.firstName}",
            otherName: "${patient.otherName}",
            patientAge: "${patient.age}",
            patientGender: "${patient.gender}",
            patientAddress: "${patient.address}",
            patientBirthdate: "${patient.birthdate}",
            patientAttributes: _attributes,
            districts: _districts,
            upazilas: _upazilas,
            religions: "${religionList}",
            payingCategory: "${payingCategory}",
            nonPayingCategory: "${nonPayingCategory}",
            specialScheme: "${specialScheme}",
            payingCategoryMap: _payingCategoryMap,
            nonPayingCategoryMap: _nonPayingCategoryMap,
            specialSchemeMap: _specialSchemeMap,
            universities: "${universities}"
        };


    });//end of ready function

    /**
     ** VALIDATORS
     **/
    VALIDATORS = {

        /** CHECK WHEN PAYING CATEGORY IS SELECTED */
        payingCheck : function() {
            if (jQuery("#paying").is(':checked')) {
                jQuery("#nonPaying").removeAttr("checked");
                jQuery("#payingCategoryField").show();
                jQuery("#nonPayingCategoryField").hide();
                jQuery("#specialSchemeCategoryField").hide();
                jQuery("#specialSchemes").removeAttr("checked");

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
                jQuery("#payingCategoryField").hide();
                jQuery("#specialSchemeCategoryField").hide();

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
                jQuery("#payingCategoryField").hide();
                jQuery("#nonPayingCategoryField").hide();
                jQuery("#nonPaying").removeAttr("checked");
                jQuery("#specialSchemeCategoryField").show();

                jQuery("#nhifNumberRow").hide();

                var selectedSpecialScheme=jQuery("#specialScheme option:checked").val();
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
            }
            else{
                jQuery("#specialSchemeCategoryField").hide();
                jQuery("#universityRow").hide();
                jQuery("#studentIdRow").hide();
                jQuery("#waiverNumberRow").hide();
            }
        },

        copyaddress : function () {
            if (jQuery("#sameAddress").is(':checked')) {
                jQuery("#relativePostalAddress").val(jQuery("#patientPostalAddress").val());
            }
            else {	jQuery("#relativePostalAddress").val('');
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
        },
    };
	
	var NavigatorController
	jq(function(){
		NavigatorController = new KeyboardController();
	});
	
</script>

<%
   ui.includeJavascript("uicommons", "navigator/validators.js", Integer.MAX_VALUE - 19)
   ui.includeJavascript("uicommons", "navigator/navigator.js", Integer.MAX_VALUE - 20)
   ui.includeJavascript("uicommons", "navigator/navigatorHandlers.js", Integer.MAX_VALUE - 21)
   ui.includeJavascript("uicommons", "navigator/navigatorModels.js", Integer.MAX_VALUE - 21)
   ui.includeJavascript("uicommons", "navigator/exitHandlers.js", Integer.MAX_VALUE - 22) 
%>


<div class="container">
	<div class="example">
		<ul id="breadcrumbs">
			<li>
				<a href="${ui.pageLink('referenceapplication','home')}">
				<i class="icon-home small"></i></a>
			</li>
			<li>
				<i class="icon-chevron-right link"></i>
				<a href="${ui.pageLink('referenceapplication','patientRegistration')}">Registration</a>
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
				<span>EDIT PATIENT &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
			</h1>

			<br>


		</div>

		<div class="identifiers">
			<em>Patient Identifier:</em>
			<span>* KLSJW898347834-01</span>
		</div>


		<div class="onepcssgrid-1000">
			<br/><br/>
			
			<div id="form-verification-failed" class="form-verifier-js">
				<p> Please fill correctly the fields marked with * and/or ensure that dates have been entered in specified format.</p>
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
										<field><input type="text" id="surName" name="patient.surName" class="required form-textbox1"/></field>
										<input type="hidden" id="selectedRegFeeValue" name="patient.registration.fee" />
										<input type="hidden" id="patientIdnts" name="patient.identifier" value="0" 	/>
									</div>

									<div class="col4">
										<field><input type="text" id="firstName" name="patient.firstName" class="required form-textbox1"/></field>
									</div>

									<div class="col4 last">
										<field><input type="text" id="otherName" name="patient.otherName" class="form-textbox1"/></field>
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
												<select id="patientGender" name="patient.gender" class="required form-combo1">
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
										<field><input type="text" id="birthdate" name="patient.birthdate" class="required form-textbox1"/></field>
										<inputbirthdateEstimated id="" type="hidden"
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
										<span class="select-arrow" style="width: 100%">
											<field>
												<select id="patientReligion" name="person.attribute.${personAttributeReligion.id}" class="form-combo1">
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
												<select id="patientNation" name="person.attribute.27" onchange="showOtherNationality();" class="form-combo1">
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
											<input type="text" id="patientNationalId" name="person.attribute.20" onblur="submitNationalID();" class="form-textbox1"/>
										</field>
										<span type="text" style="color: red;" id="nationalIdValidationMessage"></span>
										<div id="divForNationalId"></div>
									</div>

									<div class="col4 last">
										<field>
											<input type="text" id="passportNumber" name="person.attribute.38" onblur="submitPassportNumber();" class="form-textbox1"/>
										</field>
										<span style="color: red;" id="passportNumberValidationMessage"></span>
										<div id="divForpassportNumber"></div>
									</div>
								</div>

								<div class="onerow">
									<div class="col4" style="padding-top: 5px;">
										<span id="otherNationality">
											<label for="otherNationalityId" style="margin:0px;">Specify Other</label>
											<field><input type="text" id="otherNationalityId" name="person.attribute.39" placeholder="Please specify" class="form-textbox"/></field>
											
										</span>
									</div>

									<div class="col4">&nbsp;</div>

									<div class="col4 last">&nbsp;</div>
								</div>
								
								<div class="onerow" style="margin-top: 50px">
									<a class="button confirm" style="float:right; display:inline-block;" onclick="goto_next_tab(1);">
										<span>NEXT PAGE</span>
									</a>
								</div>
							</p>
								
								<div class="selectdiv"  id="selected-diagnoses"></div>
											  
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
										<field><input type="text" id="patientPhoneNumber" name="person.attribute.16" class="form-textbox1"/></field>
									</div>

									<div class="col4">
										<field><input type="text" id="patientEmail" name="person.attribute.37" class="form-textbox1"/></field>
									</div>

									<div class="col4 last">
										<field><input type="text" id="patientPostalAddress" name="patient.address.postalAddress" class="required form-textbox1"/></field>
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
												<select id="districts" name="patient.address.district" onChange="PAGE.changeDistrict();"
														class="form-combo1">
												</select>
											</field>
										</span>
									</div>

									<div class="col4">
										<span class="select-arrow" style="width: 100%">
											<field>
												<select id="upazilas" name="patient.address.upazila" onChange="PAGE.changeUpazila();" class="form-combo1"></select>
											</field>
										</span>

									</div>

									<div class="col4 last">
										<span class="select-arrow" style="width: 100%">
											<field>
												<select id="locations" name="patient.address.location" class="form-combo1"></select>
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
											<input type="text" id="chiefdom" name="person.attribute.${personAttributeChiefdom.id}" class="form-textbox1"/>
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
										<field><input type="text" id="patientRelativeName" name="person.attribute.8" class="required form-textbox1"/></field>
									</div>

									<div class="col4">
										<span class="select-arrow" style="width: 100%">
											<field>
												<select id="relationshipType" name="person.attribute.15"
														class="required form-combo1">
													<option value=""></option>
													<option value="1">Parent</option>
													<option value="2">Spouse</option>
													<option value="3">Guardian</option>
													<option value="4">Friend</option>
													<option value="5">Other</option>
												</select>
											</field>
										</span>
									</div>

									<div class="col4 last">
										<field><input type="text" id="relativePostalAddress" name="person.attribute.28" class="form-textbox1"/></field>
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

									<a class="button confirm" style="float:right; display:inline-block;" onclick="goto_next_tab(2);">
										<span>NEXT PAGE</span>
									</a>
								</div>
							</p>                   
						</fieldset>
						
						<fieldset class="no-confirmation">
							<legend>Patient Category</legend>
							<div>
								<h2>Patient Category</h2>
								
								<div class="onerow">
									<div class="col4">
										<div class="tasks">
											<header class="tasks-header">
												<span class="tasks-title">Patients Category</span>
												<a class="tasks-lists"></a>
											</header>
											<div class="tasks-list">
												<label class="tasks-list-item">
													<input style="display:none!important" type="radio" name="paym_1" value="1" onchange="LoadPayCatg();" class="tasks-list-cb" checked>
													<span class="tasks-list-mark"></span>
													<span class="tasks-list-desc">PAYING</span>
												</label>
												<label class="tasks-list-item">
													<input style="display:none!important" type="radio" name="paym_1" value="2" onchange="LoadPayCatg();" class="tasks-list-cb">
													<span class="tasks-list-mark"></span>
													<span class="tasks-list-desc">NON-PAYING</span>
												</label>
												<label class="tasks-list-item">
													<input style="display:none!important" type="radio" name="paym_1" value="3" onchange="LoadPayCatg();" class="tasks-list-cb">
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
													<input style="display:none!important" type="radio" name="paym_2" id="paym_201" value="1" onchange="LoadPayCatgMode();" class="tasks-list-cb" checked>
													<span class="tasks-list-mark"></span>
													<span class="tasks-list-desc" id="ipaym_11">GENERAL</span>
												</label>
												<label class="tasks-list-item">
													<input style="display:none!important" type="radio" name="paym_2" id="paym_202" value="2" onchange="LoadPayCatgMode();" class="tasks-list-cb">
													<span class="tasks-list-mark"></span>
													<span class="tasks-list-desc" id="ipaym_12">CHILD UNDER 5YRS</span>
												</label>
												<label class="tasks-list-item">
													<input style="display:none!important" type="radio" name="paym_2" id="paym_203" value="3" onchange="LoadPayCatgMode();" class="tasks-list-cb">
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
											<field><select style="width: 101%;" name="person.attribute.47" id="university">&nbsp;</select></field>
										</span>
										
										<field><input type="text" id="modesummary" name="modesummary" value="N/A" placeholder="WAIVER NUMBER" readonly="" style="width: 101%!important"/></field>
									</div>
								</div>

								<h2>&nbsp;</h2>

								<h2>Visit Information</h2>

								<div class="onerow">
									<div class="col4">
										<label for="legal1" style="margin:0px;">Medical Legal Case</label>
									</div>

									<div class="col4">
										<label for="mlc" style="margin:0px;">Description</label>
									</div>

									<div class="col4 last"></div>
								</div>

								<div class="onerow">
									<div class="col4">
										<span class="select-arrow" style="width: 100%">
											<field>
												<select id="legal1" name="legal1" onchange="LoadLegalCases();">
													<option value="0">&nbsp;</option>
													<option value="1">YES</option>
													<option value="2">NO</option>
												</select>
											</field>
										</span>
									</div>

									<div class="col4">
										<span class="select-arrow" style="width: 100%">
											<field>
												<select id="mlc" name="patient.mlc">
												</select>
											</field>
										</span>
									</div>

									<div class="col4 last"></div>
								</div>

								<div class="onerow" style="margin-top:50px;">
									<div class="col4">
										<label for="refer1" style="margin:0px;">Referral Information</label>
									</div>

									<div class="col4">
										<label for="referredFrom" style="margin:0px;">Referred From</label>
									</div>

									<div class="col4 last">
										<label for="referralType" style="margin:0px;">Referral Type</label>
									</div>
								</div>

								<div class="onerow">
									<div class="col4">
										<span class="select-arrow" style="width: 100%">
											<field>
												<select id="refer1" name="refer1" onchange="LoadReferralCases();">
													<option value="0">&nbsp;</option>
													<option value="1">YES</option>
													<option value="2">NO</option>
												</select>
											</field>
										</span>
									</div>

									<div class="col4">
										<span class="select-arrow" style="width: 100%">
											<field>
												<select id="referredFrom" name="patient.referred.from">
												</select>
											</field>
										</span>
									</div>

									<div class="col4 last">
										<span class="select-arrow" style="width: 100%">
											<field>
												<select id="referralType" name="patient.referred.reason">
												</select>
											</field>
										</span>
									</div>
								</div>
								
								<div class="onerow" id="referraldiv" style="padding-top:-5px; display:none;">
									<label for="referralDescription" style="margin-top:20px;">Comments</label>
									<field><textarea type="text" id="referralDescription" name="patient.referred.description" value="N/A" placeholder="COMMENTS" readonly="" style="height: 80px; width: 700px;"></textarea></field>
								</div>
								
								<h2>&nbsp;</h2>
								<h2>Room to Visit</h2>

								<div class="onerow" style="margin-top:10px;">
									<div class="col4">
										<label for="rooms1" id="froom1" style="margin:0px;">Room to Visit<span>*</span></label>
									</div>

									<div class="col4">
										<label for="rooms2" id="froom2" style="margin:0px;">Room Type<span>*</span></label>
									</div>

									<div class="col4 last">
										<label for="rooms3" id="froom3" style="margin:0px;">File Number</label>
									</div>
								</div>

								<div class="onerow">
									<div class="col4">
										<span class="select-arrow" style="width: 100%">
											<field>
												<select id="rooms1" name="rooms1" onchange="LoadRoomsTypes();" class="required form-combo1">
													<option value="">&nbsp;</option>
													<option value="1">TRIAGE ROOM</option>
													<option value="2">OPD ROOM</option>
													<option value="3">SPECIAL CLINIC</option>
												</select>
											</field>
										</span>
									</div>

									<div class="col4">
										<span class="select-arrow" style="width: 100%">
											<field>
												<select id="rooms2" name="rooms2" class="required form-combo1">
												</select>
											</field>
										</span>
									</div>

									<div class="col4 last">
										<field><input type="text" id="rooms3" name="rooms3" value="N/A" placeholder="FILE NUMBER" readonly=""/></field>
									</div>
								</div>

								<div class="onerow" style="display:none!important;">
									<div class="col4">
										<input id="paying" type="checkbox" name="person.attribute.14" value="Paying" checked /> Paying
									</div>

									<div class="col4">
										<input id="nonPaying" type="checkbox" name="person.attribute.14" value="Non-Paying"/> Non-Paying
									</div>

									<div class="col4 last">
										<input id="specialSchemes" type="checkbox" name="person.attribute.14" value="Special Schemes"/> Special Schemes
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
											<select id="payingCategory" name="person.attribute.44"
													onchange="payingCategorySelection();"
													class="form-combo1" style="display:block!important"></select></span>
										</span>


									</div>

									<div class="col4">&nbsp;
										<span id="nonPayingCategoryField">
										<span class="select-arrow" style="width: 100%">
											<select id="nonPayingCategory" name="person.attribute.45"
													onchange="nonPayingCategorySelection();"
													class="form-combo1" style="display:block!important"></select></span>
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


								<div class="onerow" style="margin-top: 150px">
									<a class="button task ui-tabs-anchor" onclick="goto_previous_tab(3);">
										<span style="padding: 15px;">PREVIOUS</span>
									</a>
									
									<a class="button confirm" onclick="PAGE.submit();" style="float:right; display:inline-block; margin-left: 5px;">
										<span>FINISH</span>
									</a>
									
									<a class="button cancel" onclick="window.location.href = window.location.href" style="float:right; display:inline-block;"/>
										<span>RESET</span>
									</a>
								</div>
							
							</div>
							
							
							<p> </p>
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
										<li><span class="status active"></span><div>Patient ID:</div>		<small id="summ_idnt">/</small></li>
										<li><span class="status active"></span><div>Names:</div>			<small id="summ_name">/</small></li>
										<li><span class="status active"></span><div>Age:</div>				<small id="summ_ages">/</small></li>
										<li><span class="status active"></span><div>Gender:</div>			<small id="summ_gend">/</small></li>
										<li><span class="status active"></span><div>Pay Category:</div> 	<small id="summ_pays">/</small></li>
										<li><span class="status active"></span><div>Registration Fee:</div>	<small id="summ_fees">/</small></li>
									</ul>
									
								</div>
							</div>
						</div>
						<div class="onerow" style="margin-top: 150px">
							<a class="button task ui-tabs-anchor" onclick="goto_previous_tab(4);">
								<span style="padding: 15px;">PREVIOUS</span>
							</a>
							
							<a class="button confirm" onclick="PAGE.submit();" style="float:right; display:inline-block; margin-left: 5px;">
								<span>FINISH</span>
							</a>
							
							<a class="button cancel" onclick="window.location.href = window.location.href" style="float:right; display:inline-block;"/>
								<span>RESET</span>
							</a>
						</div>
					</div>		
				</form>        
			</div>
			
			
			
			

		</div>
	</div>
</div>