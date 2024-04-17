import 'package:flutter/material.dart';

/// This is used to display an error on the login and verification screens
class ErrorContainer extends StatelessWidget {
  /// constructor
  const ErrorContainer({required String errorMessage, super.key}) :
        _errorMessage = errorMessage;
  final String _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(4),),
      child: Text(_errorMessage,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.onError),),);
  }
}
