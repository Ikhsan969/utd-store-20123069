// lib/presentation/bookmark/bookmark_page.dart
//
// ⭐ REACTIVE: Menggunakan StreamBuilder + watch() dari Isar
// TIDAK ADA setState di halaman ini!

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../injection_container.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: const Text(
          'Bookmark Saya',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // ⭐ StreamBuilder bereaksi real-time tanpa setState!
      body: StreamBuilder<List<BookmarkEntity>>(
        stream: sl<BookmarkRepository>().watchBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFE94560)),
            );
          }

          final bookmarks = snapshot.data ?? [];

          if (bookmarks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 64, color: Colors.white24),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada bookmark',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              return _BookmarkItem(bookmark: bookmarks[index]);
            },
          );
        },
      ),
    );
  }
}

class _BookmarkItem extends StatelessWidget {
  final BookmarkEntity bookmark;
  const _BookmarkItem({required this.bookmark});

  @override
  Widget build(BuildContext context) {
    // ⭐ LOGIKA PERSONAL: Format timestamp "Disimpan pada HH:mm"
    final timeFormat = DateFormat('HH:mm');
    final savedTimeStr = 'Disimpan pada ${timeFormat.format(bookmark.savedAt)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            bookmark.image,
            width: 56,
            height: 56,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.broken_image,
              color: Colors.white30,
            ),
          ),
        ),
        title: Text(
          bookmark.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '\$${bookmark.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFFE94560),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            // ⭐ Tampilkan timestamp format jam
            Text(
              savedTimeStr,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 11,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.white38),
          onPressed: () async {
            await sl<BookmarkRepository>().removeBookmark(bookmark.productId);
            // Tidak perlu setState - stream akan otomatis update!
          },
        ),
      ),
    );
  }
}
