import 'package:get_it/get_it.dart';
import 'package:gigantic_ticket_wallet/syncScreen/sync_screen_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_screen_notifier.g.dart';

/// handles the state of the sync screen
@riverpod
class SyncScreenNotifier extends _$SyncScreenNotifier {

  @override
  FutureOr<bool> build() async {
    final repository = GetIt.I.get<SyncScreenRepositoryInterface>();

    await repository.syncOrders();
    return true;
  }

  ///
  Future<void> sync() async {
    state = const AsyncLoading();

    final repository = GetIt.I.get<SyncScreenRepositoryInterface>();

    await repository.syncOrders();

    state = const AsyncData(true);
  }

}
