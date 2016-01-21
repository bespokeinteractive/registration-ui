<% ui.decorateWith("appui", "standardEmrPage", [title: "Patient Registration"]) %>
<script type="text/javascript">
	var breadcrumbs = [
		{icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm'},
        {label: "Patient"},
		{label: "New Patient"}
	]
</script>
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

</script>


<div class="onepcssgrid-1000">

${ ui.includeFragment("registration", "newPatientRegistrationForm") }

</div>




