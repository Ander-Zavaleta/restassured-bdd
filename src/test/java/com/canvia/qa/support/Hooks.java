package com.canvia.qa.support;

import io.cucumber.java.Before;
import io.restassured.RestAssured;

public class Hooks {

    @Before
    public void configurarApi() {
        RestAssured.baseURI = System.getProperty("baseUrl", "https://restful-booker.herokuapp.com");
        RestAssured.enableLoggingOfRequestAndResponseIfValidationFails();
    }
}
