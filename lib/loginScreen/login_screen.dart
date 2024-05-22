import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigantic_ticket_wallet/error_container.dart';
import 'package:gigantic_ticket_wallet/loginScreen/login_result.dart';
import 'package:gigantic_ticket_wallet/loginScreen/login_screen_notifier.dart';
import 'package:gigantic_ticket_wallet/notifications/notification_handler.dart';
import 'package:go_router/go_router.dart';

/// login screen of the app
class LoginScreen extends StatelessWidget {
  /// constructor
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            OrientationBuilder(builder: (context, orientation) {
              if (MediaQuery.of(context).orientation == Orientation.portrait) {
                return Column(children: [
                  //this will be replaced by the icon
                  Container(
                    color: Theme.of(context).colorScheme.primary,
                    height: 100,
                    width: 100,),

                  const Text('Login to your account',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,),
                    textAlign: TextAlign.center,),
                  const Text('Enter your user account details, this can be found on your order confirmation.',
                    textAlign: TextAlign.center,),
                ],);
              } else {
                return const SizedBox.shrink();
              }
            },),

            const LoginInput(),
          ],),
    ),
    );
  }
}

/// this widget contains the username and password
class LoginInput extends ConsumerStatefulWidget {
  /// constructor
  const LoginInput({super.key});

  @override
  LoginInputState createState() => LoginInputState();
}

///
class LoginInputState extends ConsumerState<LoginInput> {

  /// constructor
  LoginInputState();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    NotificationHandler.requestPermission(context);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = loginScreenNotifierProvider;
    final loginResultState = ref.watch(provider);

    ref.listen(provider, (previous, next) {
      if (next.value == LoginResult.success) {
        context.go('/Sync');
      }
    });

    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: TextField(
                  key: const Key('userNameKey'),
                  autocorrect: false,
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),),
                    hintText: 'User name',
                  ),
                ),
              ),

              Padding(
                  padding: const EdgeInsets.all(4),
                  child: PasswordTextField(controller: _passwordController),
              ),

              AnimatedOpacity(
                opacity: loginResultState.value?.isError ?? false ? 1.0 : 0.0,
                duration: const Duration(seconds: 3),
                child: loginResultState.value?.isError ?? false ?
                ErrorContainer(
                  errorMessage: loginResultState.value?.message
                      ?? 'Unexpected error',
                )
                    : const SizedBox.shrink(),
              ),

              VerificationButton(usernameController: _usernameController,),

              OrientationBuilder(builder: (context, orientation) {
                if (MediaQuery.of(context).orientation == Orientation.portrait) {
                  return Column(children: [
                    LoginButton(width: double.maxFinite, onPress: () {
                      final username = _usernameController.value.text;
                      final password = _passwordController.value.text;

                      _usernameController.clear();
                      _passwordController.clear();

                      ref.read(provider.notifier).login(username, password);
                    },),
                    SignupButton(width: double.maxFinite, onPress: () {
                      context.go('/Signup');
                    },),
                  ],);
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LoginButton(width: 150, onPress: () {
                        final username = _usernameController.value.text;
                        final password = _passwordController.value.text;

                        _usernameController.clear();
                        _passwordController.clear();

                        ref.read(provider.notifier).login(username, password);
                      },),
                      SignupButton(width: 150, onPress: () {
                        context.go('/Signup');
                      },),
                    ],);
                }
              },),

            ],),
    );
  }
}

///
class LoginButton extends StatelessWidget {
  
  /// constructor
  const LoginButton({
    required double width, 
    required void Function() onPress, super.key,}) 
      : _onPress = onPress, _width = width;
  
  final double _width;
  final void Function() _onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FilledButton(
        key: const Key('loginButtonKey'),
        onPressed: _onPress.call,
        style: FilledButton.styleFrom(
          fixedSize: Size(_width, 50),
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),),
        ),
        child: const Text('LOGIN', style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25,),),
      ),
    );
  }
}

///
class SignupButton extends StatelessWidget {
  /// constructor
  const SignupButton({
    required double width, 
    required void Function() onPress, 
    super.key,}) 
      : _onPress = onPress, _width = width;
  
  final double _width;
  final void Function() _onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FilledButton(
        onPressed: _onPress.call,
        style: FilledButton.styleFrom(
          fixedSize: Size(_width, 50),
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(8),),
        ),
        child: Text('Sign up', style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          fontSize: 25,),),
      ),
    );
  }
}

///
class PasswordTextField extends StatefulWidget {
  /// constructor
  const PasswordTextField({
    required TextEditingController controller,
    super.key,})
      : _controller = controller;

  final TextEditingController _controller;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {

  bool _canViewPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('passwordKey'),
      obscureText: _canViewPassword,
      enableSuggestions: false,
      autocorrect: false,
      controller: widget._controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),),
        hintText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _canViewPassword ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            setState(() {
              _canViewPassword = !_canViewPassword;
            });
          },
        ),
      ),
    );
  }
}

///
class VerificationButton extends StatefulWidget {
  /// constructor
  const VerificationButton({
    required TextEditingController usernameController,
    super.key,}) : _usernameController = usernameController;

  final TextEditingController _usernameController;

  @override
  State<VerificationButton> createState() => _VerificationButtonState();
}

class _VerificationButtonState extends State<VerificationButton> {
  bool showNoEmailError = false;

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedOpacity(
          opacity: showNoEmailError ? 1.0 : 0.0,
          duration: const Duration(seconds: 3),
          child: showNoEmailError
              ? const ErrorContainer(
            errorMessage: 'Please enter your email address in order to get a verification code.',
          )
              : const SizedBox.shrink(),
        ),

      Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: TextButton(
              onPressed: () {
                final username = widget._usernameController.value.text;

                if (username.isNotEmpty) {
                  setState(() {
                    showNoEmailError = false;
                  });
                  context.go('/Verification', extra: username);
                } else {
                  setState(() {
                    showNoEmailError = true;
                  });
                }
                /**
                 * The user should not be able to go the
                 * the verification screen without first adding
                 * an email address.
                 */
              },
              child: const Text('Forgotten your password?',
                style: TextStyle(fontWeight: FontWeight.w600,),),
            ),
          ),
        ],),
    ],);
  }
}
