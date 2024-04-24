import 'package:get_it/get_it.dart';
import 'package:gigantic_ticket_wallet/orderScreen/order_item.dart';
import 'package:gigantic_ticket_wallet/orderScreen/order_screen_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_screen_notifier.g.dart';

/// handles the state of the order screen
@riverpod
class OrderScreenNotifier extends _$OrderScreenNotifier {

  @override
  FutureOr<List<OrderItem>> build() async {
    final repository = GetIt.I.get<OrderScreenRepositoryInterface>();

    return repository.getOrders();
  }
}
