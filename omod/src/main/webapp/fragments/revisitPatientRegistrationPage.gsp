<%
    def props = ["wrapperIdentifier", "names", "age", "gender", "formartedVisitDate", "action"]
%>

<script type="text/javascript">

    var MODEL;
    jQuery(document).ready(function () {
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

		jq('select').bind('change keyup', function() {
			ADVSEARCH.delay();
		});
		
		jq('#lastDayOfVisit-display').on("change", function (dateText) {
			ADVSEARCH.delay();
        });
		
		jq('input').keydown(function (e) {
			var key = e.keyCode || e.which;
			if ((key == 9 || key == 13) && jq(this).attr('id') != 'searchPhrase') {
				ADVSEARCH.delay(); 
			}
		}); 
		
		

    });//end of ready function

	jQuery.fn.clearForm = function() {
		return this.each(function() {
			var type = this.type, tag = this.tagName.toLowerCase();
			if (tag == 'form')
			  return jQuery(':input',this).clearForm();
			if ((type == 'text' || type == 'hidden') && jQuery(this).attr('id') != 'searchPhrase')
			  this.value = '';
			else if (type == 'checkbox' || type == 'radio')
			  this.checked = false;
			else if (tag == 'select')
			  this.selectedIndex = -1;
		});
	};
	
    function strReplace(word) {
        var res = word.replace("[", "");
        res=res.replace("]","");
        return res;
    }



    PATIENTSEARCHRESULT = {


        oldBackgroundColor: "",

        /** Click to view patient info */
        revisit: function (patientId, deadInfo, admittedInfo) {
            if (deadInfo) {
                alert("This Patient is Dead");
                return false;
            }else if (admittedInfo) {
                alert("This Patient is admitted");
                return false;
            }else{
                alert("not dead or admitted")
                window.location.href = emr.pageLink("registration", "showPatientInfo", {
                    "patientId": patientId,
                    "revisit": true
                });
            }

        },

        /** Edit a patient */
        editPatient: function (patientId, deadInfo, admittedInfo) {
            if (deadInfo) {
                alert("This Patient is Dead");
                return false;
            }
            window.location.href = emr.pageLink("registration", "showPatientInfo", {"patientId": patientId});
        },

        reprint: function (patientId, deadInfo,admittedInfo) {
            if (deadInfo) {
                alert("This Patient is Dead");
                return false;
            }
            window.location.href = emr.pageLink("registration", "showPatientInfo", {
                "patientId": patientId,
                "reprint": true
            });
        }
    };


    ADVSEARCH = {
        timeoutId: 0,
        showing: false,
        params: "",
        delayDuration: 1,
        pageSize: 10,
        beforeSearch: function () {
        },

        // search patient
        searchPatient: function (currentPage, pageSize) {
            this.beforeSearch();
            var phrase = jQuery("#searchPhrase").val();

            if (phrase.length >= 3) {
                jQuery("#ajaxLoader").show();
                getPatientQueue(1);
            }
			else{
				jq().toastmessage('showNoticeToast', "Specify atleast three characters to Search");
			}
        },

        // start searching patient
        startSearch: function (e) {
            e = e || window.event;
            ch = e.which || e.keyCode;
            if (ch != null) {
                if ((ch >= 48 && ch <= 57) || (ch >= 96 && ch <= 105)
                        || (ch >= 65 && ch <= 90)
                        || (ch == 109 || ch == 189 || ch == 45) || (ch == 8)
                        || (ch == 46)) {
                } else if (ch == 13) {
                    clearTimeout(this.timeoutId);
                    this.timeoutId = setTimeout("ADVSEARCH.delay()",
                            this.delayDuration);
                }
            }
        },

        // delay before search
        delay: function () {
            this.searchPatient(0, this.pageSize);
        }
    };

    //update the queue table
    function updateQueueTable(data) {
        var jq = jQuery;
        jq('#patient-search-results-table > tbody > tr').remove();
        var tbody = jq('#patient-search-results-table > tbody');
        for (index in data) {

            var item = data[index];
            console.info(item.dead);
            console.info(item.voided);
            var row = '<tr>';
            <% props.each {
               if(it == props.last()){
                  def pageLinkRevisit = ui.pageLink("registration", "revisitPatient");
                  def pageLinkEdit = ui.pageLink("registration", "editPatient");
                  def pageLinkReprint = ui.pageLink("registration", "showPatientInfo");
                   %>

            row += '<td> ' +

                    '<a title="Patient Revisit" onclick="PATIENTSEARCHRESULT.revisit('+item.patientId +','+ item.dead +','+item.voided +');"><i class="icon-user-md small" ></i></a>' +
                    <% if (context.authenticatedUser.hasPrivilege("Edit Patients") ) { %>'<a title="Edit Patient" onclick="PATIENTSEARCHRESULT.editPatient('+item.patientId +','+ item.dead +','+item.voided +');"><i class="icon-edit small" ></i></a>'<% } %> +
                    <% if (context.authenticatedUser.hasPrivilege("Print Duplicate Slip") ) { %>'<a title="Reprint Receipt" onclick="PATIENTSEARCHRESULT.reprint('+item.patientId +','+ item.dead +','+item.voided +');"><i class="icon-print small" ></i></a>'<% } %>  +
                    '</td>';
            <% } else {%>

            row += '<td>' + item.${ it} + '</td>';
            row=strReplace(row);
            <% }
               } %>
            row += '</tr>';
            tbody.append(row);
        }
		
		if (jq('#patient-search-results-table tr').length <= 1){
			tbody.append('<tr align="center"><td colspan="6">No patients found</td></tr>');
		}
    }

    // get queue
    function getPatientQueue(currentPage) {
        this.currentPage = currentPage;
        var phrase = jQuery("#searchPhrase").val();
        var pgSize = 1000;
        var gender = jQuery("#gender").val();
        var age = jQuery("#age").val();
        var ageRange = jQuery("#ageRange").val();
        var patientMaritalStatus = jQuery("#patientMaritalStatus").val();
        var lastDayOfVisit = jq('#lastDayOfVisit-field').val() && moment(jq('#lastDayOfVisit-field').val()).format('DD/MM/YYYY');
        var lastVisit = jQuery("#lastVisit").val();
        var phoneNumber = jQuery("#phoneNumber").val();
        var relativeName = jQuery("#relativeName").val();
        var nationalId = jQuery("#nationalId").val();
        var fileNumber = jQuery("#fileNumber").val();

        jQuery.ajax({
            type: "POST",
            url: "${ui.actionLink('registration','revisitPatientRegistrationForm','searchPatient')}",
            dataType: "json",
            data: ({
                gender: gender,
                phrase: phrase,
                currentPage: currentPage,
                pageSize: pgSize,
                age: age,
                ageRange: ageRange,
                patientMaritalStatus: patientMaritalStatus,
                lastVisit: lastVisit,
                phoneNumber: phoneNumber,
                relativeName: relativeName,
                nationalId: nationalId,
                fileNumber: fileNumber,
                lastDayOfVisit: lastDayOfVisit
            }),
            success: function (data) {
                jQuery("#ajaxLoader").hide();
                pData = data;
                updateQueueTable(data);
            },
            error: function (xhr, ajaxOptions, thrownError) {
                alert(xhr);
                jQuery("#ajaxLoader").hide();
            }

        });
    }
	
    function HideDashboard() {
        jq('#dashboard').hide();
		jq('#patient-search-form').clearForm();
    }
    function ShowDashboard() {
        jq('#dashboard').toggle(500);
        jq('#patient-search-form').clearForm();

    }
