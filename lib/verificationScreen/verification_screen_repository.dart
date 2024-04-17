import 'package:gigantic_ticket_wallet/database/login_database.dart';
import 'package:gigantic_ticket_wallet/network/verification_api.dart';
import 'package:gigantic_ticket_wallet/verificationScreen/verification_result.dart';

///handles business logic for verification screen
class VerificationScreenRepository
    extends VerificationScreenRepositoryInterface {

  /// constructor
  VerificationScreenRepository({
    required VerificationAPIInterface api,
    required LoginDatabaseInterface database,}) {
    _api = api;
    _database = database;
  }

  late final VerificationAPIInterface _api;
  late final LoginDatabaseInterface _database;

  @override
  Future<VerificationResult> verify(String email, String code) async {

    if (email.isEmpty || code.isEmpty) {
      return VerificationResult.emptyInput;
    }

    /*
    if (DateTime.now().compareTo(verificationTime) >= 0) {
      return VerificationResult.expired;
    }*/

    final result = await _api.verify(email, code);

    if (result == true) {
      await _database.setLoggedInTime();
      return VerificationResult.success;
    } else {
      return VerificationResult.wrongInput;
    }

  }

}

///
abstract class VerificationScreenRepositoryInterface {
  /// verify user with email and password
  Future<VerificationResult> verify(String email, String code,);
}
