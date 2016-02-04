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

form input{
    margin: 0px;
    display: inline-block;
    min-width: 50px;
    padding: 2px 10px;
}
.info-header span{
    cursor: pointer;
    display: inline-block;
    float: right;
    margin-top: -3px;
    padding-right: 5px;
}

@media all and (max-width: 768px) {
    .onerow {
        margin: 0 0 100px;
    }
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
                <a href="#">Patient Revisit</a>
            </li>
            <li>
            </li>
        </ul>
    </div>
    <div class="patient-header new-patient-header">
        <div class="demographics">
            <h1 class="name" style="border-bottom: 1px solid #ddd;">
                <span>FIND PATIENT RECORDS &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
            </h1>

            <br>


        </div>

        <div class="identifiers">
            <em>Current Time:</em>
            <span>${currentTime}</span>
        </div>


        <div class="onepcssgrid-1000">
            <br/><br/>
            ${ ui.includeFragment("registration", "revisitPatientRegistrationPage") }

        </div>
    </div>
</div>


</div>