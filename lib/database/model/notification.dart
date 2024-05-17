import 'package:drift/drift.dart';
import 'package:gigantic_ticket_wallet/database/model/order.dart';

///
class Notification extends Table {

  ///primary key
  IntColumn get id => integer().autoIncrement()();


  /// the id of the order the notification is related to
  /// not all notifications will be linked to an order (such as
  /// a notification informing the user of some news)
  TextColumn get order =>
      text().references(Order, #id, onDelete: KeyAction.cascade).nullable()();

  ///this is the id that the device uses to identify the notification
  ///When a notification is given to the device it must have an id
  ///This id is the hash code of the order id as it links an order
  ///to a notification.
  ///There is a possibility that a notification does not need to be given
  ///to the device so does not need a notification id hence why it is nullable
  IntColumn get notificationId => integer().nullable()();

  ///
  TextColumn get title => text()();

  ///
  TextColumn get body => text()();

  ///
  IntColumn get type => intEnum<NotificationType>()();

  ///
  BoolColumn get seen => boolean().withDefault(const Constant(false))();

  ///
  DateTimeColumn get createdAt => dateTime()();

}

/// this represents the type of notification
enum NotificationType {
  /// event delayed notification
  delay,
  /// event cancelled notification
  cancelled,
  /// remind user that event starts soon notification
  reminder,
  /// ask user to rate event notification
  rate,
  /// general information that the user might be interested in notification
  info
}
