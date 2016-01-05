package org.openmrs.module.registration.fragment.controller;

import org.openmrs.ui.framework.UiUtils;

public class NewPatientRegistrationFormFragmentController {
	
	public void controller(){
		//place holder get method to handle the get request for now
	}
	
	
	
	public String post(UiUtils uiUtils){
		//make a dummy return URL for now
		//change this later
		return "redirect:"+uiUtils.pageLink("registration", "statuses");
		
	}

}
