import 'package:get_it/get_it.dart';
import 'package:gigantic_ticket_wallet/common/app_navigation_bar_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_navigation_bar_notifier.g.dart';

///
@riverpod
class AppNavigationBarNotifier extends _$AppNavigationBarNotifier {

  @override
  FutureOr<bool> build() async {
    return false;
  }

  ///
  Future<void> hasUnreadNotifications() async {
    final repository = GetIt.I.get<AppNavigationBarRepositoryInterface>();

    final unread = await repository.hasUnreadNotifications();

    state = AsyncData(unread);
  }

}
