import 'package:dio/dio.dart';
import '../errors/failures.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final _ = switch (err.type) {
      DioExceptionType.connectionTimeout => ConnectionFailure(
        'Tiempo de espera agotado',
      ),
      DioExceptionType.badResponse => ServerFailure(
        'Respuesta inválida del servidor',
      ),
      _ => ServerFailure('Ocurrió un error inesperado'),
    };

    super.onError(err, handler);
  }
}
