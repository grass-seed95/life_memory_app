import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';

final albumListProvider = FutureProvider<List<Album>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.select(db.albums).get();
});

class AlbumNotifier extends StateNotifier<AsyncValue<List<Album>>> {
  final AppDatabase _db;
  AlbumNotifier(this._db) : super(const AsyncValue.loading()) {
    _loadAlbums();
  }

  Future<void> _loadAlbums() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _db.select(_db.albums).get());
  }

  Future<void> createAlbum(String name) async {
    await _db.into(_db.albums).insert(AlbumsCompanion(name: Value(name)));
    await _loadAlbums();
  }

  Future<void> deleteAlbum(int id) async {
    await (_db.delete(_db.albums)..where((t) => t.id.equals(id))).go();
    await _loadAlbums();
  }

  Future<void> updateAlbumName(int id, String name) async {
    await (_db.update(_db.albums)..where((t) => t.id.equals(id)))
        .write(AlbumsCompanion(name: Value(name)));
    await _loadAlbums();
  }
}
