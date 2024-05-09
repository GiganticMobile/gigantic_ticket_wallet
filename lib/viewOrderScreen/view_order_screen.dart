import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigantic_ticket_wallet/viewOrderScreen/barcode_view.dart';
import 'package:gigantic_ticket_wallet/viewOrderScreen/event_schedule_view.dart';
import 'package:gigantic_ticket_wallet/viewOrderScreen/order_info.dart';
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
          TicketView(ticketInfo: order.valueOrNull!.tickets.first)
          else const SizedBox.shrink(),

          const TicketSelector(),

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

///displays a ticket
class TicketView extends StatelessWidget {
  ///constructor
  const TicketView({required TicketInfo ticketInfo, super.key})
      : _ticketInfo = ticketInfo;
  final TicketInfo _ticketInfo;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(4),),
      child: Column(
        children: [

          BarcodeView(
            barcode: '123456',
            viewAt: DateTime.now().add(const Duration(minutes: 1)),),

          Text(_ticketInfo.heading,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Text(_ticketInfo.label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),

          //face value
          Text(_ticketInfo.value),

          const Divider(color: Colors.green,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
              Text('Block'),
              Text('Block name',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,),),
            ],),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Row'),
                Text(_ticketInfo.seatRow,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,),),
              ],),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Seat'),
                Text(_ticketInfo.seatNum,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,),),
              ],),
          ],),

          const Divider(color: Colors.green,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_ticketInfo.entrance == null) const SizedBox.shrink()
                else Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Entrance'),
                  Text(_ticketInfo.entrance!,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,),),
                ],),

                if (_ticketInfo.entranceStand == null) const SizedBox.shrink()
                else Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Stand'),
                  Text(_ticketInfo.entranceStand!,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,),),
                ],),

                if (_ticketInfo.entranceCodes == null) const SizedBox.shrink()
                else Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Codes'),
                  Text(_ticketInfo.entranceCodes!,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,),),
                ],),
            ],),

              if (_ticketInfo.entranceGate == null) const SizedBox.shrink()
              else Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Gate'),
                  Text(_ticketInfo.entranceGate!,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,),),
                ],),

                if (_ticketInfo.entranceArea == null) const SizedBox.shrink()
                else Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Area'),
                  Text(_ticketInfo.entranceArea!,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,),),
                ],),

                if (_ticketInfo.entranceTurnstiles == null)
                  const SizedBox.shrink()
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Turnstiles'),
                      Text(_ticketInfo.entranceTurnstiles!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,),),
                    ],),
              ],),
            ],),

          const Divider(color: Colors.green,),

          const ListTile(
            leading: Icon(Icons.more_horiz),
            title: Text('Ticket options'),),

      ],),
    );
  }
}

/// select ticket
class TicketSelector extends StatelessWidget {
  ///constructor
  const TicketSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
          width: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return index != 6 ?
              IconButton.filled(
                onPressed: () {},
                icon: Text('$index',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,),
                ),
              )
                  :
              IconButton(onPressed: () {},
                  icon: const Icon(Icons.fiber_manual_record),);
            },),
        ),
      ],
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
