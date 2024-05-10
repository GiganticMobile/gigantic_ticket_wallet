import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigantic_ticket_wallet/viewOrderScreen/event_schedule_view.dart';
import 'package:gigantic_ticket_wallet/viewOrderScreen/ticket_view.dart';
import 'package:gigantic_ticket_wallet/viewOrderScreen/view_order_screen_notifier.dart';
import 'package:go_router/go_router.dart';

/// displays general information about an order and the related event
class ViewOrderScreen extends ConsumerWidget {
  /// constructor
  const ViewOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderId = GoRouterState.of(context).extra! as String;
    final order = ref.watch(ViewOrderScreenNotifierProvider(orderId));
    
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text('123-456-789'),
          ),
        body: ListView(children: [

          /** it might be better if the event title replaces the
           * event reference, and the event reference and event
           * date go in the event information section.
           * This would allow the user to see the ticket
           * selector without the need to scroll.
           */
          ScreenTitle(
            eventTitle: order.valueOrNull?.event.title ?? '',
            eventDate: order.valueOrNull?.event.startDate ?? '',),

          if (order.valueOrNull != null)
            TicketListView(tickets: order.valueOrNull!.tickets)
          else const SizedBox.shrink(),

          const Divider(color: Colors.green,),

          EventScheduleView(schedule: [
            ScheduleItem(
              title: 'Gate',
              time: DateTime.now(),
            ),
            ScheduleItem(
              title: 'Start',
              time: DateTime.now().add(const Duration(minutes: 2)),
              delay: DateTime.now().add(const Duration(minutes: 3)),
            ),
            ScheduleItem(
              title: 'End',
              time: DateTime.now().add(const Duration(minutes: 4)),
            ),
          ],),

          const Divider(color: Colors.green,),

          EventInfo(
            eventInfo: '',
            eventImage: order.valueOrNull?.event.image ?? '',),

          const Divider(color: Colors.green,),

          VenueInfo(
            venueAddress: order.valueOrNull?.event.venue.address ?? '',
            venueInfo: order.valueOrNull?.event.venue.description ?? '',
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Contact customer services'),
              trailing: IconButton(onPressed: () {

              }, icon: const Icon(Icons.arrow_forward),),
              shape: Border.all(color: Colors.cyan),
            ),
          ),

        ],),
        ),
    );
  }
}

/// this widget contains the event title and date
class ScreenTitle extends StatelessWidget {
  /// constructor
  const ScreenTitle({
    required String eventTitle,
    required String eventDate,
    super.key,})
      : _eventTitle = eventTitle, _eventDate = eventDate;

  final String _eventTitle;
  final String _eventDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(_eventTitle,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        Text(_eventDate),
      ],),
    );
  }
}

/// this contains event information
class EventInfo extends StatelessWidget {
  /// constructor
  const EventInfo({
    required String eventInfo,
    required String eventImage,
    super.key,}) : _eventInfo = eventInfo, _eventImage = eventImage;

  final String _eventInfo;
  final String _eventImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const Text('Information',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

        Text(_eventInfo),

        Container(
          height: 200,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.cyanAccent,
            borderRadius: BorderRadius.circular(4),),
        ),
      ],),
    );
  }
}

/// this contains venue information
class VenueInfo extends StatelessWidget {
  /// constructor
  const VenueInfo({
    required String venueAddress,
    required String venueInfo,
    super.key,}) : _venueAddress = venueAddress, _venueInfo = venueInfo;

  final String _venueAddress;
  final String _venueInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const Text('Venue',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

        //address of the venue
        Text(_venueAddress),

        Text(_venueInfo),
      ],),
    );
  }
}
