import 'package:get_it/get_it.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';
import 'package:gigantic_ticket_wallet/notificationScreen/notification_screen_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_screen_notifier.g.dart';

///
@riverpod
class NotificationScreenNotifier extends _$NotificationScreenNotifier {

  @override
  FutureOr<List<NotificationData>> build() async {
    return List.empty();
  }

  ///
  Future<void> addNotification() async {
    final repository = GetIt.I.get<NotificationScreenRepositoryInterface>();

    await repository.addNotification();

    final notifications = await repository.getAllNotifications();

    state = AsyncData(notifications);
  }

  ///
  Future<void> getNotifications() async {
    final repository = GetIt.I.get<NotificationScreenRepositoryInterface>();

    final notifications = await repository.getAllNotifications();

    state = AsyncData(notifications);
  }

}
