import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/bloc/get_incident_type_bloc.dart';
import 'package:untitled/bloc/setincident_bloc.dart';
import 'package:untitled/common/locator/locator.dart';
import 'package:untitled/common/service/common_builder_dialog.dart';
import 'package:untitled/common/service/dialog_service.dart';
import 'package:untitled/common/service/toast_service.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:untitled/localization/fitness_localization.dart';


class IncidentTypeScreen extends StatefulWidget {
  const IncidentTypeScreen({super.key});

  @override
  State<IncidentTypeScreen> createState() => _IncidentTypeScreenState();
}

class _IncidentTypeScreenState extends State<IncidentTypeScreen> {


  TextEditingController detailController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
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
            GuardLocalizations.of(context)!.translate("typeOfIncident") ?? "",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<IncidentTypeBloc,IncidentTypeState>(
          builder: (context,incidentTypeState){
          if(incidentTypeState is IncidentTypeLoadingState){
            return BuilderDialog();
          }
          else if(incidentTypeState is IncidentTypeSuccessState){
            return SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:BlocBuilder<SetIncidentsBloc,SetIncidentsState>(
                      builder: (context,incidentState){
                        if(incidentState is SetIncidentsSuccessState){
                          return  Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: incidentTypeState.incidentTypeModel.icons?.length,
                                itemBuilder: (context,index){
                                return _buildListTile(incidentTypeState.incidentTypeModel.icons?[index].incidentType??"",
                                    '',
                                    incidentTypeState.incidentTypeModel.icons?[index].imageURL??"",
                                    (incidentTypeState.incidentTypeModel.icons?[index].incidentType??"")==incidentState.selectedIncidentName,(){
                                  if((incidentTypeState.incidentTypeModel.icons?[index].incidentType??"").toLowerCase() == 'others'){
                                    locator<DialogService>().showDeleteDialog(
                                        detailController: detailController,
                                        title: 'Please describe the incident',
                                        positiveButtonText: GuardLocalizations.of(context)!.translate("done") ?? "",
                                        positiveTap: () async {
                                          if(detailController.text.isEmpty){
                                            locator<ToastService> ().show(GuardLocalizations.of(context)!.translate("enterDetails") ?? "");
                                          }
                                          else{
                                            BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(
                                                incidentName: 'Others - ${detailController.text.trim()}'));
                                            context.pop();
                                            context.pop();
                                          }
                                        }
                                    );
                                  }
                                  else{
                                    BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(
                                        incidentName:incidentTypeState.incidentTypeModel.icons?[index].incidentType??""));
                                  }
                                    });
                              }),
                              CustomButton(text: GuardLocalizations.of(context)!.translate("select") ?? "", onTap: (){
                                context.pop();
                              })
                            ],
                          );
                        }
                        return Container();
                      })
              ),
            );
          }
          else if(incidentTypeState is IncidentTypeErrorState){
            return Center(child: Text(incidentTypeState.errorMsg));
          }
          return SizedBox();
        })
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle,String assetName, bool showSelected,void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(5)
        ),
        child: ListTile(
          title: Row(
            children: [
              SizedBox(width: 25,height:25,child: SvgPicture.network(assetName)),
              addWidth(5),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (subtitle.isNotEmpty)
                Text(subtitle, style: GoogleFonts.poppins(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400)),
              if (showSelected) const Icon(Icons.done, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
