class AppConfig {
  //Production
  // static const HOST = 'http://192.168.29.254:5000/api';
  static const HOST = 'https://protector.lifesafeguard.in/api/v1/';
  static String IMAGE_BASE_URL = '';

  static const login = "/userSignup/login";
  static const profile = "/get-profile";
  static const requestOtp = "auth/request-otp";
  static const getIncidents = "incidents";
  static const signup = "signup";
  static const verifyOtp = "auth/verify-otp";
  static const userAgreement = "/user-agreement";
}
