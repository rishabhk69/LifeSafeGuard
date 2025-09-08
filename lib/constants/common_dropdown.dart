import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:untitled/constants/sizes.dart';

import 'colors_constant.dart';

class CommonDropdown extends StatefulWidget {
  List<String>? items;
  String? selectedValue;
  String? hintText;


  CommonDropdown({this.items, this.selectedValue, this.hintText});

  @override
  State<CommonDropdown> createState() => _CommonDropdownState();
}

class _CommonDropdownState extends State<CommonDropdown> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.only(top: 10),
      // color: Colors.red,
      width: double.infinity,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          buttonStyleData:ButtonStyleData(
            height: 45,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: ColorConstant.primaryColor,
              ),
              color: Colors.transparent,
            ),
            // elevation: 2,
          ),
          isExpanded: true,
          hint: Text(
            widget.hintText??"",
            style: TextStyle(
              color: Colors.black26,
              fontSize: 15,
            ),
          ),
          items: widget.items!
              .map(
                (String item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: ColorConstant.textFiledColor,
                  fontWeight: FontWeight.w500,
                  fontSize: textSize16,
                ),
              ),
            ),
          )
              .toList(),
          value: widget.selectedValue,
          onChanged: (String? value) {
            setState(() {
              widget.selectedValue = value;
            });
          },
          menuItemStyleData: const MenuItemStyleData(height: 40),
        ),
      ),
    );
  }
}
