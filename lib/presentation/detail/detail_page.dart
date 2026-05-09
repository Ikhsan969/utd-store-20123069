// lib/presentation/detail/detail_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../../injection_container.dart';

class DetailPage extends StatefulWidget {
  final ProductEntity product;
  const DetailPage({super.key, required this.product});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkBookmark();
  }

  Future<void> _checkBookmark() async {
    final result = await sl<BookmarkRepository>().isBookmarked(widget.product.id);
    if (mounted) setState(() => _isBookmarked = result);
  }

  Future<void> _toggleBookmark() async {
    final repo = sl<BookmarkRepository>();
    if (_isBookmarked) {
      await repo.removeBookmark(widget.product.id);
    } else {
      await repo.addBookmark(BookmarkEntity(
        productId: widget.product.id,
        title: widget.product.title,
        price: widget.product.price,
        image: widget.product.image,
        savedAt: DateTime.now(),
      ));
    }
    if (mounted) setState(() => _isBookmarked = !_isBookmarked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Detail Produk',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.favorite : Icons.favorite_border,
              color: const Color(0xFFE94560),
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar produk
            Center(
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: Image.network(
                  widget.product.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Badge kategori
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF0F3460),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.product.category.toUpperCase(),
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ),
            const SizedBox(height: 12),

            // Nama produk (sudah include "[Diskon 10%]" dari repository)
            Text(
              widget.product.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),

            // Harga
            Text(
              '\$${widget.product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFFE94560),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Rating
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${widget.product.rating} (${widget.product.ratingCount} ulasan)',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Deskripsi
            const Text(
              'Deskripsi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.description,
              style: const TextStyle(color: Colors.white70, height: 1.6),
            ),
            const SizedBox(height: 30),

            // Tombol tambah bookmark
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _toggleBookmark,
                icon: Icon(_isBookmarked ? Icons.favorite : Icons.favorite_border),
                label: Text(_isBookmarked ? 'Hapus Bookmark' : 'Tambah Bookmark'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE94560),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
