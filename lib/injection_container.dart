// lib/injection_container.dart
//
// ⭐ Semua dependency didaftarkan di sini menggunakan GetIt
// TIDAK ADA inisialisasi manual (new Repository()) di UI!

import 'package:get_it/get_it.dart';

import 'data/datasources/bookmark_local_datasource.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/repositories/bookmark_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/bookmark_repository.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/usecases/get_products_usecase.dart';
import 'domain/usecases/splash_delay_usecase.dart';
import 'presentation/home/cubit/product_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // ── DATA SOURCES ──────────────────────────────────────────
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(),
  );

  sl.registerLazySingleton<BookmarkLocalDataSource>(
    () => BookmarkLocalDataSource(),
  );

  // ── REPOSITORIES ──────────────────────────────────────────
  // Abstract → Concrete (dependency inversion principle)
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
  );

  sl.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(sl<BookmarkLocalDataSource>()),
  );

  // ── USE CASES ─────────────────────────────────────────────
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(sl<ProductRepository>()),
  );

  sl.registerLazySingleton<SplashDelayUseCase>(
    () => SplashDelayUseCase(),
  );

  // ── CUBITS / BLOCS ────────────────────────────────────────
  // Factory: buat instance baru setiap kali dipanggil
  sl.registerFactory<ProductCubit>(
    () => ProductCubit(sl<GetProductsUseCase>()),
  );
}
