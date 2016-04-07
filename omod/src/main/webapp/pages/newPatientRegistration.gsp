<% ui.decorateWith("appui", "standardEmrPage", [title: "Patient Registration"]) %>

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
	border-radius: 0px!important;
	box-shadow: none!important;
	box-sizing: border-box!important;
	line-height: 18px!important;
	padding: 8px 10px!important;
}

form select {
	width:100%;
	border: 1px solid #aaa;
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
#estimatedAge span,
label span{
	color: #ff0000;
	padding-left: 5px;
}
.toast-item{
	background-color: #222;
}

@media all and (max-width: 768px) {
	.onerow {
		margin: 0 0 100px;
	}
}
.simple-form-ui section fieldset select:focus, .simple-form-ui section fieldset input:focus, .simple-form-ui section #confirmationQuestion select:focus, .simple-form-ui section #confirmationQuestion input:focus, .simple-form-ui #confirmation fieldset select:focus, .simple-form-ui #confirmation fieldset input:focus, .simple-form-ui #confirmation #confirmationQuestion select:focus, .simple-form-ui #confirmation #confirmationQuestion input:focus, .simple-form-ui form section fieldset select:focus, .simple-form-ui form section fieldset input:focus, .simple-form-ui form section #confirmationQuestion select:focus, .simple-form-ui form section #confirmationQuestion input:focus, .simple-form-ui form #confirmation fieldset select:focus, .simple-form-ui form #confirmation fieldset input:focus, 
.simple-form-ui form #confirmation #confirmationQuestion select:focus, .simple-form-ui form #confirmation #confirmationQuestion input:focus {
	outline: 1px none #007fff;
	box-shadow: 0 0 2px 0px #888!important;
}

form textarea:focus, .form textarea:focus{
	outline: 1px none #007fff;
}
</style>

<body></body>
<header>
</header>
<div class="clear"></div>
<div class="container">
	<div class="example">
		<ul id="breadcrumbs">
			<li>
				<a href="${ui.pageLink('referenceapplication','home')}">
					<i class="icon-home small"></i></a>
			</li>
			
			<li>
				<i class="icon-chevron-right link"></i>
				<a href="${ui.pageLink('registration','patientRegistration')}">Registration</a>
			</li>
			
			<li>
				<i class="icon-chevron-right link"></i>
				<a href="#">Add New Patient</a>
			</li>
			
			<li>&nbsp;
			</li>
		</ul>
	</div>
	<div class="patient-header new-patient-header">
		<div class="demographics">
			<h1 class="name" style="border-bottom: 1px solid #ddd;">
				<span>NEW PATIENT REGISTRATION &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
			</h1>

			<br>


		</div>

		<div class="identifiers">
			<em>Patient Identifier:</em>
			<span>* ${patientIdentifier}</span>
		</div>


		<div class="onepcssgrid-1000">
			<br/><br/>
			${ ui.includeFragment("registration", "newPatientRegistrationPage") }

		</div>
	</div>
</div>