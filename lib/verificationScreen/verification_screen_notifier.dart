import 'package:get_it/get_it.dart';
import 'package:gigantic_ticket_wallet/verificationScreen/verification_result.dart';
import 'package:gigantic_ticket_wallet/verificationScreen/verification_screen_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verification_screen_notifier.g.dart';

///This handles the ui state of the verification screen
@riverpod
class VerificationScreenNotifier extends _$VerificationScreenNotifier {

  @override
  FutureOr<VerificationResult> build() async {
    return VerificationResult.unknown;
  }

  ///
  Future<void> verify(String email, String code) async {
    state = const AsyncLoading();

    await GetIt.I.isReady<VerificationScreenRepositoryInterface>();
    final repository = GetIt.I.get<VerificationScreenRepositoryInterface>();

    final verificationResult = await repository.verify(email, code);

    state = AsyncData(verificationResult);
  }

}
