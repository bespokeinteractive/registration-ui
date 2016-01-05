<script>
  jQuery(function() {
    jQuery( "#tabs" ).tabs().addClass( "ui-tabs-vertical ui-helper-clearfix" );
    jQuery( "#tabs li" ).removeClass( "ui-corner-top" ).addClass( "ui-corner-left" );
  });
  
  
  jQuery(function() {
    jQuery( "#birthdate" ).datepicker({
    	changeMonth: true,
        changeYear: true,
        maxDate: '0',
        constrainInput: false
    });
  });
</script>
<style>
  .ui-tabs-vertical { width: 55em; }
  .ui-tabs-vertical .ui-tabs-nav { padding: .2em .1em .2em .2em; float: left; width: 12em; }
  .ui-tabs-vertical .ui-tabs-nav li { clear: left; width: 100%; border-bottom-width: 1px !important; border-right-width: 0 !important; margin: 0 -1px .2em 0; }
  .ui-tabs-vertical .ui-tabs-nav li a { display:block; }
  .ui-tabs-vertical .ui-tabs-nav li.ui-tabs-active { padding-bottom: 0; padding-right: .1em; border-right-width: 1px; }
  .ui-tabs-vertical .ui-tabs-panel { padding: 1em; float: right; width: 40em;}
  
  .form-textbox {
		height: 12px !important;
		font-size: 12px !important;		
	}
	
  .form-combo {
	height: 25px !important;
	font-size: 10px !important;	
	}
	
	
</style>

