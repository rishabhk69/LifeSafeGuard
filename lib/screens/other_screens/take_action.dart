import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider, BlocListener;
import 'package:go_router/go_router.dart';
import 'package:untitled/bloc/dashboard_bloc.dart';
import 'package:untitled/bloc/spam_incident_bloc.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/app_utils.dart';
import 'package:untitled/constants/colors_constant.dart';
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
            BlocListener<SpamIncidentBloc,SpamIncidentState>(
            listener: (context,spamStates){
              if(spamStates is SpamIncidentLoadingState){
                locator<DialogService>().showLoader();
              }
              else if(spamStates is SpamIncidentSuccessState){
                locator<DialogService>().hideLoader();
                context.pop();
                locator<ToastService>().show(spamStates.spamIncidentData.message??"");
                context.go('/dashboardScreen');
                BlocProvider.of<DashboardBloc>(context).add(DashboardRefreshEvent(0));
              }
              else if(spamStates is SpamIncidentErrorState){
                locator<DialogService>().hideLoader();
                locator<ToastService>().show(spamStates.errorMsg??"");
              }
            },child:  Card(
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
                  locator<DialogService>().showLogoutDialog(
                      title: 'Confirm ?',
                      subTitle: 'Are you sure you want to spam this incident?',
                      negativeButtonText: GuardLocalizations.of(context)!.translate("no") ?? "",
                      positiveButtonText: GuardLocalizations.of(context)!.translate("yes") ?? "",
                      negativeTap: () {
                        context.pop();
                      },
                      positiveTap: () {
                        context.pop();
                        AppUtils().getUserId().then((userId) {
                          BlocProvider.of<SpamIncidentBloc>(context).add(
                              SpamIncidentRefreshEvent(
                                  incidentId: widget.incidentData
                                      ?.incidentId ?? "",
                                  userId: userId.toString())
                          );
                        });
                      }
                  );
                  // context.push('/spamScreen',extra: widget.incidentData);
                  // Handle spam incident action
                },
              ),
            ),),
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
