import 'package:drift/drift.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';

///handles interactions with the tickets in the database
class EventDatabase extends EventDatabaseInterface {
  /// constructor
  EventDatabase({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  @override
  Future<void> addEvent(EventData event) async {
    final inserting = EventCompanion.insert(
      order: event.order,
      presenter: event.presenter,
      title: event.title,
      subTitle: event.subTitle,
      doorsOpenTime: Value(event.doorsOpenTime),
      startTime: Value(event.startTime),
      endTime: Value(event.endTime),
      seatingPlan: event.seatingPlan,
      venue: event.venue,
      venueAddress: event.venueAddress,
      venueCity: event.venueCity,
      venuePostcode: event.venuePostcode,
      venueLatitude: Value(event.venueLatitude),
      venueLongitude: Value(event.venueLongitude),
      venueType: event.venueType,
      campaignImage: event.campaignImage,
      eventImage: event.eventImage,
      restriction: event.restriction,
      promoter: event.promoter,
    );

    final existingOrder = await getEventByOrder(event.order);

    //this ensures that each order only has one event
    //and does not contain duplicates of the same event.
    if (existingOrder != null) {
      await (_database.delete(_database.event)
        ..where((event) => event.id.equals(existingOrder.id)))
        .go();
    }

    await _database.into(_database.event).insertOnConflictUpdate(inserting);
  }

  @override
  Future<List<EventData>> getEvents() async {
    final events = await _database.select(_database.event).get();

    return events;
  }

  @override
  Future<EventData?> getEventByOrder(String orderId) async {
    final events = await (_database.select(_database.event)
      ..where((event) => event.order.equals(orderId)))
      .getSingleOrNull();

    return events;
  }

}

///
abstract class EventDatabaseInterface {

  ///
  Future<void> addEvent(EventData event);

  ///
  Future<List<EventData>> getEvents();

  ///
  Future<EventData?> getEventByOrder(String orderId);
}
