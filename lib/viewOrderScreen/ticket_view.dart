import 'package:flutter/material.dart';

import 'package:gigantic_ticket_wallet/viewOrderScreen/barcode_view.dart';
import 'package:gigantic_ticket_wallet/viewOrderScreen/order_info.dart';

/*
based on
https://medium.com/@ilicborisdev/creating-a-customisable-carousel-in-flutter-a-step-by-step-guide-856ceaef973a
 */

///
class TicketListView extends StatefulWidget {
  /// constructor
  const TicketListView({required List<TicketInfo> tickets, super.key})
      : _tickets = tickets;

  final List<TicketInfo> _tickets;

  @override
  State<TicketListView> createState() => _TicketListViewState();
}

class _TicketListViewState extends State<TicketListView> {

  @override
  Widget build(BuildContext context) {
    return Carousel(
      tickets: widget._tickets,
    );
  }
}

/// horizontal list of tickets
class Carousel extends StatefulWidget {
  ///constructor
  const Carousel({required List<TicketInfo> tickets, super.key})
      : _tickets = tickets;

  final List<TicketInfo> _tickets;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {

  final PageController _pageController = PageController();

  @override
  void initState() {
  _pageController.addListener(_handlePageChanged);
  super.initState();
  }

  @override
  void dispose() {
  _pageController.dispose();
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: 645, padding: const EdgeInsets.all(8), color: Colors.green,
          child: PageView(
          controller: _pageController,
          children: widget._tickets.map(
                  (ticketInfo) => TicketWidget(ticketInfo: ticketInfo),
          ).toList(),
        ),),
        CarouselIndicators(
          indicatorAmount: widget._tickets.length,
          selectedIndicator:
          _pageController.positions.isEmpty ? 0 : _pageController.page!.round(),
          onIndicatorPressed: _animateToPage,
        ),
      ],
    );
  }

  void _animateToPage(int page) {
    _pageController.animateToPage(
        page,
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn,);
  }

  void _handlePageChanged() {
    setState(() {});
  }
}

///carousel item position indicator ie the little buttons under the tickets
class CarouselIndicators extends StatelessWidget {
  /// constructor
  const CarouselIndicators({
    required int indicatorAmount,
    required int selectedIndicator,
    required void Function(int) onIndicatorPressed,
    super.key,})
      : _indicatorAmount = indicatorAmount,
        _selectedIndicator = selectedIndicator,
        _onIndicatorPressed = onIndicatorPressed;

  final int _indicatorAmount;
  final int _selectedIndicator;
  final void Function(int) _onIndicatorPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_indicatorAmount, (index) => index).map((i) {
        return Container(
          padding: const EdgeInsets.all(5),
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                color: (i == _selectedIndicator) ?
                const Color.fromRGBO(17, 173, 200, 0.984) :
                const Color.fromRGBO(2, 64, 75, 0.98),
                shape: BoxShape.circle,
            ),
            child: GestureDetector(
              onTap: () => _onIndicatorPressed(i),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// this is the widget that handles displaying ticket info
class TicketWidget extends StatelessWidget {
  ///constructor
  const TicketWidget({required TicketInfo ticketInfo, super.key})
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
        mainAxisSize: MainAxisSize.min,
        children: [

          BarcodeView(
            barcode: _ticketInfo.barcode,
            viewAt: _ticketInfo.showAt,
            cancelledOn: _ticketInfo.cancelledDate,
            transferredTo: _ticketInfo.transferredTo,
          ),

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

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_ticketInfo.entrance != null ? 'Entrance' : ''),
                      Text(_ticketInfo.entrance ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,),),
                    ],),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_ticketInfo.entranceStand != null ? 'Stand' : ''),
                      Text(_ticketInfo.entranceStand ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,),),
                    ],),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_ticketInfo.entranceCodes != null ? 'Codes' : ''),
                      Text(_ticketInfo.entranceCodes ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,),),
                    ],),
                ],),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text( _ticketInfo.entranceGate != null ? 'Gate' : ''),
                      Text(_ticketInfo.entranceGate ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,),),
                    ],),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_ticketInfo.entranceArea != null ? 'Area' : ''),
                      Text(_ticketInfo.entranceArea ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,),),
                    ],),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_ticketInfo.entranceTurnstiles != null
                              ? 'Turnstiles' : '',),
                      Text(_ticketInfo.entranceTurnstiles ?? '',
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
