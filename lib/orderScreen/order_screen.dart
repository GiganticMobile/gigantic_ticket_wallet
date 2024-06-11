import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigantic_ticket_wallet/common/app_navigation_bar.dart';
import 'package:gigantic_ticket_wallet/orderScreen/order_item.dart';
import 'package:gigantic_ticket_wallet/orderScreen/order_screen_notifier.dart';
import 'package:go_router/go_router.dart';

/// this provides a list of orders
class OrderScreen extends StatelessWidget {
  /// constructor
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: OrderList(),
        bottomNavigationBar: AppNavigationBar(currentScreen: 1,),
      ),
    );
  }
}

/// this displays a list of orders
class OrderList extends ConsumerStatefulWidget {
  /// constructor
  const OrderList({super.key});

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends ConsumerState<OrderList> {

  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(orderScreenNotifierProvider.notifier).getOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderScreenNotifierProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('Upcoming',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,),),
              ),
            ],
          ),

          SizedBox(
            height: 440,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: orders.valueOrNull?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return OrderListItem(order: orders.valueOrNull![index],);
              },),
          ),

          const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('Past',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,),),
              ),
            ],
          ),

          SizedBox(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: orders.valueOrNull?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return PastOrderItem(order: orders.valueOrNull![index],);
              },),
          ),
        ],),
    );
  }
}

/// item for the order list
class OrderListItem extends StatefulWidget {
  /// constructor
  const OrderListItem({
    required OrderItem order,
    super.key,}) : _order = order;

  final OrderItem _order;

  @override
  State<OrderListItem> createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem>
    with SingleTickerProviderStateMixin {

  late final AnimationController _animationController;

  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync:
      this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(4),),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
      
                  Text(widget._order.orderReference),
      
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.confirmation_num),
                      Text(widget._order.ticketAmount.toString()),
                      const Icon(Icons.add),
                      const Icon(Icons.swap_horiz),
                      Text(widget._order.transferredTicketAmount.toString()),
                    ],),
                ],),
            ),
            Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: widget._order.imageUrl,
                  placeholder: (context, url) => Image.asset('assets/no_image.jpg'),
                  errorWidget: (context, url, error) => Image.asset('assets/no_image.jpg'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(widget._order.eventName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,),),
            ),
            Text(widget._order.venueLocation),
            Text(widget._order.eventStartDate),
            Row(children: [
              Expanded(child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                onPressed: () {
                  context.push('/ViewOrder', extra: widget._order.id);
                }, child: const Text('VIEW ORDER'),),),
            ],),
      
          ],),
      ),
    );
  }
}

/// this displays orders to events that have passed
class PastOrderItem extends StatefulWidget {
  /// constructor
  const PastOrderItem({
    required OrderItem order,
    super.key,}) : _order = order;

  final OrderItem _order;

  @override
  State<PastOrderItem> createState() => _PastOrderItemState();
}

class _PastOrderItemState extends State<PastOrderItem>
    with SingleTickerProviderStateMixin {

  late final AnimationController _animationController;

  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync:
      this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(4),),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(widget._order.orderReference),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.confirmation_num),
                      Text(widget._order.ticketAmount.toString()),
                      const Icon(Icons.add),
                      const Icon(Icons.swap_horiz),
                      Text(widget._order.transferredTicketAmount.toString()),
                    ],),
                ],),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(widget._order.eventName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,),),
            ),
            Text(widget._order.venueLocation),
            Text(widget._order.eventStartDate),
          ],),
      ),
    );
  }
}
