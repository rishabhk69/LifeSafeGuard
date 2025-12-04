import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/bloc/instruction_bloc.dart';
import 'package:untitled/common/service/common_builder_dialog.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:untitled/localization/fitness_localization.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({super.key});

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorConstant.scaffoldColor,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              context.pop();
            },
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            GuardLocalizations.of(context)!.translate("instructions") ?? "",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        body: BlocBuilder<InstructionBloc, InstructionState>(
          builder: (context, instructionState) {
            if (instructionState is InstructionLoadingState) {
              return BuilderDialog();
            } else if (instructionState is InstructionSuccessState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    addHeight(50),
                    Html(
                      data: instructionState.dynamicResponse['instructions'].toString(),
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
                    addHeight(60),
                  ],
                ),
              );
            } else if (instructionState is InstructionErrorState) {
              return Center(child: Text(instructionState.errorMsg));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
