import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (_) => const LoginScreen(),
  '/register': (_) => const RegisterScreen(),
};