<% ui.decorateWith("appui", "standardEmrPage", [title: "Patient Registration"]) %>

<body></body>
<header>
</header>
<div class="clear"></div>
<div class="container">
	<div class="example">
		<ul id="breadcrumbs">
			<li>
				<a href="#">
					<i class="icon-home small"></i></a>
			</li>
			<li>
				<i class="icon-chevron-right link"></i>
				<a href="#">Patient Admission</a>
			</li>
			<li>
			</li>
		</ul>
	</div>
	<div class="patient-header new-patient-header">
		<div class="demographics">
			<h1 class="name" style="border-bottom: 1px solid #ddd;">
				<span>PATIENTS REGISTRATION &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
			</h1>

			<br>


		</div>

		<div class="identifiers">
			<em>Current Time:</em>
			<span>25-01-2016 10:56:41</span>
		</div>


		<div class="onerow">
			<div style="text-align: center; margin:60px 0 60px 0;">
				<centre>
					<a class="button confirm fixedwidth big" onclick="javascript:window.location.href='newPatientRegistration.page'">
						<i class=" icon-plus"></i>
						Create New Patient
					</a>

					<a class="button task fixedwidth big" onclick="javascript:window.location.href='revisitPatientRegistration.page'">
						<i class=" icon-user"></i>
						Revisiting Patient
					</a>
				</centre>
			</div>
		</div>
	</div>
</div>


</div>