import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/custom_text_field.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/strings.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {

  TextEditingController fullNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController helpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorConstant.whiteColor,
        appBar: AppBar(
          leading: InkWell(
              onTap: (){
                context.pop();
              },
              child: const Icon(Icons.arrow_back, color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Contact Us",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Illustration
              SvgPicture.asset(
                ImageHelper.contactUs,
                height: 180,
              ),

              const SizedBox(height: 12),
              const Text(
                "Get in Touch",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "If you have any inquiries get in touch with us.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),

              const SizedBox(height: 20),

              // Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  value: "Business Query",
                  items: const [
                    DropdownMenuItem(
                        value: "Business Query", child: Text("Business Query")),
                    DropdownMenuItem(
                        value: "Technical Support",
                        child: Text("Technical Support")),
                    DropdownMenuItem(
                        value: "General Inquiry", child: Text("General Inquiry")),
                  ],
                  onChanged: (value) {},
                ),
              ),


              CommonTextFieldWidget(
                  isPassword: false,
                  prefix:SvgPicture.asset(
                    ImageHelper.profileIc,
                    fit: BoxFit.scaleDown,
                    height: 20,
                    width: 20,
                  ),
                  hintText: StringHelper.fullName,
                  textController: fullNameController),
              CommonTextFieldWidget(
                  isPassword: false,
                  prefix: SvgPicture.asset(ImageHelper.callIc,
                    fit: BoxFit.scaleDown,
                    height: 20,
                    width: 20,),
                  hintText: StringHelper.phoneNumber,
                  textController: numberController),
              CommonTextFieldWidget(
                  prefix: SvgPicture.asset(ImageHelper.smsIc,
                    fit: BoxFit.scaleDown,
                    height: 20,
                    width: 20,),
                  isPassword: false,
                  hintText: StringHelper.emailAddress,
                  textController: emailController),
              CommonTextFieldWidget(
                  isPassword: false,
                  hintText: StringHelper.howCanWeHelp,
                  textController: helpController),

              const SizedBox(height: 20),

              // Submit Button
              CustomButton(text: StringHelper.submit, onTap: (){})
            ],
          ),
        ),
      ),
    );
  }

  // Reusable text field widget
  Widget _buildTextField({
    required String hint,
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ContactUsScreen(),
  ));
}
