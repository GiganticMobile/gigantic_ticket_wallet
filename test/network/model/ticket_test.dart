import 'package:flutter_test/flutter_test.dart';
import 'package:gigantic_ticket_wallet/network/model/ticket.dart';

void main() {

  test('map json to tickets', () {

    const expectedTicketId = '7047174321798659bec782be84860353002';
    const expectedBarcode = '1517102976';
    const expectedHeading = 'General Admission Standing';
    const expectedLabel = 'label';
    const expectedFaceValue = 57.50;
    final json = {
    'barcode': expectedBarcode,
    'heading': expectedHeading,
    'label': expectedLabel,
    'face_value': expectedFaceValue.toString(),
    };

    final ticket = Ticket.fromJson(expectedTicketId, json);

    expect(ticket.id, expectedTicketId, reason: 'unexpected ticket id');
    expect(ticket.barcode, expectedBarcode,
        reason: 'unexpected ticket barcode',);
    expect(ticket.heading, expectedHeading,
        reason: 'unexpected ticket heading',);
    expect(ticket.label, expectedLabel, reason: 'unexpected ticket label');
    expect(ticket.value, expectedFaceValue,
        reason: 'unexpected ticket face value',);

  });

}
