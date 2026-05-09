// lib/core/router/app_router.dart
//
// ⭐ Semua navigasi menggunakan GoRouter
// TIDAK ADA Navigator.push biasa di aplikasi ini!

import 'package:go_router/go_router.dart';
import '../../domain/entities/product_entity.dart';
import '../../presentation/splash/splash_page.dart';
import '../../presentation/home/home_page.dart';
import '../../presentation/detail/detail_page.dart';
import '../../presentation/bookmark/bookmark_page.dart';
import '../../presentation/crypto/crypto_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final product = state.extra as ProductEntity;
        return DetailPage(product: product);
      },
    ),
    GoRoute(
      path: '/bookmark',
      builder: (context, state) => const BookmarkPage(),
    ),
    GoRoute(
      path: '/crypto',
      builder: (context, state) => const CryptoPage(),
    ),
  ],
);