</script>

<style>
	form .advanced {
		background: #363463 none repeat scroll 0 0;
		border-color: #dddddd;
		border-style: solid;
		border-width: 1px;
		color: #fff;
		cursor: pointer;
		float: right;
		padding: 5px 0;
		text-align: center;
		width: 27%;
	}
	form .advanced i{
		font-size: 22px;
	}
	.col4 label {
		width: 110px;
		display: inline-block;
	}

	.col4 input[type=text] {
		display: inline-block;
		padding: 2px 10px;
	}

	.col4 select {
		padding: 2px 10px;
	}

	form select {
		min-width: 50px;
		display: inline-block;
	}
	.addon{
		display: inline-block;
		float: right;
		margin: 5px 0 0 145px;
		position: absolute;
	}
	#lastDayOfVisit label{
		display:none;
	}
	#lastDayOfVisit input{
		width:150px !important;
	}
	.add-on {
		float: right;
		left: auto;
		margin-left: -29px;
		margin-top: 5px;
		position: absolute;
	}
	.ui-widget-content a {
		color: #007fff;
	}
</style>

<form onsubmit="return false" id="patient-search-form" method="get">
    <input type="text" autocomplete="off" placeholder="Search by ID or Name" id="searchPhrase"
           style="float:left; width:70%; padding:6px 10px 7px;" onkeyup="ADVSEARCH.startSearch(event);">
    <img id="ajaxLoader" style="display:none; float:left; margin: 3px -4%;" src="${ui.resourceLink("registration", "images/ajax-loader.gif")}"/>

    <div id="advanced" class="advanced" onclick="ShowDashboard();"><i class="icon-filter"></i>ADVANCED SEARCH</div>

    <div id="dashboard" class="dashboard" style="display:none;">
        <div class="info-section">
            <div class="info-header">
                <i class="icon-diagnosis"></i>

                <h3>ADVANCED SEARCH</h3>
                <span id="as_close" onclick="HideDashboard();">
                    <div class="identifiers">
                        <span style="background:#00463f; padding-bottom: 5px;">x</span>
                    </div>
                </span>
            </div>

            <div class="info-body" style="min-height: 140px;">
                <ul>
                    <li>
                        <div class="onerow">
                            <div class="col4">
                                <label for="gender">Gender</label>
                                <select style="width: 172px" id="gender" name="gender">
                                    <option value="Any">Any</option>
                                    <option value="M">Male</option>
                                    <option value="F">Female</option>
                                </select>
                            </div>

                            <div class="col4">
                                <label for="lastDayOfVisit">Last Visit</label>
								${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'lastDayOfVisit', id: 'lastDayOfVisit', label: '', useTime: false, defaultToday: false, class: ['newdtp'], endDate: new Date()])}
                            </div>

                            <div class="col4 last">
                                <label for="relativeName">Relative Name</label>
                                <input id="relativeName" name="relativeName" style="width: 151px"
                                       placeholder="Relative Name">
                            </div>
                        </div>

                        <div class="onerow" style="padding-top: 0px;">
                            <div class="col4">
                                <label for="age">Age</label>
                                <input id="age" name="age" style="width: 149px" placeholder="Patient Age">
                            </div>

                            <div class="col4">
                                <label for="gender">Previous Visit</label>
                                <select style="width: 172px" id="lastVisit">
                                    <option value="Any">Anytime</option>
                                    <option value="31">Last month</option>
                                    <option value="183">Last 6 months</option>
                                    <option value="366">Last year</option>
                                </select>
                            </div>

                            <div class="col4 last">
                                <label for="nationalId">National ID</label>
                                <input id="nationalId" name="nationalId" style="width: 151px" placeholder="National ID">
                            </div>
                        </div>

                        <div class="onerow" style="padding-top: 0px;">
                            <div class="col4">
                                <label for="ageRange">Range &plusmn;</label>
                                <select id="ageRange" name="ageRange" style="width: 172px">
                                    <option value="0">Exact</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                </select>
                            </div>

                            <div class="col4">
                                <label for="phoneNumber">Phone No.</label>
                                <input id="phoneNumber" name="phoneNumber" style="width: 149px" placeholder="Phone No.">
                            </div>

                            <div class="col4 last">
                                <label for="fileNumber">File Number</label>
                                <input id="fileNumber" name="fileNumber" style="width: 151px" placeholder="File Number">
                            </div>
                        </div>

                        <div class="onerow" style="padding-top: 0px;">
                            <div class="col4">
                                <label for="patientMaritalStatus">Marital Status</label>
                                <select id="patientMaritalStatus" style="width: 172px">
                                    <option value="">Any</option>
                                    <option value="Single">Single</option>
                                    <option value="Married">Married</option>
                                    <option value="Divorced">Divorced</option>
                                    <option value="Widow">Widow</option>
                                    <option value="Widower">Widower</option>
                                    <option value="Separated">Separated</option>
                                </select>
                            </div>

                            <div class="col4">
                                &nbsp;
                            </div>

                            <div class="col4 last">&nbsp;</div>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</form>

<div id="patient-search-results" style="display: block; margin-top:3px;">
    <div role="grid" class="dataTables_wrapper" id="patient-search-results-table_wrapper">
        <table id="patient-search-results-table" class="dataTable" aria-describedby="patient-search-results-table_info">
            <thead>
            <tr role="row">
                <th class="ui-state-default" role="columnheader" style="width: 220px;">
                    <div class="DataTables_sort_wrapper">Identifier<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader">
                    <div class="DataTables_sort_wrapper">Name<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width: 60px;">
                    <div class="DataTables_sort_wrapper">Age<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width: 60px;">
                    <div class="DataTables_sort_wrapper">Gender<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width:120px;">
                    <div class="DataTables_sort_wrapper">Last Visit<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width: 100px;">
                    <div class="DataTables_sort_wrapper">Action<span class="DataTables_sort_icon"></span></div>
                </th>
            </tr>
            </thead>

            <tbody role="alert" aria-live="polite" aria-relevant="all">
				<tr align="center">
					<td colspan="6">No patients found</td>
				</tr>
            </tbody>
        </table>

    </div>
</div>