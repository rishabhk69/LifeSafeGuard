class AppConfig {
  //Production
  // static const HOST = 'http://192.168.29.254:5000/api';
  static const HOST = 'https://protector.lifesafeguard.in/api/v1/';
  static String IMAGE_BASE_URL = 'https://lifesafeguardpictures.s3.ap-south-1.amazonaws.com/';
  static String VIDEO_BASE_URL = 'https://lifesafeguardvideos.s3.ap-south-1.amazonaws.com/';

  static const login = "/userSignup/login";
  static const profile = "/get-profile";
  static const requestOtp = "auth/request-otp";
  static const getIncidents = "incidents";
  static const getProfile = "incidents/";
  static const signup = "signup";
  static const verifyOtp = "auth/verify-otp";
  static const postIncidents = "incidents";
  static const userAgreement = "/user-agreement";
  static const getBlockedIncidents = "/blocked-incidents";
  static const getComments = "/incidents";
  static const postComments = "/comment";
  static const deleteAccount = "/delete";
}
