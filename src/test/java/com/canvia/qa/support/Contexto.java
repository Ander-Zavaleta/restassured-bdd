package com.canvia.qa.support;

import io.restassured.response.Response;

/** Estado compartido entre los steps de un mismo escenario. */
public class Contexto {
    public Response respuesta;
    public Integer idReserva;
}
