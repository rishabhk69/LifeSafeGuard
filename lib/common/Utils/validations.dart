class Validations {
  static String? commonValidation(String? val,String type) {
    if (val == null || val.trim().isEmpty) {
      return "Enter $type";
    } else {
      return null;
    }
  }
  static String? phoneValidation(String? val,String type) {
    if (val == null || val.trim().isEmpty) {
      return "Enter $type";
    }
    else if (val .length<10) {
      return "Please enter valid phone number";
    } else {
      return null;
    }
  }

  static String? validEmailValidation(String? value) {
    if (value!.isNotEmpty) {
      bool result = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value);
      if (!result) {
        return 'Please enter valid url!';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static String? websiteValidation(String? value) {
    if (value!.isNotEmpty) {
      bool result = RegExp(
              r'(http|https|www)(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?')
          .hasMatch(value);
      if (!result) {
        return 'Please enter valid url!';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static String? passwordValidateStructure(String value){
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    bool result = regExp.hasMatch(value);
    if (!result) {
      return 'Please enter valid url!';
    } else {
      return null;
    }
  }

}
