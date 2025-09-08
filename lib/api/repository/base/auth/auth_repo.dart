

import 'package:injectable/injectable.dart';

import '../../../model/auth/login_model.dart';
import '../../../network/result.dart';
import '../../../service/auth_service.dart';
import '../base_repository.dart';

@lazySingleton
class AuthRepository extends BaseRepository {

  Future<Result<LoginModel>> getLogin({required String password, required String email}) async =>
      safeCall(
          AuthService(await dio).loginUser("application/json",
              email,password
          ));

}
