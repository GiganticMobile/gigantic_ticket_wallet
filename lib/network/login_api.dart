import 'package:gigantic_ticket_wallet/network/endpoints/login_end_points.dart';
import 'package:gigantic_ticket_wallet/network/model/login_result.dart';

/// This handles the interactions between the app and the
/// login endpoints of the api
class LoginAPI extends LoginAPIInterface {

  /// constructor
  LoginAPI({required LoginEndPointsInterface endPoints}) {
    _endPoints = endPoints;
  }

  late final LoginEndPointsInterface _endPoints;

  @override
  Future<LoginResult?> login(String email, String password) async {

    final response = await _endPoints.login(email, password);

    if (response == null) {
      return null;
    }

    if (response.data['status'] == 'LOGIN SUCCESSFUL') {
      final result = LoginResult.fromJson(response.data);
      return result;
    } else {
      return null;
    }
  }

}

///
abstract class LoginAPIInterface {

  /// interact with login api endpoint
  Future<LoginResult?> login(String email, String password);

}
