import 'package:flutter/material.dart';
import 'package:intercommerce_app/core/errors/failures.dart';

class ErrorMessage extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const ErrorMessage({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(_mapErrorToMessage(error), textAlign: TextAlign.center),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }

  String _mapErrorToMessage(Object error) {
    if (error is ConnectionFailure) return 'Check your connection.';
    if (error is ServerFailure) return 'The server is down for maintenance.';
    if (error is NotFoundFailure) return 'Product not found.';
    if (error is DatabaseFailure) return 'Database error.';
    return 'Something went wrong. Please try again.';
  }
}
