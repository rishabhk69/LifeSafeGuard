import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/sizes.dart';

import 'colors_constant.dart';
import 'image_helper.dart';

class CommonTextFieldWidget extends StatefulWidget {
  const CommonTextFieldWidget(
      {this.titleText = '',
        this.titleTextAlign = TextAlign.center,
        this.suffix,
        this.onTap,
        this.onChanged,
        this.infoTap,
        this.formKey,
        this.focusNode,
        this.keyboardType,
        this.onFieldSubmitted,
        this.prefix,
        this.maxLength,
        this.validator,
        this.maxLines,
        this.hintStyle,
        this.inputFormatters,
        this.isRequired = false,
        this.enable = true,
        required this.isPassword,
        required this.hintText,
        required this.textController});

  final String titleText;
  final TextAlign titleTextAlign;
  final bool isPassword;
  final int? maxLines;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final bool enable;
  final Function(String)? onFieldSubmitted;
  final bool isRequired;
  final TextInputType? keyboardType;
  final String hintText;
  final void Function()? onTap;
  final void Function()? infoTap;
  final Widget? suffix;
  final Widget? prefix;
  final Key? formKey;
  final int? maxLength;
  final String? Function(String?)? validator;
  final TextEditingController textController;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? hintStyle;

  @override
  _CommonTextFieldWidgetState createState() =>
      _CommonTextFieldWidgetState();
}

class _CommonTextFieldWidgetState extends State<CommonTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Expanded(
        //       child: RichText(
        //           text: TextSpan(
        //               text: /*widget.titleText*/'',
        //               style:GoogleFonts.jost(
        //                   color: ColorConstant.blackLightColor,
        //                   fontSize: 14,
        //                   fontWeight: FontWeight.w400
        //               ),
        //               children: [
        //                 widget.isRequired ?
        //                 const TextSpan(
        //                   text: '*',
        //                   style: TextStyle(color: Colors.red),
        //                 ):const TextSpan(
        //                   text: '',
        //                   style: TextStyle(color: Colors.red),
        //                 ),
        //               ])),
        //     ),
        //     widget.infoTap ==null? SizedBox():const Spacer(),
        //     // widget.infoTap ==null ? SizedBox():InkWell(
        //     //   onTap: widget.infoTap,
        //     //     child: Image.asset(ImageHelper.icQuestionmark,height: textSize20,width: textSize20,))
        //   ],
        // ),
        SizedBox(height: 10,),
        TextFormField(
          enableInteractiveSelection :false,
          focusNode: widget.focusNode,
          autofocus: false,
          inputFormatters: widget.inputFormatters ?? (widget.keyboardType== TextInputType.phone? <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9]"))
          ]: null),
          // minLines: 1,
          key: widget.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: widget.maxLines??1,
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength??200,
          controller: widget.textController,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          enabled: widget.enable,
          cursorColor: ColorConstant.primaryColor,
          obscureText: widget.isPassword,
          validator: widget.validator,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
            filled: true, // ✅ enable background color
            fillColor: Color(0xffFBFBFB), // ✅ light grey background
            border: InputBorder.none,
            // labelText: widget.hintText,
            errorStyle: TextStyle(
              color: Theme.of(context).colorScheme.error, // or any other color
            ),
            isDense: true,
            // filled: true,
            counterText: '',
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: const EdgeInsets.all(10.0),
            hintText: widget.hintText, // pass the hint text parameter here
            hintStyle: widget.hintStyle?? const TextStyle(color: Colors.black26,fontSize: 15),
            suffixIcon: widget.suffix,
            prefixIcon: widget.prefix,
          ),
          style: GoogleFonts.poppins(color: ColorConstant.textFiledColor,
              fontWeight: FontWeight.w500,
              fontSize: textSize20),
        ),
      ],
    );
  }
}
