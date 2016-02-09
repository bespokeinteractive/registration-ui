package org.openmrs.module.registration.page.controller;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dom4j.DocumentException;
import org.hibernate.annotations.SourceType;
import org.jaxen.JaxenException;
import org.openmrs.module.hospitalcore.matcher.RegistrationUtils;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.ui.Model;

public class PatientRegistrationPageController {

	private static Log logger = LogFactory.getLog(PatientRegistrationPageController.class);

	public void get(HttpServletRequest request, PageModel model, UiUtils uiUtils)
			throws JaxenException, DocumentException, IOException {
		model.addAttribute("patientIdentifier", RegistrationUtils.getNewIdentifier());
		model.addAttribute("date", new Date());
	}

}