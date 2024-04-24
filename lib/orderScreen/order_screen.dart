import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigantic_ticket_wallet/orderScreen/order_item.dart';
import 'package:gigantic_ticket_wallet/orderScreen/order_screen_notifier.dart';
import 'package:go_router/go_router.dart';

/// this provides a list of orders
class OrderScreen extends StatelessWidget {
  /// constructor
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: const OrderList(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 1,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Orders',),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: 'Account',),
          ],
          onTap: (index) {
            if (index != 1) {
              switch(index) {
                case 0:
                  context.push('/Notification');
                case 1:
                  context.push('/Order');
                case 2:
                  context.push('/Account');
              }
            }
          },
        ),
      ),
    );
  }
}

/// this displays a list of orders
class OrderList extends ConsumerWidget {
  /// constructor
  const OrderList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final orders = ref.watch(orderScreenNotifierProvider).value ?? List.empty();

    return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          return OrderListItem(order: orders[index],);
        },);
  }
}

/// item for the order list
class OrderListItem extends StatelessWidget {
  /// constructor
  const OrderListItem({
    required OrderItem order,
    super.key,}) : _order = order;

  final OrderItem _order;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.cyanAccent,
              borderRadius: BorderRadius.circular(4),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(_order.eventName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,),),
          ),
          Text(_order.venueLocation),
          Text(_order.eventStartDate),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(_order.orderReference),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.confirmation_num),
                    Text(_order.ticketAmount.toString()),
                    const Icon(Icons.add),
                    const Icon(Icons.swap_horiz),
                    Text(_order.transferredTicketAmount.toString()),
                  ],),
              ],),
          ),
        ],),
    );
  }
}
