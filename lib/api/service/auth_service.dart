import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../constants/app_config.dart';
import '../model/auth/login_model.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio) = _AuthService;

  @GET(AppConfig.login)
  Future<LoginModel> loginUser(@Header("Content-Type") String contentType,@Query("email") String email,@Query("password") String password);

  //  @GET(AppConfig.sendOtp)
  // Future<CommonModel> sentOtp(@Header("Content-Type") String contentType,@Query("email") String email);
  //
  // @POST(AppConfig.register)
  // Future<LoginModel> getRegister(@Header("Content-Type") String contentType,
  //     @Body() Map<String, dynamic> data);

  // @POST(AppConfig.register)
  // Future<RegisterModel> registerUser(@Header("Content-Type") String contentType,@Body() Map<String, dynamic> data);
  //
  // @POST(AppConfig.forgotPassword)
  // Future<CommonModel> forgotPassword(@Body() Map<String, dynamic> data);

}