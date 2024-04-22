import 'package:patrol/patrol.dart';

class TestingUtils {

  static Future<void> internetDisconnect(PatrolIntegrationTester $) async {
    //turn off internet connection
    await $.native.disableWifi();
    await $.native.disableCellular();

    //wait for device to fully disconnect
    await Future<void>.delayed(const Duration(seconds: 5));

    await $.pump();
  }

  static Future<void> internetConnect(PatrolIntegrationTester $) async {
    //reconnect to the internet
    await $.native.enableWifi();
    await $.native.enableCellular();

    //wait for device to fully reconnect
    await Future<void>.delayed(const Duration(seconds: 10));

    await $.pump();
  }

}
