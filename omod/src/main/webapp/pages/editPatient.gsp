<% ui.decorateWith("appui", "standardEmrPage", [title: "Edit Patient Details"]) %>
<style>
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
</style>

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


</script>