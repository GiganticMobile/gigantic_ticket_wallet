import 'dart:convert';

///handles api authentication
class Auth {

  ///generates auth token for api
  static String getAuthToken() {
    const basicUserName = 'wallet_app';
    const basicPassword = r'4iwdij7213$%qwe$';
    final auth = 'Basic ${
        base64Encode(
            utf8.encode('$basicUserName:$basicPassword'),
        )}';
    return auth;
  }

}
