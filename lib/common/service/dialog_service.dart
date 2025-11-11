import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injectable/injectable.dart';
import 'package:ndialog/ndialog.dart';
import 'package:untitled/constants/custom_text_field.dart';


import '../../constants/app_styles.dart';
import '../../constants/colors_constant.dart';
import '../../constants/image_helper.dart';
import '../../constants/sizes.dart';
import '../../constants/strings.dart';
import '../../custom/app_progress_indicator.dart';
import '../../main.dart';
import '../locator/locator.dart';
import 'navigation_service.dart';
import 'package:untitled/localization/fitness_localization.dart';


@lazySingleton
class DialogService {


  ProgressDialog? _pr;
  CustomProgressDialog? _cpr;

  BuildContext _getSafeContext() {
    final ctx = NavigationServiceKey.navigatorKey.currentContext;
    if (ctx == null) {
      throw Exception('Navigator is not yet available — call after first frame.');
    }
    return ctx;
  }


  void successCustom({BuildContext? context , String? msg, String? title,required Function() onTap}){
    AwesomeDialog(
      btnOkColor: ColorConstant.primaryColor,
      context: context!,
      width: 400,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      body: Column(
        children: [
          Text(title??"",style: Theme.of(context).primaryTextTheme.displayLarge!.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),),
          const SizedBox(height: 10),
          Text(msg??"",style: Theme.of(context).primaryTextTheme.displayLarge!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400
          ),textAlign: TextAlign.center),
        ],
      ),
      btnOkOnPress: onTap,
    ).show();
  }
  //
  void backConfirmCustom({BuildContext? context , String? msg ,String? warning , VoidCallback? btnOkOnPress}){
    AwesomeDialog(
      context: context!,
      width: 400,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: warning,

      // desc: msg,
      body: Column(
        children: [
           Text(warning??"",style: Theme.of(context).primaryTextTheme.displayLarge!.copyWith(
            fontSize: 18,
             fontWeight: FontWeight.bold
          ),),
          const SizedBox(height: 10),
          Text(msg??"",style: Theme.of(context).primaryTextTheme.displayLarge!.copyWith(
              fontSize: 16,
            fontWeight: FontWeight.w400
          ),textAlign: TextAlign.center,),
        ],
      ),
      btnOkOnPress: btnOkOnPress,
      btnCancelOnPress: () {
      },
    ).show();
  }
  //
  // void customLogout({BuildContext? context , String? msg, Function? btnOkOnPress}){
  //   AwesomeDialog(
  //     btnOkColor: colorTextGrey,
  //     btnCancelColor: colorTextGrey,
  //     context: context!,
  //     width: 400,
  //     animType: AnimType.SCALE,
  //     dialogType: DialogType.NO_HEADER,
  //     body: Center(child: Text(
  //       msg!,style: Theme.of(context).primaryTextTheme.headline1!.copyWith(
  //         fontSize: 16,
  //         fontWeight: FontWeight.w400
  //     ),textAlign: TextAlign.center,),
  //     ),
  //     // title: 'This is Ignored',
  //     // desc:   'This is also Ignored',
  //     btnOkOnPress: btnOkOnPress,
  //     btnCancelOnPress: () {},
  //   ).show();
  // }
  //
  //
  void customError({BuildContext? context , String? msg, VoidCallback? btnOkOnPress}){
    AwesomeDialog(
      btnOkColor: Colors.grey,
      context: context!,
      width: 400,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      body: Center(child: Text(
          msg!,
        style: TextStyle(
          color: Theme.of(context).disabledColor,
        ),
        textAlign: TextAlign.center,),),
      // title: 'This is Ignored',
      // desc:   'This is also Ignored',
      btnOkOnPress: btnOkOnPress ?? (){},
    ).show();
  }

  void showLoader({String? message}) {
    // hide loader if shown previously
    hideLoader();
    if (message == null) {
      _cpr = CustomProgressDialog(
        _getSafeContext(),
        loadingWidget: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
            shape: BoxShape.rectangle,
          ),
          child: AppProgressIndicator()
        ),
        dismissable: false
      );
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _cpr!.show();
      });
    } else {
      _pr = ProgressDialog(_getSafeContext(),
        title: null,
        dialogStyle: DialogStyle(
          borderRadius: BorderRadius.circular(10.0),
          backgroundColor: Colors.white,
          elevation: 10.0,
        ),
        defaultLoadingWidget: AppProgressIndicator(),
        message: Text(message),
        dismissable: false
      );
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _pr!.show();
      });
    }
  }


  void hideLoader() {
    if (_pr?.isShowed ?? false) {
      _pr?.dismiss();
    }
    if (_cpr?.isShowed ?? false) {
      _cpr?.dismiss();
    }
  }

  showDataAlert() {
    showDialog(
        barrierDismissible: false,
        context: _getSafeContext(),
        builder: (context) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AlertDialog(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        20.0,
                      ),
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  title: const Icon(Icons.error_outline),
                  content: Column(
                    children: [
                       Text(
                        GuardLocalizations.of(context)!.translate("noInternetFound") ?? "",
                        style: const TextStyle(fontSize: 24.0),
                      ),
                       Text(
                        GuardLocalizations.of(context)!.translate("checkYourConnectionOrTryAgain") ?? "",
                        style: const TextStyle(fontSize: 15.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextButton(onPressed: () {
                          NavigationServiceKey.navigatorKey.currentContext!.pop();
                        },
                          style: TextButton.styleFrom(
                              backgroundColor:
                              ColorConstant.primaryColor),
                          child: Text(
                            GuardLocalizations.of(context)!.translate("ok") ?? "",
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.whiteColor),
                          ),),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  showEmailVerify() {
    showDialog(
        context: _getSafeContext(),
        builder: (context) {
          return Center(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AlertDialog(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          20.0,
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    title:Image.asset(ImageHelper.imgEmailVerify,height: 100,width: 100),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                           Text(
                            GuardLocalizations.of(context)!.translate("emailVerificationRequired") ?? "",
                            textAlign: TextAlign.center,
                            style: MyTextStyleBase.headingStyle.copyWith(
                              fontSize: textSize20
                            )
                          ),
                           Text(
                            textAlign: TextAlign.center,
                            GuardLocalizations.of(context)!.translate("pleaseCheckYouInboxAndVerifyRegisteredEmailAddress") ?? "",
                            style: MyTextStyleBase.headingStyleLight.copyWith(
                              fontSize: textSize14
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showLogoutDialog(
      {String? image,
      String? title,
      String? subTitle,
      Color? color,
      void Function()? positiveTap,
      void Function()? negativeTap,
      String? negativeButtonText,
      String? positiveButtonText}) {
    showDialog(
        context: _getSafeContext(),
        builder: (context) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AlertDialog(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        20.0,
                      ),
                    ),
                  ),
                  titlePadding: const EdgeInsets.only(top: 12, left: 24, right: 24),
                  contentPadding: const EdgeInsets.only(top: 12, left: 24, bottom: 20,right: 24),
                  insetPadding: const EdgeInsets.symmetric(horizontal: 15),
                  title:image==null? SizedBox():Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(image??"",height: 100,width: 100),
                  ),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                            title??"",
                            textAlign: TextAlign.center,
                            style: MyTextStyleBase.headingStyle.copyWith(
                                fontSize: textSize20
                            )
                        ),
                        Text(
                            subTitle??"",
                            textAlign: TextAlign.center,
                            style: MyTextStyleBase.headingStyleLight.copyWith(
                                fontSize: textSize14,
                              color: color
                            )
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(child: InkWell(
                                onTap: positiveTap,
                                child: Container(
                                  height: 40,
                                  // padding: EdgeInsets.symmetric(horizontal: 50.w),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: ColorConstant.primaryColor, borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    // GuardLocalizations.of(context)!.translate("save") ?? "",
                                    positiveButtonText??"",
                                    style: GoogleFonts.jost(
                                        color: ColorConstant.whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              )),
                              const SizedBox(width: 10,),
                              Expanded(child: InkWell(
                                onTap: negativeTap,
                                child: Container(
                                  height: 40,
                                  // padding: EdgeInsets.symmetric(horizontal: 50.w),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorConstant.primaryColor),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    // GuardLocalizations.of(context)!.translate("save") ?? "",
                                    negativeButtonText??"",
                                    style: GoogleFonts.jost(
                                        color: ColorConstant.primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  showDeleteDialog(
      {String? image,
      String? title,
      String? subTitle,
      Color? color,
      void Function()? positiveTap,
      void Function()? negativeTap,
      String? negativeButtonText,
      TextEditingController? detailController,
      String? positiveButtonText}) {
    showDialog(
        context: _getSafeContext(),
        builder: (context) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AlertDialog(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        20.0,
                      ),
                    ),
                  ),
                  titlePadding: const EdgeInsets.only(top: 12, left: 24, right: 24),
                  contentPadding: const EdgeInsets.only(top: 12, left: 24, bottom: 20,right: 24),
                  insetPadding: const EdgeInsets.symmetric(horizontal: 15),
                  title:image==null? SizedBox():Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(image??"",height: 100,width: 100),
                  ),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                            title??"",
                            textAlign: TextAlign.center,
                            style: MyTextStyleBase.headingStyle.copyWith(
                                fontSize: textSize20
                            )
                        ),
                        Text(
                            subTitle??"",
                            textAlign: TextAlign.center,
                            style: MyTextStyleBase.headingStyleLight.copyWith(
                                fontSize: textSize14,
                              color: color
                            )
                        ),

                        CommonTextFieldWidget(
                          maxLines: 2,
                          // validator: (v){
                          //   return Validations.commonValidation(v,GuardLocalizations.of(context)!.translate("enterIncidentDetails") ?? "");
                          // },
                          hintText: GuardLocalizations.of(context)!.translate("enterDetails") ?? "",
                          isPassword: false, textController: detailController!,

                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(child: InkWell(
                                onTap: positiveTap,
                                child: Container(
                                  height: 40,
                                  // padding: EdgeInsets.symmetric(horizontal: 50.w),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: ColorConstant.primaryColor, borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    // GuardLocalizations.of(context)!.translate("save") ?? "",
                                    positiveButtonText??"",
                                    style: GoogleFonts.jost(
                                        color: ColorConstant.whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              )),
                              const SizedBox(width: 10,),
                              if(negativeTap!=null)
                              Expanded(child: InkWell(
                                onTap: negativeTap,
                                child: Container(
                                  height: 40,
                                  // padding: EdgeInsets.symmetric(horizontal: 50.w),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorConstant.primaryColor),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    // GuardLocalizations.of(context)!.translate("save") ?? "",
                                    negativeButtonText??"",
                                    style: GoogleFonts.jost(
                                        color: ColorConstant.primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  showCommonDialog(BuildContext context,Widget child){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: child,
          );
        });
  }

}
