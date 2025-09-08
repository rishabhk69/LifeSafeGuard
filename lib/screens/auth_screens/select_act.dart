import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/constants/base_appbar.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:untitled/constants/strings.dart';

import '../../constants/logo_widget.dart';

class SelectAct extends StatefulWidget {
  const SelectAct({super.key});

  @override
  State<SelectAct> createState() => _SelectActState();
}

class _SelectActState extends State<SelectAct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.scaffoldColor,
      appBar: BaseAppBar(
        hideBack: false,
        title: StringHelper.welcomeUser,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LogoWidget(),
            addHeight(50.h),
            TextButton(onPressed: (){}, child: Text('	The Shops and Commercial Establishment Act, 1958 ')),
            TextButton(onPressed: (){}, child: Text('	Under The Building and Other Construction Workers (RE&CS)Act, 1996')),
            TextButton(onPressed: (){}, child: Text('	The Contract Labour (Regulation and Abolition) Act, 1970 ')),
            TextButton(onPressed: (){}, child: Text('	The Beedi and Cigar Workers (Conditions of Employment) Act, 1966')),
            TextButton(onPressed: (){}, child: Text('	The Trade Unions Act, 1926')),
            TextButton(onPressed: (){}, child: Text('	The Motor Transport Workers Act, 1961')),
            TextButton(onPressed: (){}, child: Text('	The Inter- State Migrant Workmen (RE&CS) Act, 1979')),
            CustomButton(text: StringHelper.submit, onTap: (){
            }),
          ],
        ),
      ),
    );
  }
}
