<% ui.decorateWith("appui", "standardEmrPage", [title: "Patient Registration"]) %>
<% 
	ui.includeCss("registration", "onepcssgrid.css")
%>
<script type="text/javascript">
	var breadcrumbs = [
		{icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm'},
		{label: "Patient Registration"}
	]
</script>
<openmrs:require privilege="Add Patients" otherwise="/login.htm" redirect="/findPatient.htm" />
<div class="onepcssgrid-1200">


	
	<h6 align="center" style="color:maroon">PATIENT REGISTRATION<br><br></h6>
	<form>
	<div class="onerow">
		<div class="col4"><label></label></div>
		<div class="col2"><input type="radio" name="patient" value="Create New Patient" onclick="javascript:window.location.href='newPatientRegistration.page'">New Patient</div>
		<div class="col2"><input type="radio" name="patient" value="Revisit Patient" onclick="javascript:window.location.href='revisitPatientRegistration.page'">Revisit Patient</div>
		<div class="col4 last"><label></label></div>
	</div>
	
	</form>
	
	
	
</div>