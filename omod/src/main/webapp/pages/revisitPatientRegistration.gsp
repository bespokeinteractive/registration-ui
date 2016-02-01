<% ui.decorateWith("appui", "standardEmrPage", [title: "Patient Revisit"]) %>

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
                <a href="#">Patient Revisit</a>
            </li>
            <li>
            </li>
        </ul>
    </div>
    <div class="patient-header new-patient-header">
        <div class="demographics">
            <h1 class="name" style="border-bottom: 1px solid #ddd;">
                <span>PATIENTS REVISIT &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
            </h1>

            <br>


        </div>

        <div class="identifiers">
            <em>Current Time:</em>
            <span>25-01-2016 10:56:41</span>
        </div>


        <div class="onerow">
            <div style="text-align: center; ">
                <centre>
                    ${ ui.includeFragment("registration", "revisitPatientRegistrationPage") }
                </centre>
            </div>
        </div>
    </div>
</div>


</div>