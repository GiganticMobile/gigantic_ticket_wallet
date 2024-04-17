/// Login result used to display on the ui (login screen)
enum LoginResult implements Comparable<LoginResult> {

  /// initial state the user has not attempted to log in
  unknown(
    id: 0,
    message: 'unknown',
    isError: false,
  ),
  /// the user has successfully logged in
  success(
    id: 1,
    message: 'Login Successful',
    isError: false,
  ),
  /// default error
  unexpectedError(
    id: 2,
    message:
    "The email or password don't match our records. \nPlease try again.",
    isError: true,
  ),
  /// no connection to the internet error
  noConnectedError(
    id: 3,
    message:
    'This device is not connected to the internet. \nPlease try again.',
    isError: true,
  ),
  /// error the user is missing either username, password or both
  emptyInput(
    id: 4,
    message: 'Either your username or password is empty. \nPlease try again.',
    isError: true,
  ),
  /// the username or password was wrong
  wrongInput(
    id: 5,
    message:
    "The email or password don't match our records. \nPlease try again.",
    isError: true,
  );

  const LoginResult({
    required this.id,
    required this.message,
    required this.isError,
  });

  /// used to identify result
  final int id;
  /// information for the user such as an error message
  final String message;
  /// is the result an error if so display error popup
  final bool isError;

  @override
  int compareTo(LoginResult other) {
    return other.id - id;
  }
}
