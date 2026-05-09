# UTD Store - [Nama Depan Anda]
## ETS Mobile Programming Lanjut 2025/2026
### NIM: 20123069

---

## Struktur Folder (Clean Architecture)

```
lib/
├── main.dart
├── injection_container.dart          ← GetIt DI setup
│
├── core/
│   └── router/
│       └── app_router.dart           ← GoRouter setup
│
├── domain/                           ← LAYER DOMAIN (Business Logic)
│   ├── entities/
│   │   ├── product_entity.dart
│   │   └── bookmark_entity.dart
│   ├── repositories/
│   │   ├── product_repository.dart   ← Abstract interface
│   │   └── bookmark_repository.dart
│   └── usecases/
│       ├── get_products_usecase.dart
│       └── splash_delay_usecase.dart ← Delay 9 detik di sini!
│
├── data/                             ← LAYER DATA (API, DB)
│   ├── models/
│   │   └── product_model.dart
│   ├── datasources/
│   │   ├── product_remote_datasource.dart
│   │   └── bookmark_local_datasource.dart
│   └── repositories/
│       ├── product_repository_impl.dart  ← Logika "[Diskon 10%]" di sini!
│       └── bookmark_repository_impl.dart
│
└── presentation/                     ← LAYER PRESENTATION (UI)
    ├── splash/
    │   └── splash_page.dart
    ├── home/
    │   ├── cubit/
    │   │   ├── product_cubit.dart
    │   │   └── product_state.dart
    │   └── home_page.dart
    ├── detail/
    │   └── detail_page.dart
    ├── bookmark/
    │   └── bookmark_page.dart
    └── crypto/
        └── crypto_page.dart
```

---

## Cara Menjalankan

1. `flutter pub get`
2. `dart run build_runner build --delete-conflicting-outputs`
3. `flutter run`

## Build APK
```
flutter build apk --release
```

---

## Logika Personal (NIM: 20123069)
- Digit terakhir: **9 (Ganjil)**
- Splash delay: **9 detik**
- Label produk: **"[Diskon 10%]"**
- Isolate loop: **69 × 10.000.000 = 690.000.000 kali**
