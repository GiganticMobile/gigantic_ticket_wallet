import 'package:get_it/get_it.dart';
import 'package:gigantic_ticket_wallet/loginScreen/login_result.dart';
import 'package:gigantic_ticket_wallet/loginScreen/login_screen_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/*
generated with
flutter pub run build_runner build --delete-conflicting-outputs
*/

part 'LoginScreenNotifier.g.dart';

///This handles the ui state of the login screen
@riverpod
class LoginScreenNotifier extends _$LoginScreenNotifier {

  @override
  FutureOr<LoginResult> build() async {
    return LoginResult.unknown;
  }

  ///
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    await GetIt.I.isReady<LoginScreenRepositoryInterface>();
    final repository = GetIt.I.get<LoginScreenRepositoryInterface>();

    final loginResult = await repository.login('test@gigantic.com', '123654');

    state = AsyncData(loginResult);
  }

}
