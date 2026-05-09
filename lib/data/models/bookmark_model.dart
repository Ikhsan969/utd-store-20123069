// lib/data/models/bookmark_model.dart
// Menggunakan sqflite - tidak perlu build_runner/code generation!

import '../../domain/entities/bookmark_entity.dart';

class BookmarkModel {
  final int? id;
  final int productId;
  final String title;
  final double price;
  final String image;
  final DateTime savedAt; // ⭐ LOGIKA PERSONAL: timestamp wajib

  BookmarkModel({
    this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.savedAt,
  });

  // Konversi dari Map (hasil query sqflite)
  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    return BookmarkModel(
      id: map['id'] as int?,
      productId: map['productId'] as int,
      title: map['title'] as String,
      price: map['price'] as double,
      image: map['image'] as String,
      savedAt: DateTime.fromMillisecondsSinceEpoch(map['savedAt'] as int),
    );
  }

  // Konversi ke Map (untuk insert ke sqflite)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'savedAt': savedAt.millisecondsSinceEpoch,
    };
  }

  // Konversi ke domain entity
  BookmarkEntity toEntity() {
    return BookmarkEntity(
      productId: productId,
      title: title,
      price: price,
      image: image,
      savedAt: savedAt,
    );
  }

  // Buat dari domain entity
  static BookmarkModel fromEntity(BookmarkEntity entity) {
    return BookmarkModel(
      productId: entity.productId,
      title: entity.title,
      price: entity.price,
      image: entity.image,
      savedAt: entity.savedAt,
    );
  }
}
