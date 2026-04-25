abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = 'Error en el servidor']);
}

class ConnectionFailure extends Failure {
  ConnectionFailure([super.message = 'Sin conexión a internet']);
}

class DatabaseFailure extends Failure {
  DatabaseFailure([
    super.message = 'Error al acceder a la base de datos local',
  ]);
}
