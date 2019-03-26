package com.example.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RequestHelper {

	public static String process(HttpServletRequest request, HttpServletResponse response) {

		switch(request.getRequestURI()) {
		
		case "/PetsFrontController/html/Login.do":
			return LoginController.Login(request);
			
		case "/PetsFrontController/html/Home.do":
			return HomeController.Home(request);
			
		case "/PetsFrontController/html/Register.do":
			return RegisterController.Register(request);
		
		default:
			return "/html/Login.html";
		}
	}
}