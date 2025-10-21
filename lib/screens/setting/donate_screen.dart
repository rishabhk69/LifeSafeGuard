import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/strings.dart';
import 'package:untitled/localization/fitness_localization.dart';


class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {

  int? selectedAmount = 50;
  String? selectedMethod;

  final List<int> amounts = [10, 50, 100, 500];



  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> paymentMethods = [
      {"name": GuardLocalizations.of(context)!.translate("uPI") ?? "", "icon": ImageHelper.upiIc},
      {"name": GuardLocalizations.of(context)!.translate("payPal") ?? "", "icon": ImageHelper.paypalIc},
      {"name": GuardLocalizations.of(context)!.translate("paymentMethod") ?? "", "icon": ImageHelper.upiIc},
    ];
    final method = paymentMethods[0];
    final isSelected = selectedMethod == method["name"];

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorConstant.scaffoldColor,
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              context.pop();
            },
            child: const Icon(Icons.arrow_back, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          GuardLocalizations.of(context)!.translate("donateNow") ?? "",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
        body:  Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preset Amounts
              GridView.builder(
                shrinkWrap: true,
                itemCount: amounts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final amount = amounts[index];
                  final isSelected = selectedAmount == amount;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAmount = amount;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: isSelected ? Colors.orange : Colors.grey),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "₹ $amount",
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Enter manually
              TextField(
                decoration: InputDecoration(
                  hintText: GuardLocalizations.of(context)!.translate("enterManually") ?? "",
                  hintStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    selectedAmount = int.tryParse(value);
                  });
                },
              ),

              const SizedBox(height: 20),

              // Payment Method
              Text(
                GuardLocalizations.of(context)!.translate("paymentMethod") ?? "",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),


              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: paymentMethods.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final method = paymentMethods[index];
                    final isSelected = selectedMethod == method["name"];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMethod = method["name"];
                        });
                      },
                      child: Container(
                        width: 90,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.orange : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(method["icon"],height: 30),
                            const SizedBox(height: 6),
                            Text(
                              method["name"],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),

              CustomButton(text: GuardLocalizations.of(context)!.translate("donateNow") ?? "", onTap: (){})
            ],
          ),
        ),
      ),
    );
  }
}
