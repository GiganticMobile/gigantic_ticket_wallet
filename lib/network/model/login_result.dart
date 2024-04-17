/// login result
class LoginResult {
  /// constructor
  LoginResult(this.email, this.timeStamp);

  ///
  LoginResult.fromJson(dynamic json) {
    try {
      if (json['data'] case {
      'email_address' : final String email,
      'login_timestamp' : final int timeStamp
      }) {
        this.email = email;
        this.timeStamp = timeStamp;
      } else {
        throw Exception('Could not map json to login result');
      }
    } catch (_) {
      throw Exception('Could not map json to login result');
    }
  }

  /// the users email address
  late final String email;
  /// the time the user logged in
  late final int timeStamp;

}
