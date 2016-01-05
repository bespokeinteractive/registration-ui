package org.openmrs.module.registration.extension.html;

import org.openmrs.module.web.extension.LinkExt;

public class RegistrationHeader extends LinkExt{

	@Override
	public String getLabel() {
		return "registration.title";
	}

	@Override
	public String getUrl() {
		return "registration/patientRegistration.page";
	}

	@Override
	public String getRequiredPrivilege() {
		return "View Locations";
	}
	public MEDIA_TYPE getMediaType() {
		return MEDIA_TYPE.html;
	}

}
