abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = 'Error on the server']);
}

class ConnectionFailure extends Failure {
  ConnectionFailure([super.message = 'No internet connection']);
}

class DatabaseFailure extends Failure {
  DatabaseFailure([super.message = 'Error accessing local database']);
}

class NotFoundFailure extends Failure {
  NotFoundFailure([super.message = 'Product not found']);
}
