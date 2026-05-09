// lib/data/repositories/bookmark_repository_impl.dart

import '../../domain/entities/bookmark_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../datasources/bookmark_local_datasource.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkLocalDataSource localDataSource;

  BookmarkRepositoryImpl(this.localDataSource);

  @override
  Future<void> addBookmark(BookmarkEntity bookmark) {
    return localDataSource.addBookmark(bookmark);
  }

  @override
  Future<void> removeBookmark(int productId) {
    return localDataSource.removeBookmark(productId);
  }

  @override
  Stream<List<BookmarkEntity>> watchBookmarks() {
    return localDataSource.watchBookmarks();
  }

  @override
  Future<bool> isBookmarked(int productId) {
    return localDataSource.isBookmarked(productId);
  }
}
