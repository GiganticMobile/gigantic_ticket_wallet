import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigantic_ticket_wallet/error_container.dart';
import 'package:gigantic_ticket_wallet/loginScreen/login_screen.dart';
import 'package:gigantic_ticket_wallet/verificationScreen/verification_result.dart';
import 'package:gigantic_ticket_wallet/verificationScreen/verification_screen_notifier.dart';
import 'package:go_router/go_router.dart';

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
                      const Text(
                        "For extra security, we've emailed you a login code.\nEnter it here.",
                        textAlign: TextAlign.center,),
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
class VerificationCodeInput extends ConsumerStatefulWidget {
  /// constructor
  const VerificationCodeInput({super.key});

  @override
  VerificationCodeInputState createState() => VerificationCodeInputState();
}

///
class VerificationCodeInputState extends ConsumerState<VerificationCodeInput> {

  final _verificationCodeController = TextEditingController();

  @override
  void dispose() {
    _verificationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = verificationScreenNotifierProvider;
    final verificationResultState = ref.watch(provider);

    ref.listen(provider, (previous, next) {
      if (next.value == VerificationResult.success) {
        context.go('/Sync');
      }
    });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            autocorrect: false,
            controller: _verificationCodeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),),
              hintText: 'Code',
            ),
            maxLength: 10,
          ),
        ),

        AnimatedOpacity(
          opacity: verificationResultState.value?.isError ?? false ? 1.0 : 0.0,
          duration: const Duration(seconds: 3),
          child: verificationResultState.value?.isError ?? false ?
          ErrorContainer(
              errorMessage: verificationResultState.value?.message
                  ?? 'Unexpected error',)
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
          final verificationCode = _verificationCodeController.value.text;

          //final email = GoRouterState.of(context).extra! as String;

          _verificationCodeController.clear();

          //'999111'
          ref.read(provider.notifier).verify('test@gigantic.com', verificationCode);
        },),

      ],
    );
  }
}
