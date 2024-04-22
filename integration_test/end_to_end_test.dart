import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'loginScreen/login_screen_actions.dart';
import 'main_test.dart' as app;
import 'verificationScreen/verification_screen_actions.dart';

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

  group('end to end tests', () {
    patrolTest('End to end test',
            ($) async {
      app.main();

      await Future<void>.delayed(const Duration(seconds: 3));

      await $.pumpAndSettle();

      await VerificationScreenActions.test($);

      await $.pumpAndSettle();

      await LoginScreenActions.test($);

      await Future<void>.delayed(const Duration(seconds: 10));

        });
  });
}
