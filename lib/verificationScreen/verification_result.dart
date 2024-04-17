/// Verification result for the ui (verification screen)
enum VerificationResult implements Comparable<VerificationResult> {

  /// initial state the user has not attempted to verify
  unknown(
    id: 0,
    message: 'unknown',
    isError: false,
  ),
  /// the user has successfully verified
  success(
    id: 1,
    message: 'Verification success full Successful',
    isError: false,
  ),
  /// default error
  unexpectedError(
    id: 2,
    message:
    "This code don't match our records or may have expired. \nPlease try again",
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
    message: 'The verification code is empty. \nPlease try again.',
    isError: true,
  ),
  /// the username or password was wrong
  wrongInput(
    id: 5,
    message:
    "This code don't match our records or may have expired. \nPlease try again",
    isError: true,
  ),
  /// the verification has expired
  expired(
    id: 6,
    message: 'This code has expired. \nPlease try again.',
    isError: true,
  );

  const VerificationResult({
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
  int compareTo(VerificationResult other) {
    return other.id - id;
  }
}
