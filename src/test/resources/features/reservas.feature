# language: es
Característica: Gestión de reservas en Restful Booker
  Como cliente de la API de reservas
  Quiero crear y consultar reservas
  Para gestionar las estadías de los huéspedes

  Antecedentes:
    Dado que la API de reservas está disponible

  @smoke
  Escenario: Consultar una reserva recién creada
    Dado que existe una reserva a nombre de "Rosa"
    Cuando consulto esa reserva
    Entonces el código de respuesta es 200
    Y la respuesta contiene el campo "firstname"

  @regresion
  Esquema del escenario: Crear reservas con distintos huéspedes
    Cuando creo una reserva para "<nombre>" "<apellido>" por <precio> soles
    Entonces el código de respuesta es 200
    Y el nombre de la reserva creada es "<nombre>"

    Ejemplos:
      | nombre | apellido | precio |
      | Ana    | Torres   | 150    |
      | Luis   | Quispe   | 320    |

  @seguridad
  Escenario: No se puede eliminar una reserva sin token
    Cuando elimino la reserva con id 1 sin autenticarme
    Entonces el código de respuesta es 403
