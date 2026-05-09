// lib/data/repositories/product_repository_impl.dart
//
// ⭐ LOGIKA PERSONAL ANTI-AI ⭐
// NIM: 20123069 → digit terakhir = 9 (GANJIL)
// → Tambahkan "[Diskon 10%]" di belakang nama produk
// Logika ini dilakukan di REPOSITORY layer, BUKAN di Widget UI

import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProductEntity>> getProducts() async {
    final models = await remoteDataSource.fetchProducts();

    return models.map((model) {
      final entity = model.toEntity();

      // ⭐ LOGIKA PERSONAL: NIM 20123069, digit terakhir 9 = GANJIL
      // Maka tambahkan "[Diskon 10%]" di belakang nama produk
      // Jika digit terakhir GENAP → "[Promo Ongkir]"
      const int lastDigit = 9; // Digit terakhir NIM
      final String suffix = (lastDigit % 2 != 0)
          ? ' [Diskon 10%]'
          : ' [Promo Ongkir]';

      return ProductEntity(
        id: entity.id,
        title: entity.title + suffix, // ← Modifikasi di sini, bukan di UI!
        price: entity.price,
        description: entity.description,
        category: entity.category,
        image: entity.image,
        rating: entity.rating,
        ratingCount: entity.ratingCount,
      );
    }).toList();
  }
}
