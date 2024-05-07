import 'package:drift/drift.dart';
import 'package:gigantic_ticket_wallet/database/model/order.dart';

/// event model for the database
class Event extends Table {

  ///primary key
  IntColumn get id => integer().autoIncrement()();
  /// the id of the order the event is related to
  TextColumn get order =>
      text().references(Order, #id, onDelete: KeyAction.cascade)();
  ///
  TextColumn get presenter => text()();
  ///
  TextColumn get title => text()();
  ///
  TextColumn get subTitle => text()();
  ///time in millisecondsSinceEpoch
  IntColumn get doorsOpenTime => integer()();
  ///time in millisecondsSinceEpoch
  IntColumn get startTime => integer()();
  ///time in millisecondsSinceEpoch
  IntColumn get endTime => integer()();
  ///
  TextColumn get seatingPlan => text()();
  ///
  TextColumn get venue => text()();
  ///
  TextColumn get venueAddress => text()();
  ///
  TextColumn get venueCity => text()();
  ///
  TextColumn get venuePostcode => text()();
  ///if null venue location is not set
  RealColumn get venueLatitude => real().nullable()();
  ///if null venue location is not set
  RealColumn get venueLongitude => real().nullable()();
  ///
  TextColumn get venueType => text()();
  ///
  TextColumn get campaignImage => text()();
  ///
  TextColumn get eventImage => text()();
  ///
  TextColumn get restriction => text()();
  ///
  TextColumn get promoter => text()();

}
