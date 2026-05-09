// lib/domain/entities/bookmark_entity.dart
// Ini adalah PURE entity (tidak ada anotasi Isar di sini)

class BookmarkEntity {
  final int productId;
  final String title;
  final double price;
  final String image;
  final DateTime savedAt; // Timestamp wajib sesuai soal

  const BookmarkEntity({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.savedAt,
  });
}
