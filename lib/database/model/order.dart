import 'package:drift/drift.dart';

/// order model for database
class Order extends Table {

  ///
  TextColumn get id => text()();
  ///
  TextColumn get reference => text()();
  ///
  TextColumn get event => text()();
  ///
  TextColumn get venue => text()();
  /// event start time in millisecondsSinceEpoch
  IntColumn get startTime => integer()();

  @override
  Set<Column> get primaryKey => {id};

}
