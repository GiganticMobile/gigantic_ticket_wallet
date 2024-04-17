import 'package:flutter/material.dart';

/// This screen tells the use that the app is loading
class SyncScreen extends StatelessWidget {
  /// constructor
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SyncProgressIndicator(),
          ],
        ),
      ),
    ),
    );
  }
}

/// app loading indicator
class SyncProgressIndicator extends StatefulWidget {
  /// constructor
  const SyncProgressIndicator({super.key});

  @override
  State<SyncProgressIndicator> createState() => _SyncProgressIndicatorState();
}

class _SyncProgressIndicatorState extends State<SyncProgressIndicator> {

  @override
  void initState() {
    /*SyncScreenRepository().syncTickets().then((value) {
      context.go('/Welcome');
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}
