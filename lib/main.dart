// lib/main.dart

import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup semua dependency sebelum app berjalan
  await setupDependencies();

  runApp(const UTDStoreApp());
}

class UTDStoreApp extends StatelessWidget {
  const UTDStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'UTD Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE94560),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: appRouter, // ← GoRouter, bukan Navigator biasa!
    );
  }
}
