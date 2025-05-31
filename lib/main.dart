import 'package:belvo_pwa/screens/acount_screen.dart';
import 'package:belvo_pwa/screens/home_screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_provider.dart';
import 'routes.dart'; 


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Belvo PWA',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        initialRoute: '/',
        routes: appRoutes, // rutas sin argumentos
        onGenerateRoute: (settings) {
          if (settings.name == '/home') {
            final institutions = settings.arguments as List<dynamic>;
            return MaterialPageRoute(
              builder: (_) => HomeScreen(institutions: institutions),
            );
          }

          if (settings.name == '/accounts') {
            final bankName = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => AccountScreen(bankName: bankName),
            );
          }

          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Ruta no encontrada')),
            ),
          );
        },
      ),
    );
  }
}