import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/strings.dart';
import 'package:untitled/localization/fitness_localization.dart';


class TakeAction extends StatefulWidget {
  dynamic incidentData;
  TakeAction(this.incidentData);

  @override
  State<TakeAction> createState() => _TakeActionState();
}

class _TakeActionState extends State<TakeAction> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.scaffoldColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text(
          GuardLocalizations.of(context)!.translate("takeAction") ?? "",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Block Incident
            Card(
              elevation: 0,
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title:  Text(
                  GuardLocalizations.of(context)!.translate("blockedIncidents") ?? "",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                 context.push('/reportIssueScreen',extra: widget.incidentData);
                },
              ),
            ),

             SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                "Notes: If you block these incidents, they will be removed from the app.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),

            // Spam Incident
            Card(
              elevation: 0,
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(
                  GuardLocalizations.of(context)!.translate("spamIncident") ?? "",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Handle spam incident action
                },
              ),
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                "Notes: If you Spam these incidents, they will be removed from the app.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
