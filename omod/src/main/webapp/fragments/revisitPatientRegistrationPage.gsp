<script type="text/javascript">
	function HideDashboard(){
		jQuery('#dashboard').hide();
	}
	function ShowDashboard(){
		jQuery('#dashboard').toggle(1000);
		
	}
</script>

<style>
	form .advanced{
		background: #f0f0f0 none repeat scroll 0 0;
		border-color: #ddd;
		border-style: solid;
		border-width: 1px;
		cursor: pointer;
		float: right;
		padding: 5px 0;
		text-align: center;
		width: 17%;
	}
	.col4 label{
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
</style>

<form onsubmit="return false" id="patient-search-form" method="get">
    <input type="text" autocomplete="off" placeholder="Search by ID or Name" id="patient-search" style="width:80%;padding: 5px 10px;">
	<div id="advanced" class="advanced" onclick="ShowDashboard();">ADVANCED SEARCH</div>
	
	<div id="dashboard" class="dashboard" style="display:none;">
		<div class="info-section">
			<div class="info-header">
				<i class="icon-diagnosis"></i>
				<h3>ADVANCED SEARCH</h3>
				<span id="as_close" onclick="HideDashboard();">
					<div class="identifiers">
						<span style="background:#00463f">x</span>
					</div>
				</span>
			</div>
			<div class="info-body" style="min-height: 140px;">
				<ul>
					<li>
						<div class="onerow">
							<div class="col4">
								<label for="gender">Gender</label>
								<select style="width: 170px" id="gender" name="gender">
									<option value="Any">Any</option>
									<option value="M">Male</option>
									<option value="F">Female</option>
								</select>
							</div>
							
							<div class="col4">
								<label for="lastDayOfVisit">Previous Visit</label>
								<input id="lastDayOfVisit" name="lastDayOfVisit" style="width: 149px" placeholder="Last Visit Date">
							</div>
							
							<div class="col4 last">
								<label for="relativeName">Relative Name</label>
								<input id="relativeName" name="relativeName" style="width: 151px" placeholder="Relative Name">
							</div>
						</div>
						
						<div class="onerow" style="padding-top: 0px;">
							<div class="col4">
								<label for="age">Age</label>
								<input id="age" name="age" style="width: 149px" placeholder="Patient Age">
							</div>
							
							<div class="col4">
								<label for="gender">Previous Visit</label>
								<select style="width: 170px" id="lastVisit">
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
								<select id="ageRange" name="ageRange" style="width: 170px">
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
								<select id="patientMaritalStatus" style="width: 170px">
									<option value="Any">Any</option>
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
					
					<th class="ui-state-default" role="columnheader" style="width:60px;">
						<div class="DataTables_sort_wrapper">Gender<span class="DataTables_sort_icon"></span></div>
					</th>
					
					<th class="ui-state-default" role="columnheader" style="width: 60px;">
						<div class="DataTables_sort_wrapper">Age<span class="DataTables_sort_icon"></span></div>
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
				<tr class="odd">
					<td class="">KALJ1622420458183-4</td>
					<td class="">Dennis Kungu</td>
					<td class="">M</td>
					<td class="">29</td>
					<td class="">24-Mar-2013</td>
					<td class="">&nbsp;</td>
				</tr>
				
				<tr class="odd">
					<td class="">KALJ1673850004567-9</td>
					<td class="">Brian Kirui</td>
					<td class="">M</td>
					<td class="">25</td>
					<td class="">N/A</td>
					<td class="">&nbsp;</td>
				</tr>
			</tbody>
		</table>
		
		
	</div>
</div>