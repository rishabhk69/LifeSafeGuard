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
                  hintText: GuardLocalizations.of(context)!.translate(
                      "searchCity") ?? "",
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

              BlocBuilder<CityListBloc, CityListState>(
                  builder: (context, cityState) {
                    if (cityState is CityListLoadingState) {
                      return BuilderDialog();
                    }
                    else if (cityState is CityListSuccessState) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: cityState.cityListModel.cities?.length,
                          itemBuilder: (context, index) {
                            // final city = cityState.cityListModel[index];
                            return GestureDetector(
                              onTap: () {
                                BlocProvider.of<SaveCityBloc>(
                                    context, listen: false).add(
                                    SaveCityRefreshEvent(cityState.cityListModel
                                        .cities![index]));
                                // setState(() {
                                //   selectedCity = city;
                                // });
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Color(0xffFBFBFB),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: BlocBuilder<SaveCityBloc,
                                      SaveCityState>(
                                      builder: (context, saveState) {
                                        if (saveState is SaveCitySuccessState) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                cityState.cityListModel
                                                    .cities![index].city ?? "",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: saveState.selectedCity
                                                      ?.city ==
                                                      cityState.cityListModel
                                                          .cities![index].city
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  color: saveState.selectedCity
                                                      ?.city ==
                                                      cityState.cityListModel
                                                          .cities![index].city
                                                      ? Colors.orange
                                                      : Colors.black,
                                                ),
                                              ),
                                              if (saveState.selectedCity
                                                  ?.city ==
                                                  cityState.cityListModel
                                                      .cities![index].city)
                                                Icon(Icons.check,
                                                    color: Colors.orange,
                                                    size: 20),
                                            ],
                                          );
                                        }
                                        else {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                cityState.cityListModel
                                                    .cities![index].city ?? "",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: BlocProvider
                                                      .of<SaveCityBloc>(
                                                      context, listen: false)
                                                      .selectedCity
                                                      ?.city ==
                                                      cityState.cityListModel
                                                          .cities![index].city
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  color: BlocProvider
                                                      .of<SaveCityBloc>(
                                                      context, listen: false)
                                                      .selectedCity
                                                      ?.city ==
                                                      cityState.cityListModel
                                                          .cities![index].city
                                                      ? Colors.orange
                                                      : Colors.black,
                                                ),
                                              ),
                                              if (BlocProvider
                                                  .of<SaveCityBloc>(context)
                                                  .selectedCity
                                                  ?.city ==
                                                  cityState.cityListModel
                                                      .cities![index].city)
                                                Icon(Icons.check,
                                                    color: Colors.orange,
                                                    size: 20),
                                            ],
                                          );
                                        }
                                      })
                              ),
                            );
                          },
                        ),
                      );
                    }
                    else if (cityState is CityListErrorState) {
                      return Center(
                        child: Text(cityState.errorMsg),
                      );
                    }
                    return Container();
                  }),

              CustomButton(
                  text: GuardLocalizations.of(context)!.translate("select") ??
                      "", onTap: () {
                    context.pop();
              })
            ],
          ),
        ),
      ),
    );
  }
}
