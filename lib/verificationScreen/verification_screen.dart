import 'package:flutter/material.dart';
import 'package:gigantic_ticket_wallet/error_container.dart';
import 'package:gigantic_ticket_wallet/loginScreen/login_screen.dart';

///
class VerificationScreen extends StatelessWidget {
  /// constructor
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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

                      const Text('Check your email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,),
                        textAlign: TextAlign.center,),
                      const Text("For extra security, we've emailed you a login code.\nEnter it here.", textAlign: TextAlign.center,),
                    ],);
                  } else {
                    return const SizedBox.shrink();
                  }
                },),

                const VerificationCodeInput(),

              ],),
        ),
    );
  }
}

///
class VerificationCodeInput extends StatefulWidget {
  /// constructor
  const VerificationCodeInput({super.key});

  @override
  State<VerificationCodeInput> createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {

  final verificationCodeController = TextEditingController();

  bool showError = false;

  final verificationTime = DateTime.now().add(const Duration(minutes: 1));

  @override
  void dispose() {
    verificationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            autocorrect: false,
            controller: verificationCodeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),),
              hintText: 'Code',
            ),
            maxLength: 10,
          ),
        ),

        AnimatedOpacity(
          opacity: showError ? 1.0 : 0.0,
          duration: const Duration(seconds: 3),
          child: showError ? const ErrorContainer(
            errorMessage: "This code don't match our records or may have expired. \nPlease try again",)
              : const SizedBox.shrink(),
        ),

        TweenAnimationBuilder<Duration>(
            duration: const Duration(minutes: 1),
            tween: Tween(begin: const Duration(minutes: 1), end: Duration.zero),
            builder: (BuildContext context, Duration value, Widget? child) {
              final String seconds;
              if ((value.inSeconds % 60) < 10) {
                seconds = '0${value.inSeconds % 60}';
              } else {
                seconds = '${value.inSeconds % 60}';
              }

              return Text('Available for $seconds seconds');
            },),

        TextButton(onPressed: () {

        }, child: const Text("Didn't receive your code?"),),

        LoginButton(width: double.maxFinite, onPress: () {
          //final verificationCode = verificationCodeController.value.text;

          //final email = GoRouterState.of(context).extra! as String;

          if (DateTime.now().compareTo(verificationTime) >= 0) {
            showDialog<void>(context: context, builder: (_) {
              return const AlertDialog(
                title: Text('Verification code expired'),
              );
            },);
          } else {
            /*VerificationScreenRepository()
            .verify("test@gigantic.com", "999111").then((value) {
              if (value != null) {
                //to add an screen to the screen stack use
                //context.push('/Welcome');
                //to create a new stack
                context.go('/Welcome');
              } else {
                setState(() {
                  showError = true;
                });
              }
            });*/
          }

          verificationCodeController.clear();
        },),

      ],
    );
  }
}
