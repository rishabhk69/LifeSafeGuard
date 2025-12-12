import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/bloc/get_city_bloc.dart';
import 'package:untitled/bloc/save_city_bloc.dart';
import 'package:untitled/common/service/common_builder_dialog.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:untitled/localization/fitness_localization.dart';

class SelectCity extends StatefulWidget {
  const SelectCity({super.key});

  @override
  State<SelectCity> createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
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
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // 🔍 Search Field
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: GuardLocalizations.of(context)!.translate("searchCity") ?? "Search city",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim().toLowerCase();
                  });
                },
              ),

              addHeight(10),

              // 🏙 City List Bloc
              BlocBuilder<CityListBloc, CityListState>(
                builder: (context, cityState) {
                  if (cityState is CityListLoadingState) {
                    return const BuilderDialog();
                  } else if (cityState is CityListSuccessState) {
                    // 🔎 Filter cities based on searchQuery
                    final filteredCities = cityState.cityListModel.cities!
                        .where((city) {
                      final cityName = city.city?.toLowerCase() ?? "";
                      final stateName = city.state?.toLowerCase() ?? "";
                      return cityName.contains(searchQuery) || stateName.contains(searchQuery);
                    })
                        .toList();

                    if (filteredCities.isEmpty) {
                      return const Expanded(
                        child: Center(
                          child: Text(
                            "No matching cities found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: filteredCities.length,
                        itemBuilder: (context, index) {
                          final currentCity = filteredCities[index];

                          return GestureDetector(
                            onTap: () {
                              BlocProvider.of<SaveCityBloc>(context, listen: false)
                                  .add(SaveCityRefreshEvent(currentCity));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xffFBFBFB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: BlocBuilder<SaveCityBloc, SaveCityState>(
                                builder: (context, saveState) {
                                  final selectedCity =
                                  (saveState is SaveCitySuccessState)
                                      ? saveState.selectedCity
                                      : BlocProvider.of<SaveCityBloc>(context, listen: false)
                                      .selectedCity;

                                  final isSelected =
                                      selectedCity?.city == currentCity.city;

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${currentCity.city ?? ""}, ${currentCity.state ?? ""}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: isSelected
                                                ? Colors.orange
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(Icons.check,
                                            color: Colors.orange, size: 20),
                                    ],
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (cityState is CityListErrorState) {
                    return Center(
                      child: Text(cityState.errorMsg),
                    );
                  }
                  return Container();
                },
              ),

              // ✅ Select Button
              CustomButton(
                text: GuardLocalizations.of(context)!.translate("select") ?? "Select",
                onTap: () {
                  context.pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
