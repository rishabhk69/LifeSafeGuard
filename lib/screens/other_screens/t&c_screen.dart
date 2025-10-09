import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/bloc/auth/aggrement_bloc.dart';
import 'package:untitled/common/service/common_builder_dialog.dart';
import 'package:untitled/constants/common_background.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:untitled/constants/strings.dart';

class TermsAndCondition extends StatefulWidget {

  dynamic isLogin;
  TermsAndCondition(this.isLogin);

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AgreementBloc>(
      context,
      listen: false,
    ).add(AgreementRefreshEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        bottomSheet: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              // Expanded(
              //   child: CustomButton(
              //       buttonColor: Colors.grey,
              //       buttonHeight: 50,
              //       text: StringHelper.decline, onTap: (){
              //     context.pop();
              //   }),
              // ),
              // addWidth(5),
              Expanded(
                child: CustomButton(
                  buttonHeight: 50,
                  text: StringHelper.accept,
                  onTap: () {
                    context.push('/signupScreen');
                  },
                ),
              ),
            ],
          ),
        ),
        body: CommonBackground(
          iconName: ImageHelper.aggrementIc,
          title: StringHelper.agreement,
          showBack: true,
          child: BlocBuilder<AgreementBloc, AgreementState>(
            builder: (context, agreementState) {
              if (agreementState is AgreementLoadingState) {
                return BuilderDialog();
              } else if (agreementState is AgreementSuccessState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      addHeight(50),
                      Html(
                        data: agreementState.agreementModel.toString(),
                        extensions: [
                          TagExtension(
                            tagsToExtend: {"flutter"},
                            child: const FlutterLogo(),
                          ),
                        ],
                        style: {
                          "p.fancy": Style(
                            textAlign: TextAlign.center,
                            // padding:  EdgeInsets.all(16),
                            backgroundColor: Colors.grey,
                            margin: Margins(
                              left: Margin(50, Unit.px),
                              right: Margin.auto(),
                            ),
                            width: Width(300, Unit.px),
                            fontWeight: FontWeight.bold,
                          ),
                        },
                      ),
                      Text(agreementState.agreementModel.toString()),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              buttonColor: Colors.grey,
                              buttonHeight: 50,
                              text: StringHelper.decline,
                              onTap: () {
                                context.pop();
                              },
                            ),
                          ),
                          addWidth(5),
                          Expanded(
                            child: CustomButton(
                              buttonHeight: 50,
                              text: StringHelper.accept,
                              onTap: () {
                                if(widget.isLogin=='true'){
                                  context.push('/signupScreen');
                                }
                                else {
                                  context.pop();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else if (agreementState is AgreementErrorState) {}
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
