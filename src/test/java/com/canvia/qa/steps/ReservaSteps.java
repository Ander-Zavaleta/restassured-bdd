package com.canvia.qa.steps;

import com.canvia.qa.support.Contexto;
import io.cucumber.java.es.Cuando;
import io.cucumber.java.es.Dado;
import io.cucumber.java.es.Entonces;
import io.restassured.http.ContentType;

import java.util.Map;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.notNullValue;

public class ReservaSteps {

    private final Contexto contexto;

    // PicoContainer inyecta el mismo Contexto en todas las clases de steps del escenario.
    public ReservaSteps(Contexto contexto) {
        this.contexto = contexto;
    }

    @Dado("que la API de reservas está disponible")
    public void apiDisponible() {
        given().when().get("/ping").then().statusCode(201);
    }

    @Dado("que existe una reserva a nombre de {string}")
    public void existeReserva(String nombre) {
        creoReserva(nombre, "Prueba", 100);
        contexto.idReserva = contexto.respuesta.then().statusCode(200).extract().path("bookingid");
    }

    @Cuando("consulto esa reserva")
    public void consultoReserva() {
        contexto.respuesta = given()
                .accept("application/json")
                .pathParam("id", contexto.idReserva)
            .when()
                .get("/booking/{id}");
    }

    @Cuando("creo una reserva para {string} {string} por {int} soles")
    public void creoReserva(String nombre, String apellido, int precio) {
        Map<String, Object> cuerpo = Map.of(
                "firstname", nombre,
                "lastname", apellido,
                "totalprice", precio,
                "depositpaid", true,
                "bookingdates", Map.of("checkin", "2026-11-01", "checkout", "2026-11-05"),
                "additionalneeds", "Desayuno");

        contexto.respuesta = given()
                .contentType(ContentType.JSON)
                .accept("application/json")
                .body(cuerpo)
            .when()
                .post("/booking");
    }

    @Cuando("elimino la reserva con id {int} sin autenticarme")
    public void eliminoSinToken(int id) {
        contexto.respuesta = given().pathParam("id", id).when().delete("/booking/{id}");
    }

    @Entonces("el código de respuesta es {int}")
    public void codigoDeRespuesta(int codigo) {
        contexto.respuesta.then().statusCode(codigo);
    }

    @Entonces("la respuesta contiene el campo {string}")
    public void contieneCampo(String campo) {
        contexto.respuesta.then().body(campo, notNullValue());
    }

    @Entonces("el nombre de la reserva creada es {string}")
    public void nombreCreado(String nombre) {
        contexto.respuesta.then()
                .body("bookingid", notNullValue())
                .body("booking.firstname", equalTo(nombre));
    }
}
