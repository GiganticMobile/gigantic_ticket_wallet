import 'package:get_it/get_it.dart';
import 'package:gigantic_ticket_wallet/viewOrderScreen/order_info.dart';
import 'package:gigantic_ticket_wallet/viewOrderScreen/view_order_screen_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'view_order_screen_notifier.g.dart';

/// handles the state of the sync screen
@riverpod
class ViewOrderScreenNotifier extends _$ViewOrderScreenNotifier {

  @override
  FutureOr<OrderInfo?> build(String orderId) async {
    final repository = GetIt.I.get<ViewOrderScreenRepositoryInterface>();

    return await repository.getOrder(orderId);
  }

  ///
  Future<void> getOrderInfo(String orderId) async {
    state = const AsyncLoading();

    final repository = GetIt.I.get<ViewOrderScreenRepositoryInterface>();

    final order = await repository.getOrder(orderId);

    state = AsyncData(order);
  }

}
