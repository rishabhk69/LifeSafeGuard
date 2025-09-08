import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/strings.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
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
            StringHelper.filter,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildListTile(StringHelper.selectCity, "Mumbai", true,(){
                context.push('/selectCity');
              }),
              _buildListTile(StringHelper.typeOfIncidents, "Bom Blast", true,(){
                context.push('/incidentTypeScreen');
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle, bool showArrow,void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color:CupertinoColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (subtitle.isNotEmpty)
                Text(subtitle, style: GoogleFonts.poppins(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400)),
              if (showArrow) const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
