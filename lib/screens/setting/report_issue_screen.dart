import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/custom_text_field.dart';
import 'package:untitled/constants/strings.dart';

class ReportIssueScreen extends StatelessWidget {
  const ReportIssueScreen({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController titleController = TextEditingController();
    TextEditingController detailController = TextEditingController();

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
          title:  Text(
            StringHelper.reportAnIssue,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title field
               Text(StringHelper.addTitle,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              CommonTextFieldWidget(
                hintText: StringHelper.enterTitle,
                isPassword: false,
                textController: titleController,
              ),

              const SizedBox(height: 16),

              // Details field
               Text(StringHelper.details,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),

              CommonTextFieldWidget(
                hintText: StringHelper.whyAreYouBlockTheIncident,
                isPassword: false,
                textController: detailController,
              ),

              const SizedBox(height: 16),

              // Attachments
              const Text("Attachments",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Click to upload",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // File List
              Expanded(
                child: ListView(
                  children: [
                    _buildFileTile("xyz.pdf"),
                    _buildFileTile("xyz.pdf"),
                  ],
                ),
              ),

              // Submit button
              CustomButton(text: StringHelper.submit, onTap: null)
            ],
          ),
        ),
      ),
    );
  }

  // File item widget
  Widget _buildFileTile(String filename) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(filename,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete, color: Colors.red),
          )
        ],
      ),
    );
  }
}