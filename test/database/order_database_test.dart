import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/database/database.dart';
import 'package:gigantic_ticket_wallet/database/order_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.createInMemoryDatabase();
  });
  tearDown(() async {
    await database.close();
  });

  test('Adding order test', () async {

    final orderDatabase = OrderDatabase(database: database);

    const expectedId = '1';
    const order = OrderData(
        id: expectedId,
        reference: 'reference',
        startTime: 0,
        hasRefundPlan: true,
    );

    await orderDatabase.addOrder(order);

    final foundOrders = await orderDatabase.getOrders();

    final foundOrder = foundOrders.firstOrNull;

    expect(foundOrder?.id, expectedId, reason: 'unexpected order id');

  });

}
