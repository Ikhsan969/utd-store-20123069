# PANDUAN SETUP & GITHUB COMMITS
## UTD Store - NIM: 20123069

---

## LANGKAH 1: Setup Project Flutter

```bash
# Buat project Flutter baru
flutter create utd_store
cd utd_store

# Ganti isi pubspec.yaml dengan yang sudah dibuat
# Kemudian:
flutter pub get

# Generate kode Isar
dart run build_runner build --delete-conflicting-outputs
```

---

## LANGKAH 2: Copy Semua File

Salin semua file sesuai struktur folder:

```
lib/
  main.dart
  injection_container.dart
  core/router/app_router.dart
  core/platform/native_channel.dart
  domain/entities/product_entity.dart
  domain/entities/bookmark_entity.dart
  domain/repositories/product_repository.dart
  domain/repositories/bookmark_repository.dart
  domain/usecases/splash_delay_usecase.dart
  domain/usecases/get_products_usecase.dart
  data/models/product_model.dart
  data/models/bookmark_model.dart
  data/datasources/product_remote_datasource.dart
  data/datasources/bookmark_local_datasource.dart
  data/repositories/product_repository_impl.dart
  data/repositories/bookmark_repository_impl.dart
  presentation/splash/splash_page.dart
  presentation/home/home_page.dart
  presentation/home/cubit/product_cubit.dart
  presentation/home/cubit/product_state.dart
  presentation/home/widgets/battery_widget.dart
  presentation/detail/detail_page.dart
  presentation/bookmark/bookmark_page.dart
  presentation/crypto/crypto_page.dart

android/app/src/main/kotlin/com/utdstore/utd_store/MainActivity.kt
```

---

## LANGKAH 3: Sesuaikan Package Name

Di `MainActivity.kt`, ubah package name:
```kotlin
package com.utdstore.utd_store  // ← sesuaikan
```

Cek package name asli project Anda di:
`android/app/src/main/AndroidManifest.xml`

---

## LANGKAH 4: Ganti Nama Depan

Di `splash_page.dart`, cari dan ganti:
```dart
'[NAMA DEPAN ANDA]'  // ← ganti dengan nama depan Anda
```

---

## LANGKAH 5: BatteryWidget - Tambahkan ke HomePage

Di `home_page.dart`, tambahkan `BatteryWidget` di bawah GridView:

```dart
import 'widgets/battery_widget.dart';

// Di dalam body, bungkus dengan Column:
body: Column(
  children: [
    const BatteryWidget(),
    Expanded(
      child: BlocBuilder<ProductCubit, ProductState>(
        // ... kode yang sudah ada
      ),
    ),
  ],
),
```

---

## LANGKAH 6: STRATEGY COMMIT (WAJIB ≥ 10 COMMIT)

Lakukan commit BERTAHAP sesuai panduan soal:

```bash
git init
git remote add origin https://github.com/USERNAME/utd-store-20123069.git

# Commit 1 (Hari 1)
git add pubspec.yaml README.md
git commit -m "Initial setup: add dependencies (dio, isar, go_router, get_it, bloc)"
git push

# Commit 2 (Hari 1)
git add lib/domain/
git commit -m "feat: add domain layer - entities, repositories interface, usecases"
git push

# Commit 3 (Hari 2)
git add lib/data/models/
git commit -m "feat: add data models - ProductModel, BookmarkModel (Isar collection)"
git push

# Commit 4 (Hari 2)
git add lib/data/datasources/
git commit -m "feat: add datasources - Dio remote with interceptor, Isar local"
git push

# Commit 5 (Hari 2)
git add lib/data/repositories/
git commit -m "feat: add repository impl - NIM:20123069 personal logic [Diskon 10%]"
git push

# Commit 6 (Hari 3)
git add lib/injection_container.dart lib/core/router/
git commit -m "feat: setup GetIt DI container and GoRouter navigation"
git push

# Commit 7 (Hari 3)
git add lib/presentation/splash/ lib/presentation/home/cubit/
git commit -m "feat: add splash (9s delay usecase) and product cubit BLoC"
git push

# Commit 8 (Hari 4)
git add lib/presentation/home/ lib/presentation/detail/
git commit -m "feat: add home page grid view and product detail page"
git push

# Commit 9 (Hari 4)
git add lib/presentation/bookmark/
git commit -m "feat: add bookmark page with Isar reactive stream (watch), timestamp UI"
git push

# Commit 10 (Hari 5)
git add lib/presentation/crypto/
git commit -m "feat: add crypto page - WebSocket BTC price, Isolate 690jt loop NIM:69"
git push

# Commit 11 (Hari 5)
git add lib/core/platform/ lib/presentation/home/widgets/ android/
git commit -m "feat: add platform channel - battery % and native Toast Android"
git push

# Commit 12 (Hari 6 - opsional untuk polish)
git add .
git commit -m "fix: polish UI, add error handling, finalize for ETS submission"
git push
```

---

## CATATAN PENTING UNTUK VIDEO PRESENTASI

### Yang harus dijelaskan di 2 menit terakhir:

**1. Isolate compute** (di `crypto_page.dart`):
- Tunjukkan fungsi `_taxCalculationIsolate` (top-level function)
- Jelaskan kenapa harus top-level (tidak bisa akses closure)
- Tunjukkan `const int twoLastDigitsNIM = 69`
- Jelaskan: 69 × 10.000.000 = 690.000.000 loop
- Tunjukkan `Isolate.spawn()` dan `receivePort`
- Demo: harga BTC tetap update saat isolate berjalan

**2. Interceptor Dio** (di `product_remote_datasource.dart`):
- Tunjukkan `_dio.interceptors.add(PrettyDioLogger(...))`
- Tunjukkan custom `InterceptorsWrapper` dengan log NIM
- Jelaskan: onRequest, onResponse, onError handlers

**3. Logika Personal** (di `product_repository_impl.dart`):
- Tunjukkan `const int lastDigit = 9`
- Tunjukkan `suffix = ' [Diskon 10%]'` karena ganjil
- Jelaskan: modifikasi di repository, BUKAN di Widget Text
