import 'dart:convert';

import 'package:envied/envied.dart';

part 'auth.g.dart';

///handles api authentication
@Envied(path: '.env')
abstract class Auth {

  ///generates auth token for api
  @EnviedField(varName: "API_KEY", defaultValue: "", obfuscate: true)
  static final String token = utf8.fuse(base64).decode(_Auth.token);

}
