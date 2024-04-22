import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:gigantic_ticket_wallet/database/model/order.dart';
import 'package:gigantic_ticket_wallet/database/model/ticket.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

///
@DriftDatabase(tables: [Order, Ticket])
class AppDatabase extends _$AppDatabase {

  ///
  AppDatabase(super.e);
  
  /// 
  AppDatabase.createDatabase() : super(_openConnection());

  /// in memory database for tests
  AppDatabase.createInMemoryDatabase() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  ///
  @override
  MigrationStrategy get mirgation {
    return MigrationStrategy(
      beforeOpen: (details) async {
        ///set up foreign keys
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
