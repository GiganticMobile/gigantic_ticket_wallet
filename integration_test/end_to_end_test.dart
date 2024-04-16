import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

/*To run the test
1: install patrol_cli
dart pub global activate patrol_cli

2: check installation
patrol doctor

3: run test
patrol test -t integration_test/end_to_end_test.dart
run with flavor
patrol test --flavor gigscan -t integration_test/end_to_end_test.dart

 */

void main() {
  patrolTest(
    'counter state is the same after going to home and switching apps',
        ($) async {
      // Replace later with your app's main widget
      await $.pumpWidgetAndSettle(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('app')),
            backgroundColor: Colors.blue,
          ),
        ),
      );

      expect($('app'), findsOneWidget);
      if (!Platform.isMacOS) {
        await $.native.pressHome();
      }
    },
  );
}