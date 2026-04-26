import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(const ProviderScope(child: InterCommerceApp()));
}

class InterCommerceApp extends StatelessWidget {
  const InterCommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'InterCommerce App',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        secondaryHeaderColor: Colors.indigoAccent,
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.indigo,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
