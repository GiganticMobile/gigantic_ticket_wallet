import 'package:gigantic_ticket_wallet/database/login_database.dart';
import 'package:gigantic_ticket_wallet/network/verification_api.dart';
import 'package:gigantic_ticket_wallet/utils/connection_utils.dart';
import 'package:gigantic_ticket_wallet/verificationScreen/verification_result.dart';

///handles business logic for verification screen
class VerificationScreenRepository
    extends VerificationScreenRepositoryInterface {

  /// constructor
  VerificationScreenRepository({
    required VerificationAPIInterface api,
    required LoginDatabaseInterface database,
    required ConnectionUtilsInterface connectionUtils,
  }) :
    _api = api,
    _database = database,
    _connectionUtils = connectionUtils;

  final VerificationAPIInterface _api;
  final LoginDatabaseInterface _database;
  final ConnectionUtilsInterface _connectionUtils;

  @override
  Future<VerificationResult> verify(String email, String code) async {

    if (email.isEmpty || code.isEmpty) {
      return VerificationResult.emptyInput;
    }

    if (await _connectionUtils.hasInternetConnection() == false) {
      return VerificationResult.noConnectedError;
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
