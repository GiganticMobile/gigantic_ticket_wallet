import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigantic_ticket_wallet/syncScreen/sync_screen_notifier.dart';
import 'package:go_router/go_router.dart';

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
class SyncProgressIndicator extends ConsumerWidget {
  /// constructor
  const SyncProgressIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = syncScreenNotifierProvider;
    ref.listen(provider, (previous, next) {
      if (next.value ?? false == true) {
        context.go('/Order');
      }
    });
    
    return const CircularProgressIndicator();
  }
}
