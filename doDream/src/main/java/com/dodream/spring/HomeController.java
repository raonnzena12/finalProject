package com.dodream.spring;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HomeController {
	
	@RequestMapping(value = "home.dr", method = RequestMethod.GET)
	public String home() {
		return "home";
	}
	@RequestMapping(value = "adminHome.dr", method = RequestMethod.GET)
	public String temp() {
		return "admin/adminHome";
	}
	
}




