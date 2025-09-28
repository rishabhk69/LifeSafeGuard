import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';


class AppUtils {

  String userData = "user_data";
  String name = "name";
  String dob = "dob";
  String phone = "phone";
  String token = "token";
  String remember = "false";
  String email = "email";
  String profileImage = 'profileImage';
  String userEmail = 'userEmail';
  String userPassword = 'userPassword';
  String approveDate = 'approveDate';
  String userCountry = 'userCountry';
  String firstTime = 'first_time';


  Future<void> setUserData(String data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(userData,data);
  }

  Future<void> setName(String data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(name,data);
  }

  Future<void> setDob(String data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(dob,data);
  }

  Future<void> setPhone(String data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(phone,data);
  }

  Future<void> setProfileImage(String data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(profileImage,data);
  }

  Future<String> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? data= preferences.getString(name)??"";
    return data;
  }

  Future<String> getDob() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? data= preferences.getString(dob)??"";
    return data;
  }

  Future<String> getPhone() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? data= preferences.getString(phone)??"";
    return data;
  }

  Future<String> getProfileImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? data= preferences.getString(profileImage)??"";
    return data;
  }

  Future<void> setEmail(String data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(email,data);
  }

  Future<String> getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? data= preferences.getString(email)??"";
    return data;
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString(token)??"";
    return data;
  }

  Future<bool> getRemember() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool data = prefs.getBool(remember)??false;
    return data;
  }

  Future<void> setRemember(bool data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(remember, data);
  }

    Future<void> setToken(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(token, data);
  }

  Future<void> saveUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userEmail, email);
  }

  Future<void> saveUserCountry(String country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userCountry, country);
  }

  Future<void> saveUserPassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userPassword, password);
  }

  Future<void> saveApproveDate(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(approveDate, date);
  }

  Future<Map<String,dynamic>> getUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? data= preferences.getString(userData);
    return data == null ? {} : jsonDecode(data);
  }

  Future<bool> getUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('user_logged_in') ?? false;
    return isLoggedIn;
  }

  void setUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('user_logged_in', true);
  }

  void setLanguage(String selectedLanguage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selected_language', selectedLanguage);
  }

  Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('userEmail') ?? "";
    return email;
  }

  Future<String> getApproveDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String approveDate = prefs.getString('approveDate') ?? "";
    return approveDate;
  }

  Future<String> getUserCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String country = prefs.getString('userCountry') ?? "";
    return country;
  }

  Future<String> getUserPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String password = prefs.getString('userPassword') ?? "";
    return password;
  }

  void setSelectedCurrency(String selectedCurrency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selected_currency', selectedCurrency);
  }

  Future<String> getSelectedCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedCurrency = prefs.getString('selected_currency') ?? "USD";
    return selectedCurrency;
  }

  void setUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', userId);
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id') ?? '';
    return userId;
  }


  void setPushNotification(bool isPushNotification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_push_notification', isPushNotification);
  }

  Future<bool> getPushNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isPushNotification = prefs.getBool('is_push_notification') ?? false;
    return isPushNotification;
  }

  void setEmailNotification(bool isEmailNotification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_email_notification', isEmailNotification);
  }

  Future<bool> getEmailNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isEmailNotification = prefs.getBool('is_email_notification') ?? false;
    return isEmailNotification;
  }

  Future<String> getSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedLanguage = prefs.getString('selected_language') ?? "en";
    return selectedLanguage;
  }

  Future<bool> getThemeSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkModeEnable = prefs.getBool('theme') ?? false;
    return isDarkModeEnable;
  }

  void setContract(bool isContractedGenerated) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_contract_generated', isContractedGenerated);
  }

  Future<bool> getContract() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isContractGenerated = prefs.getBool('is_contract_generated') ?? false;
    return isContractGenerated;
  }

  void setThemeSP(bool isDarkEnable) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme', isDarkEnable);
  }

  Future<bool> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('user_logged_in', false);
    prefs.setString('user_token', '');
    prefs.setString('user_data', '');
    prefs.setString('userName', '');
    prefs.setString('barCode', '');
    prefs.setString('approveDate', '');
    prefs.setInt('user_id', 0);
    prefs.setString('userCountry', '');
    return true;
  }

  void setUserToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_token', token);
  }

  void setMixing(String mixing) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mixing', mixing);
  }

  void setUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', userName);
  }

  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('userName') ?? "";
    return userName;
  }

  void setCurrencyCode(String currencyCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('currencyCode', currencyCode);
  }

  Future<String> getCurrencyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('currencyCode') ?? "";
    return userName;
  }

  Future<String> getMixing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mixing = prefs.getString('mixing') ?? "";
    return mixing;
  }

  void setImageBase(String imageBase) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('imageBase', imageBase);
  }

  Future<String> getImageBase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String imageBase = prefs.getString('imageBase') ?? "";
    return imageBase;
  }

  void setMobile(String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mobile', mobile);
  }

  Future<String> getMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mobile = prefs.getString('mobile') ?? "";
    return mobile;
  }

  void setWebSite(String webSite) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('webSite', webSite);
  }

  Future<String> getWebSite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String webSite = prefs.getString('webSite') ?? "";
    return webSite;
  }

  void setBarCode(String barCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('barCode', barCode);
  }

  Future<String> getBarCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String barCode = prefs.getString('barCode') ?? "";
    return barCode;
  }

  Future<String> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('user_token') ?? "";
    return token;
  }


  void setAppVersionData(String appVersion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('app_version', appVersion);
  }

  Future<String> getAppVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('app_version') ?? "";
    return token;
  }


  /*Generate reference id */
 String generateRefId(String companyId,String? companyName)  {
    String entityStringTwoChar= companyName!.substring(0, companyName.length > 2 ? 2: companyName.length);
    var rng = Random();
    return "$entityStringTwoChar${rng.nextInt(9999-1111)}";
  }

  void setFCMToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fcmToken', token);
  }

  Future<String> getFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fcmToken = prefs.getString('fcmToken') ?? "";
    return fcmToken;
  }

  void setCartData(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cartData', token);
  }

  Future<String> getCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fcmToken = prefs.getString('cartData') ?? "";
    return fcmToken;
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(token);
    await preferences.remove(email);
    await preferences.remove(name);
    await preferences.remove(dob);
    await preferences.remove(phone);
    await preferences.remove(approveDate);
    logoutUser();
  }

}