<div class="onepcssgrid-1200">
	<h3 align="center" style="color:black">PATIENT REGISTRATION<br></h3>
	<form id="patientRegistrationForm" method="POST">
		<div id="tabs">
			<ul>
			    <li><a href="#tabs-1">Demographics</a></li>
			    <li><a href="#tabs-2">Contact Info</a></li>
			    <li><a href="#tabs-3">Patient Category</a></li>
		  	</ul>	
		  	
		  	<div id="tabs-1">
		  		<h2>Patient Demographics</h2>
		  		<div class="onerow">
					<div class="col4"><label>Surname*(required)</label></div>
					<div class="col4"><label>First Name*(required)</label></div>
					<div class="col4 last"><label>Other Name</label></div>
				</div>
				<div class="onerow">
					<div class="col4"><input type="text" id="surName" name="patient.surName" class="form-textbox" /></div>
					<div class="col4"><input type="text" id="firstName" name="patient.firstName" class="form-textbox" /></div>
					<div class="col4 last"><input type="text" id="otherName" name="patient.otherName" class="form-textbox"/></div>
				</div>	
				
				
				<div class="onerow">
					<div class="col4"><label>Age or D.O.B*</label></div>
					<div class="col4"><label>Gender*(required)</label></div>
					<div class="col4 last"><label>Marital Status*</label></div>
				</div>
				<div class="onerow">
					<div class="col4">
						<input type="text" id="birthdate" name="patient.birthdate" class="form-textbox" />
					</div>
					<div class="col4">
						<select id="patientGender" name="patient.gender" class="form-combo">
									<option value="Any"></option>
									<option value="M">Male</option>
									<option value="F">Female</option>
						</select>
					</div>
					<div class="col4 last">
						<select id="maritalStatus" name="person.attribute.26" style='width: 152px;' class="form-combo">
											<option value="Marital"></option>
											<option value="Single">Single</option>
											<option value="Married">Married</option>
											<option value="Divorced">Divorced</option>
											<option value="Widow">Widow</option>
											<option value="Widower">Widower</option>
											<option value="Separated">Separated</option>
						</select>
					</div>
				</div>
				<div class="onerow">
					<div class="col4"><label>Religion(required)</label></div>
					<div class="col4"></div>
					<div class="col4 last"></div>
				</div>
				<div class="onerow">
					<div class="col4">
						<select id="patientReligion" name="person.attribute.${personAttributeReligion.id}" class="form-combo">	
						</select>
					</div>
					<div class="col4">
						
					</div>
					<div class="col4 last">
						
					</div>
				</div>
				
				<div class="onerow">
				<div class="col4"><label>Nationality</label></div>
				<div class="col4"><label>National ID:</label></div>
				<div class="col4 last"><label>Passport No.</label></div>
			</div>
			<div class="onerow">
				<div class="col4">
						<select id="patientNation" name="person.attribute.27" style="width: 152px;" onchange="showOtherNationality();" class="form-combo">
										<option value="Kenya">Kenya</option>
										<option value="East Africa">East Africa</option>
										<option value="Kenyan">Africa</option>
										<option value="Algeria">Algeria</option>
										<option value="Angola">Angola</option>
										<option value="Benin">Benin</option>
										<option value="Botswana">Botswana</option>
										<option value="Burkina Faso">Burkina Faso</option>
										<option value="Burundi">Burundi</option>
										<option value="Cameroon">Cameroon</option>
										<option value="Cape Verde">Cape Verde</option>
										<option value="Central African Republic">Central African Republic</option>
										<option value="Chad">Chad</option>
										<option value="Comoros">Comoros</option>
										<option value="Cote d'Ivoire">Cote d'Ivoire</option>
										<option value="Democratic Republic of Congo">Democratic Republic of Congo</option>
										<option value="Djibouti">Djibouti</option>
										<option value="Egypt">Egypt</option>
										<option value="Equatorial Guinea">Equatorial Guinea</option>
										<option value="Eritrea">Eritrea</option>
										<option value="Ethiopia">Ethiopia</option>
										<option value="Gabon">Gabon</option>
										<option value="Gambia">Gambia</option>
										<option value="Ghana">Ghana</option>
										<option value="Guinea">Guinea</option>
										<option value="Guinea-Bissau">Guinea-Bissau</option>
										<option value="Lesotho">Lesotho</option>
										<option value="Liberia">Liberia</option>
										<option value="Libya">Libya</option>
										<option value="Madagascar">Madagascar</option>
										<option value="Malawi">Malawi</option>
										<option value="Mali">Mali</option>
										<option value="Mauritania">Mauritania</option>
										<option value="Mauritius">Mauritius</option>
										<option value="Morocco">Morocco</option>
										<option value="Mozambique">Mozambique</option>
										<option value="Namibia">Namibia</option>
										<option value="Niger">Niger</option>
										<option value="Nigeria">Nigeria</option>
										<option value="Republic of Congo">Republic of Congo</option>
										<option value="Rwanda">Rwanda</option>
										<option value="Sao Tome and Principe">Sao Tome and Principe</option>
										<option value="Senegal">Senegal</option>
										<option value="Seychelles">Seychelles</option>
										<option value="Sierra Leone">Sierra Leone</option>
										<option value="Somalia">Somalia</option>
										<option value="South Africa">South Africa</option>
										<option value="South Sudan">South Sudan</option>
										<option value="Sudan">Sudan</option>
										<option value="Swaziland">Swaziland</option>
										<option value="Tanzania">Tanzania</option>
										<option value="Togo">Togo</option>
										<option value="Tunisia">Tunisia</option>
										<option value="Uganda">Uganda</option>
										<option value="Zambia">Zambia</option>
										<option value="Zimbabwe">Zimbabwe</option>
										<option value="Other">Other</option>
						</select>
				
					</div>
					<div class="col4">
						<input id="patientNationalId" name="person.attribute.20" onblur="submitNationalID();" class="form-textbox"/>
					</div>
					<div class="col4 last">
						<input id="passportNumber" name="person.attribute.38" onblur="submitPassportNumber();" class="form-textbox"/>
					</div>
				</div>
					  	
		  	</div>	
		  	
		  	<div id="tabs-2">
		  		<h2>Patient Contact Information</h2>
		  		<div class="onerow">
					<div class="col4"><label>Contact Number</label></div>
					<div class="col4"><label>Email Address</label></div>
					<div class="col4 last"><label>Chiefdom</label></div>
				</div>
				<div class="onerow">
					<div class="col4">
						<input id="patientPhoneNumber" name="person.attribute.16" />
					
					</div>
					<div class="col4">
						<input id="patientEmail" name="person.attribute.37"  />
					</div>
					<div class="col4 last">
						<input id="chiefdom" name="person.attribute.${personAttributeChiefdom.id}" />
					</div>
				</div>
				
				<div class="onerow">
					<div class="col4"><label>County</label></div>
					<div class="col4"><label>Sub-County</label></div>
					<div class="col4 last"><label>Location</label></div>
				</div>
				<div class="onerow">
					<div class="col4">
						<select id="districts" name="patient.address.district" onChange="PAGE.changeDistrict();" ></select>				
					</div>
					<div class="col4">
						<select id="upazilas" name="patient.address.upazila" onChange="PAGE.changeUpazila();" ></select>
					</div>
					<div class="col4 last">
						<select id="locations" name="patient.address.location" ></select>
					</div>
				</div>
				
				<div class="onerow">
					<div class="col4"><label>Physical Address:</label></div>
					<div class="col4"><label></label></div>
					<div class="col4 last"><label></label></div>
				</div>
				<div class="onerow">
					<div class="col4">
						<input type="text" id="relativePostalAddress" name="person.attribute.28" />				
					</div>
					<div class="col4">
						
					</div>
					<div class="col4 last">
						
					</div>
				</div>	  	
		  	</div>
		  	
		  	<div id="tabs-3">
		  		<h2>Patient Category</h2>
		  		
	  			<div class="onerow">
					<div class="col4"><input id="paying" type="checkbox" name="person.attribute.14" value="Paying" /> Paying</div>
					<div class="col4"><input id="nonPaying" type="checkbox" name="person.attribute.14" value="Non-Paying" /> Non-Paying</div>
					<div class="col4 last"><input id="specialSchemes" type="checkbox" name="person.attribute.14" value="Special Schemes" /> Special Schemes</div>
				</div>
				<div class="onerow">
					<div class="col4">
						<span id="payingCategoryField"><select id="payingCategory" name="person.attribute.44" onchange="payingCategorySelection();" ></select></span>
					
					</div>
					<div class="col4">
						<span id="nonPayingCategoryField"><select id="nonPayingCategory" name="person.attribute.45" onchange="nonPayingCategorySelection();" >	</select></span>
					</div>
					<div class="col4 last">
						<span id="specialSchemeCategoryField"><select id="specialScheme" name="person.attribute.46" onchange="specialSchemeSelection();" style='width: 152px;'>	</select></span>
					</div>
				</div>
				
				<h2>Next of Kin Details</h2>
	     		<div class="onerow">
					<div class="col4"><label>Relative Name</div>
					<div class="col4"><label>Relationship</label></div>
					<div class="col4 last"><label>Physical Address</label></div>
				</div>
				<div class="onerow">
					<div class="col4">
						<input id="patientRelativeName" name="person.attribute.8"  />				
					</div>
					<div class="col4">
						<select id="relationshipType" name="person.attribute.15" style='width: 152px;'>
											<option value="Relationship"></option>
											<option value="Parent">Parent</option>
											<option value="Spouse">Spouse</option>
											<option value="Guardian">Guardian</option>
											<option value="Friend">Friend</option>
											<option value="Other">Other</option>
						</select>
					</div>
					<div class="col4 last">
						<input type="text" id="relativePostalAddress" name="person.attribute.28" />
					</div>
				</div>
				<div class="onerow">
					<div class="col4"><label></label></div>
					<div class="col4"><label></label> </div>
					<div class="col4 last"> <input id="sameAddress" type="checkbox"/> Same as Patient</div>
				</div>
				
				<h2>Visit Information</h2>
	     		<div class="onerow">
					<div class="col4"><label>Medico Legal Case</div>
					<div class="col4"><label>Refferal Information</label></div>
					<div class="col4 last"><label>Room to Visit</label></div>
				</div>
				<div class="onerow">
					<div class="col4">
						<input id="mlcCaseYes" type="checkbox" name="mlcCaseYes"/> Yes&nbsp;<br />
						<input id="mlcCaseNo" type="checkbox" name="mlcCaseNo"/> No&nbsp;			
					</div>
					<div class="col4">
						<input id="referredYes" type="checkbox" name="referredYes"/> Yes&nbsp;<br />
						<input id="referredNo" type="checkbox" name="referredNo"/> No&nbsp;
					</div>
					<div class="col4 last">
						<input id="triageRoom" type="checkbox" name="triageRoom"/> Triage Room &nbsp;<br />
						<input id="opdRoom" type="checkbox" name="opdRoom"/> OPD Room&nbsp;<br />
						<input id="specialClinicRoom" type="checkbox" name="specialClinicRoom"/> Special Clinic&nbsp;
					</div>
				</div>
				<div class="onerow">
					<div class="col4"><label></label></div>
					<div class="col4"><label></label> </div>
					<div class="col4 last"> </div>
				</div>
		  		<div class="onerow">
					<div class="col3"><label></label></div>
					<div class="col3"><input type="submit" value="Next"  class="medium" /></div>
					<div class="col3"><input type="button" value="Reset" onclick="window.location.href=window.location.href"/></div>
					<div class="col3 last"><label></label></div>
				</div>	  	
		  	</div>		  	  	
		</div>	
	</form>
</div>