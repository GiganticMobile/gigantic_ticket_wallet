import 'package:gigantic_ticket_wallet/network/endpoints/verification_end_points.dart';

/// handles api requests related to verification
class VerificationAPI extends VerificationAPIInterface {

  /// constructor
  VerificationAPI({required VerificationEndPointsInterface endPoints}) {
    _endPoints = endPoints;
  }
  late final VerificationEndPointsInterface _endPoints;

  @override
  Future<bool> verify(String email, String code) async {
    final response = await _endPoints.verify(email, code);

    if (response == null) {
      return false;
    }

    if (response.data['status'] == 'LOGIN SUCCESSFUL') {
      return true;
    } else {
      return false;
    }
  }

}

///
abstract class VerificationAPIInterface {

  /// this checks of the user was successfully verified
  Future<bool> verify(String email, String code);
}
