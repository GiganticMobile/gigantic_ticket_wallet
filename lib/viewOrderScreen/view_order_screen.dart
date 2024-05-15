import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigantic_ticket_wallet/viewOrderScreen/event_schedule_view.dart';
import 'package:gigantic_ticket_wallet/viewOrderScreen/ticket_view.dart';
import 'package:gigantic_ticket_wallet/viewOrderScreen/view_order_screen_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// displays general information about an order and the related event
class ViewOrderScreen extends ConsumerWidget {
  /// constructor
  const ViewOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderId = GoRouterState.of(context).extra! as String;
    final order = ref.watch(ViewOrderScreenNotifierProvider(orderId));

    final schedule = List<ScheduleItem>.empty(growable: true);

    if (order.valueOrNull?.event.doorsOpenTime != null) {
      schedule.add(ScheduleItem(
        title: 'Gate',
        time: order.valueOrNull?.event.doorsOpenTime ?? DateTime.now(),
      ),);
    }

    if (order.valueOrNull?.event.startTime != null) {
      schedule.add(ScheduleItem(
        title: 'Start',
        time: order.valueOrNull?.event.startTime ?? DateTime.now().add(Duration(minutes: 1)),
        //delay: DateTime.now().add(const Duration(minutes: 3)),
      ),);
    }

    if (order.valueOrNull?.event.endTime != null) {
      schedule.add(ScheduleItem(
        title: 'End',
        time: order.valueOrNull?.event.endTime ?? DateTime.now().add(Duration(minutes: 2)),
      ),);
    }
    
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(order.valueOrNull?.orderReference ?? ''),
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

          EventScheduleView(schedule: schedule,),

          const Divider(color: Colors.green,),

          EventInfo(
            eventInfo: '',
            eventImage: order.valueOrNull?.event.image ?? '',),

          const Divider(color: Colors.green,),

          VenueInfo(
            venueAddress: order.valueOrNull?.event.venue.address ?? '',
            venueLongitude: order.valueOrNull?.event.venue.longitude,
            venueLatitude: order.valueOrNull?.event.venue.latitude,
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

          Center(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: CachedNetworkImage(
                imageUrl: _eventImage,
                placeholder: (context, url) => Image.asset('assets/no_image.jpg'),
                errorWidget: (context, url, error) => Image.asset('assets/no_image.jpg'),
              ),
            ),
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
    required double? venueLongitude,
    required double? venueLatitude,
    required String venueInfo,
    super.key,}) :
        _venueAddress = venueAddress,
        _venueLongitude = venueLongitude,
        _venueLatitude = venueLatitude,
        _venueInfo = venueInfo;

  final String _venueAddress;
  final double? _venueLongitude;
  final double? _venueLatitude;
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
          TextButton(onPressed: () async {
            if (_venueLongitude != null && _venueLatitude != null) {
              if (await canLaunchUrl(Uri.parse('https://www.google.com/maps'))) {
                final googleUrl =
                    'https://www.google.com/maps/place/$_venueLatitude, $_venueLongitude';
                await launchUrl(Uri.parse(googleUrl));
              }
            }
          }, child: Text(_venueAddress),),

        Text(_venueInfo),
      ],),
    );
  }
}
