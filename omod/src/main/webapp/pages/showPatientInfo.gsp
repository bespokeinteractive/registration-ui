<% ui.decorateWith("appui", "standardEmrPage", [title: "Patient Summary"]) %>


<%@ include file="../includes/js_css.jsp" %>
<openmrs:require privilege="View Patients" otherwise="/login.htm" redirect="/module/registration/showPatientInfo.form" />
<openmrs:globalProperty key="hospitalcore.hospitalName" defaultValue="ddu" var="hospitalName"/>

<script type="text/javascript">
    var _attributes = new Array();
    <c:forEach var="entry" items="${patient.attributes}">
    _attributes[${entry.key}] = "${entry.value}";
    </c:forEach>

    var _observations = new Array();
    <c:forEach var="entry" items="${observations}">
    _observations[${entry.key}] = "${entry.value}";
    </c:forEach>

    /**
     ** VALUES FROM MODEL
     **/
    MODEL = {
        patientId: "${patient.patientId}",
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
        selectedMLC:"${selectedMLC}",
        //mlcId: "${mlcId}",
        registrationFee: "${registrationFee}",
        dueDate: "${dueDate}",
        daysLeft: "${daysLeft}",
        firstTimeVisit: "<%= ${firstTimeVisit} == 'true' %>",
        revisit: "<%= ${param.revisit } == 'true' %>",
        reprint: "<%= ${param.reprint} == 'true'%>",
        //triageId: "${triageId}",
        selectedPaymentCategory: "${selectedPaymentCategory}",
        specialSchemeName: "${specialSchemeName}",
        create:"${create}",
        creates:"${creates}"
    };
</script>

<jsp:include page="../includes/${hospitalName}/patientInfoForm.jsp"/>