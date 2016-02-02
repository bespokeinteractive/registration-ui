<%
    def props = ["patientId", "names", "age", "gender", "previous", "action"]
%>

<style>

</style>
<script type="text/javascript">

    var MODEL;
    jQuery(document).ready(function () {
        jQuery("#advancedDetails").hide();
        jQuery("#showAdvancedSearch").click(function () {
            jQuery("#advancedDetails").toggle();
        });

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
            referredFrom: "${referralHospitals}",
            referralType: "${referralReasons}",
            TEMPORARYCAT: "${TEMPORARYCAT}"
        }

    });//end of ready function

    PATIENTSEARCHRESULT = {
        oldBackgroundColor: "",

        /** Click to view patient info */
        visit: function (patientId, deadInfo, admittedInfo) {
            if (deadInfo == "true") {
                alert("This Patient is Dead");
                return false;
            }
            if (admittedInfo == "true") {
                alert("This Patient is admitted");
                return false;
            }
            window.location.href = emr.pageLink("registration", "showPatientInfo", {
                "patientId": patientId,
                "revisit": true
            });
        },

        /** Edit a patient */
        editPatient: function (patientId, deadInfo) {
            if (deadInfo == "true") {
                alert("This Patient is Dead");
                return false;
            }
            window.location.href = emr.pageLink("registration", "showPatientInfo", {"patientId": patientId});
            ;
        },

        reprint: function (patientId, deadInfo) {
            if (deadInfo == "true") {
                alert("This Patient is Dead");
                return false;
            }
            window.location.href = emr.pageLink("registration", "showPatientInfo", {
                "patientId": patientId,
                "reprint": true
            });
        }
    };

    jQuery(document).ready(function () {

        // hover rows
        jQuery(".patientSearchRow").hover(
                function (event) {
                    obj = event.target;
                    while (obj.tagName != "TR") {
                        obj = obj.parentNode;
                    }
                    PATIENTSEARCHRESULT.oldBackgroundColor = jQuery(obj).css("background-color");
                    jQuery(obj).css("background-color", "#00FF99");
                },
                function (event) {
                    obj = event.target;
                    while (obj.tagName != "TR") {
                        obj = obj.parentNode;
                    }
                    jQuery(obj).css("background-color", PATIENTSEARCHRESULT.oldBackgroundColor);
                }
        );

    });

    //update the queue table
    function updateQueueTable(data) {
        var jq = jQuery;
        jq('#searchResultsTable > tbody > tr').remove();
        var tbody = jq('#searchResultsTable > tbody');
        for (index in data) {
            var item = data[index];
            var row = '<tr>';
            <% props.each {
               if(it == props.last()){
                  def pageLinkRevisit = ui.pageLink("registration", "showPatientInfo");
                  def pageLinkEdit = ui.pageLink("registration", "showPatientInfo");
                  def pageLinkReprint = ui.pageLink("registration", "showPatientInfo");
                   %>

            row += '<td> <a href="${pageLinkRevisit}?patientId=' + item.patientId + '&revisit=true"><i class="icon-user-md small" ></i>' +
                    '</a>  <a href="${pageLinkEdit}?patientId=' + item.patientId + '"><i class="icon-edit small" ></i></a>  ' +
                    '<a href="${pageLinkReprint}?patientId=' + item.patientId + '&reprint=true"><i class="icon-print small" ></i> </td>';
            <% } else {%>
            row += '<td>' + item.${ it } + '</td>';
            <% }
               } %>
            row += '</tr>';
            tbody.append(row);
        }
    }

    // get queue
    function getPatientQueue(currentPage) {
        this.currentPage = currentPage;
        var phrase = jQuery("#surName").val();
        var pgSize = jQuery("#sizeSelector").val();
        var gender = jQuery("#gender").val();
        jQuery.ajax({
            type: "GET",
            url: "${ui.actionLink('registration','revisitPatientRegistrationForm','searchPatient')}",
            dataType: "json",
            data: ({
                gender: gender,
                phrase: phrase,
                currentPage: currentPage,
                pageSize: pgSize
            }),
            success: function (data) {
                pData = data;
                updateQueueTable(data);

//                    jQuery("#billingqueue").show(0);
//                    jQuery("#billingqueue").html(data);
            },

        });
    }


</script>

<h3 align="center" style="color:black">Search Revisit Patient</h3>

<div id="patientSearchResult"></div>

<form id="patientRegistrationForm" method="POST">

    <div id="searchPane" style="display: inline-block; float: left;">
        <input id="surName" name="patient.surName"
               placeholder="Name/Identifier"/>
        <a class="button task" href="#" id="showAdvancedSearch">
            <i class="icon-filter"></i>
            Advanced Search
        </a>
    </div>

    <div id="advancedDetails" style="float: right">
        <span class="select-arrow">
            <select id="gender">
                <option value="any">Gender</option>
                <option value="M">Male</option>
                <option value="F">Female</option>
            </select>
        </span>
        <input id="age" placeholder="Age"/>
        <select id="ageRange">
            <option value="0">Exact</option>
            <option value="1">1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4">4</option>
            <option value="5">5</option>
        </select>
        <input id="patientMaritalStatus" placeholder="Marital Status"/>
        <select id="lastVisit">
            <option value="any">Anytime</option>
            <option value="31">Last Month</option>
            <option value="183">Last Six Months</option>
            <option value="366">Last Year</option>
        </select>
        <input id="phoneNumber" placeholder="Phone Number"/>
        <input id="relativeName" placeholder="Marital Status"/>
        <input id="nationalId" placeholder="National Id"/>
        <input id="fileNumber" placeholder="File Number"/>
    </div>
    <br/><br/><br/>

    <div id="searchResults">
        <section>
            <div>
                <table cellpadding="5" cellspacing="0" width="100%" id="searchResultsTable">
                    <thead>
                    <tr align="center">
                        <th>Patient ID</th>
                        <th>Name</th>
                        <th>Age</th>
                        <th>Gender</th>
                        <th>Date of Previous Visit</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr align="center">
                        <td colspan="6">No patients found</td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </section>

    </div>
    <div id="selection">
        Show
        <select name="sizeSelector" id="sizeSelector" onchange="getPatientQueue(1)">
            <option value="10" id="1">10</option>
            <option value="20" id="2" selected>20</option>
            <option value="50" id="3">50</option>
            <option value="100" id="4">100</option>
            <option value="150" id="5">150</option>
        </select>
    </div>


    <div id="searchbox"></div>

    <div id="numberOfFoundPatients"></div>
</form>
