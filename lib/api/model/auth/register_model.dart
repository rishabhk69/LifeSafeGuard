class RegisterModel {
  bool? status;
  String? token;
  Data? data;
  String? message;

  RegisterModel({this.status, this.token, this.data, this.message});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? username;
  dynamic cardNumber;
  dynamic cardNumberFix;
  String? name;
  String? email;
  String? phone;
  int? country;
  String? gender;
  String? address;
  int? isExpired;
  String? designation;
  String? website;
  String? thumb;
  int? userType;
  int? isActive;
  String? loginTime;
  int? isVerify;
  int? isPayment;
  int? accountType;
  String? referralCode;
  dynamic verifyTime;
  String? startDate;
  String? endDate;
  String? postTime;
  int? layouts;
  int? home;
  int? service;
  int? review;
  int? portfolio;
  int? blog;
  int? themes;
  String? colors;
  dynamic hit;
  int? about;
  int? skills;
  int? resume;
  int? appointment;
  int? contacts;
  int? btnStyle;
  int? teams;
  int? isDeactived;
  int? isRequest;
  int? shareLink;
  String? qrCode;
  String? dialCode;
  String? coverPhoto;
  String? whatsapp;
  int? vcardStatus;
  int? vcardLayouts;
  String? vcardBgColor;
  String? fullName;
  int? activeVcard;
  String? currencyCode;
  String? icon;
  int? quickActiveStatus;
  int? isAffiliate;
  int? isCardLinked;
  dynamic countryName;
  int? pushNotificationEnable;
  int? emailNotificationEnable;
  dynamic languageSelection;
  int? isProfileShareable;
  dynamic companyName;
  dynamic profileColor;
  String? displayDialCode;
  String? displayEmail;
  String? displayNumber;
  dynamic additionalAddress;
  dynamic setPassword;
  int? isPasswordEnable;
  int? offerCoin;
  dynamic primaryProfileSlug;
  dynamic primaryProfileLink;
  String? fcmToken;
  dynamic facebookId;
  dynamic googleId;
  dynamic appleId;
  String? shareUrl;

  Data(
      {this.username,
      this.cardNumber,
      this.cardNumberFix,
      this.name,
      this.email,
      this.phone,
      this.country,
      this.gender,
      this.address,
      this.isExpired,
      this.designation,
      this.website,
      this.thumb,
      this.userType,
      this.isActive,
      this.loginTime,
      this.isVerify,
      this.isPayment,
      this.accountType,
      this.referralCode,
      this.verifyTime,
      this.startDate,
      this.endDate,
      this.postTime,
      this.layouts,
      this.home,
      this.service,
      this.review,
      this.portfolio,
      this.blog,
      this.themes,
      this.colors,
      this.hit,
      this.about,
      this.skills,
      this.resume,
      this.appointment,
      this.contacts,
      this.btnStyle,
      this.teams,
      this.isDeactived,
      this.isRequest,
      this.shareLink,
      this.qrCode,
      this.dialCode,
      this.coverPhoto,
      this.whatsapp,
      this.vcardStatus,
      this.vcardLayouts,
      this.vcardBgColor,
      this.fullName,
      this.activeVcard,
      this.currencyCode,
      this.icon,
      this.quickActiveStatus,
      this.isAffiliate,
      this.isCardLinked,
      this.countryName,
      this.pushNotificationEnable,
      this.emailNotificationEnable,
      this.languageSelection,
      this.isProfileShareable,
      this.companyName,
      this.profileColor,
      this.displayDialCode,
      this.displayEmail,
      this.displayNumber,
      this.additionalAddress,
      this.setPassword,
      this.isPasswordEnable,
      this.offerCoin,
      this.primaryProfileSlug,
      this.primaryProfileLink,
      this.fcmToken,
      this.facebookId,
      this.googleId,
      this.appleId,
      this.shareUrl});

  Data.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    cardNumber = json['card_number'];
    cardNumberFix = json['card_number_fix'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    country = json['country'];
    gender = json['gender'];
    address = json['address'];
    isExpired = json['is_expired'];
    designation = json['designation'];
    website = json['website'];
    thumb = json['thumb'];
    userType = json['user_type'];
    isActive = json['is_active'];
    loginTime = json['login_time'];
    isVerify = json['is_verify'];
    isPayment = json['is_payment'];
    accountType = json['account_type'];
    referralCode = json['referral_code'];
    verifyTime = json['verify_time'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    postTime = json['post_time'];
    layouts = json['layouts'];
    home = json['home'];
    service = json['service'];
    review = json['review'];
    portfolio = json['portfolio'];
    blog = json['blog'];
    themes = json['themes'];
    colors = json['colors'];
    hit = json['hit'];
    about = json['about'];
    skills = json['skills'];
    resume = json['resume'];
    appointment = json['appointment'];
    contacts = json['contacts'];
    btnStyle = json['btn_style'];
    teams = json['teams'];
    isDeactived = json['is_deactived'];
    isRequest = json['is_request'];
    shareLink = json['share_link'];
    qrCode = json['qr_code'];
    dialCode = json['dial_code'];
    coverPhoto = json['cover_photo'];
    whatsapp = json['whatsapp'];
    vcardStatus = json['vcard_status'];
    vcardLayouts = json['vcard_layouts'];
    vcardBgColor = json['vcard_bg_color'];
    fullName = json['full_name'];
    activeVcard = json['active_vcard'];
    currencyCode = json['currency_code'];
    icon = json['icon'];
    quickActiveStatus = json['quick_active_status'];
    isAffiliate = json['is_affiliate'];
    isCardLinked = json['is_card_linked'];
    countryName = json['country_name'];
    pushNotificationEnable = json['push_notification_enable'];
    emailNotificationEnable = json['email_notification_enable'];
    languageSelection = json['language_selection'];
    isProfileShareable = json['is_profile_shareable'];
    companyName = json['company_name'];
    profileColor = json['profile_color'];
    displayDialCode = json['display_dial_code'];
    displayEmail = json['display_email'];
    displayNumber = json['display_number'];
    additionalAddress = json['additional_address'];
    setPassword = json['set_password'];
    isPasswordEnable = json['is_password_enable'];
    offerCoin = json['offer_coin'];
    primaryProfileSlug = json['primary_profile_slug'];
    primaryProfileLink = json['primary_profile_link'];
    fcmToken = json['fcm_token'];
    facebookId = json['facebook_id'];
    googleId = json['google_id'];
    appleId = json['apple_id'];
    shareUrl = json['share_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['card_number'] = this.cardNumber;
    data['card_number_fix'] = this.cardNumberFix;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['country'] = this.country;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['is_expired'] = this.isExpired;
    data['designation'] = this.designation;
    data['website'] = this.website;
    data['thumb'] = this.thumb;
    data['user_type'] = this.userType;
    data['is_active'] = this.isActive;
    data['login_time'] = this.loginTime;
    data['is_verify'] = this.isVerify;
    data['is_payment'] = this.isPayment;
    data['account_type'] = this.accountType;
    data['referral_code'] = this.referralCode;
    data['verify_time'] = this.verifyTime;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['post_time'] = this.postTime;
    data['layouts'] = this.layouts;
    data['home'] = this.home;
    data['service'] = this.service;
    data['review'] = this.review;
    data['portfolio'] = this.portfolio;
    data['blog'] = this.blog;
    data['themes'] = this.themes;
    data['colors'] = this.colors;
    data['hit'] = this.hit;
    data['about'] = this.about;
    data['skills'] = this.skills;
    data['resume'] = this.resume;
    data['appointment'] = this.appointment;
    data['contacts'] = this.contacts;
    data['btn_style'] = this.btnStyle;
    data['teams'] = this.teams;
    data['is_deactived'] = this.isDeactived;
    data['is_request'] = this.isRequest;
    data['share_link'] = this.shareLink;
    data['qr_code'] = this.qrCode;
    data['dial_code'] = this.dialCode;
    data['cover_photo'] = this.coverPhoto;
    data['whatsapp'] = this.whatsapp;
    data['vcard_status'] = this.vcardStatus;
    data['vcard_layouts'] = this.vcardLayouts;
    data['vcard_bg_color'] = this.vcardBgColor;
    data['full_name'] = this.fullName;
    data['active_vcard'] = this.activeVcard;
    data['currency_code'] = this.currencyCode;
    data['icon'] = this.icon;
    data['quick_active_status'] = this.quickActiveStatus;
    data['is_affiliate'] = this.isAffiliate;
    data['is_card_linked'] = this.isCardLinked;
    data['country_name'] = this.countryName;
    data['push_notification_enable'] = this.pushNotificationEnable;
    data['email_notification_enable'] = this.emailNotificationEnable;
    data['language_selection'] = this.languageSelection;
    data['is_profile_shareable'] = this.isProfileShareable;
    data['company_name'] = this.companyName;
    data['profile_color'] = this.profileColor;
    data['display_dial_code'] = this.displayDialCode;
    data['display_email'] = this.displayEmail;
    data['display_number'] = this.displayNumber;
    data['additional_address'] = this.additionalAddress;
    data['set_password'] = this.setPassword;
    data['is_password_enable'] = this.isPasswordEnable;
    data['offer_coin'] = this.offerCoin;
    data['primary_profile_slug'] = this.primaryProfileSlug;
    data['primary_profile_link'] = this.primaryProfileLink;
    data['fcm_token'] = this.fcmToken;
    data['facebook_id'] = this.facebookId;
    data['google_id'] = this.googleId;
    data['apple_id'] = this.appleId;
    data['share_url'] = this.shareUrl;
    return data;
  }
}