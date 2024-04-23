import 'package:get_it/get_it.dart';
import 'package:gigantic_ticket_wallet/accountScreen/account_screen_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_screen_notifier.g.dart';

///This handles the ui state of the login screen
@riverpod
class AccountScreenNotifier extends _$AccountScreenNotifier {

  @override
  FutureOr<void> build() async {

  }

  /**
   * the app should check if the user has allowed the permission here
   * and update the notification settings accordingly.
   */

  /// log user out
  Future<void> logout() async {
    await GetIt.I.isReady<AccountScreenRepositoryInterface>();
    final repository = GetIt.I.get<AccountScreenRepositoryInterface>();
    await repository.logout();
  }

  /// get all notifications option
  Future<bool> getAllowedNotificationsOption() async {
    await GetIt.I.isReady<AccountScreenRepositoryInterface>();
    final repository = GetIt.I.get<AccountScreenRepositoryInterface>();
    return repository.getAllowedNotificationsOption();
  }

  /// save all notification option
  Future<void> setAllowAllNotificationsOption({required bool isAllowed}) async {
    await GetIt.I.isReady<AccountScreenRepositoryInterface>();
    final repository = GetIt.I.get<AccountScreenRepositoryInterface>();
    return repository.setAllowAllNotificationsOption(isAllowed: isAllowed);
  }

  // only updates references notifications like event delayed
  /// get only updates option
  Future<bool> getOnlyUpdatesOption() async {
    await GetIt.I.isReady<AccountScreenRepositoryInterface>();
    final repository = GetIt.I.get<AccountScreenRepositoryInterface>();
    return repository.getOnlyUpdatesOption();
  }

  /// save only updates option
  Future<void> setOnlyUpdatesOption({required bool isAllowed}) async {
    await GetIt.I.isReady<AccountScreenRepositoryInterface>();
    final repository = GetIt.I.get<AccountScreenRepositoryInterface>();
    return repository.setOnlyUpdatesOption(isAllowed: isAllowed);
  }

}
