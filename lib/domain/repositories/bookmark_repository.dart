// lib/domain/repositories/bookmark_repository.dart

import '../entities/bookmark_entity.dart';

abstract class BookmarkRepository {
  Future<void> addBookmark(BookmarkEntity bookmark);
  Future<void> removeBookmark(int productId);
  Stream<List<BookmarkEntity>> watchBookmarks(); // Reactive stream
  Future<bool> isBookmarked(int productId);
}
