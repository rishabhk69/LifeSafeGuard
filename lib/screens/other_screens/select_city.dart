import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:untitled/constants/strings.dart';
import 'package:untitled/localization/fitness_localization.dart';


class SelectCity extends StatefulWidget {
  const SelectCity({super.key});

  @override
  State<SelectCity> createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> {

  final List<String> cities = [
    "Mumbai",
    "Surat",
    "Goa",
    "Delhi",
    "Bangalore",
    "Flood",
    "Hyderabad",
    "Chennai",
    "Kolkata",
  ];

  String selectedCity = "Mumbai";
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {

    final filteredCities = cities
        .where((city) => city.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return SafeArea(
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
            GuardLocalizations.of(context)!.translate("selectCity") ?? "",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Search Field
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: GuardLocalizations.of(context)!.translate("searchCity") ?? "",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),

              addHeight(10),

              // List of Cities
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCities.length,
                  itemBuilder: (context, index) {
                    final city = filteredCities[index];
                    final isSelected = selectedCity == city;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCity = city;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        margin: EdgeInsets.symmetric( vertical: 4),
                        decoration: BoxDecoration(
                          color:Color(0xffFBFBFB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              city,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? Colors.orange : Colors.black,
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check, color: Colors.orange, size: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              CustomButton(text: GuardLocalizations.of(context)!.translate("select") ?? "", onTap: (){})
            ],
          ),
        ),
      ),
    );
  }
}
