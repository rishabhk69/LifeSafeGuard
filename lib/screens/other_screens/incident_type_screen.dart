import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/bloc/setincident_bloc.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/custom_button.dart';
import 'package:untitled/constants/image_helper.dart';
import 'package:untitled/constants/sizes.dart';
import 'package:untitled/localization/fitness_localization.dart';


class IncidentTypeScreen extends StatefulWidget {
  const IncidentTypeScreen({super.key});

  @override
  State<IncidentTypeScreen> createState() => _IncidentTypeScreenState();
}

class _IncidentTypeScreenState extends State<IncidentTypeScreen> {


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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:BlocBuilder<SetIncidentsBloc,SetIncidentsState>(
              builder: (context,incidentState){
              if(incidentState is SetIncidentsSuccessState){
                return  Column(
                  children: [
                    _buildListTile( GuardLocalizations.of(context)!.translate("bomBlast") ?? "",'',ImageHelper.bombIc,
                        (GuardLocalizations.of(context)!.translate("bomBlast") ?? "")==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(incidentName:GuardLocalizations.of(context)!.translate("bomBlast") ?? ""));
                          context.pop();
                        }),
                    _buildListTile(GuardLocalizations.of(context)!.translate("planeCrash") ?? "",'',ImageHelper.missileIc,
                        (GuardLocalizations.of(context)!.translate("planeCrash") ?? "")==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(incidentName:GuardLocalizations.of(context)!.translate("planeCrash") ?? ""));
                          context.pop();
                        }),
                    _buildListTile(GuardLocalizations.of(context)!.translate("missileAttack") ?? "",'',ImageHelper.attackIc,
                        (GuardLocalizations.of(context)!.translate("missileAttack") ?? "")==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(incidentName:GuardLocalizations.of(context)!.translate("missileAttack") ?? ""));
                          context.pop();
                        }),
                    _buildListTile(GuardLocalizations.of(context)!.translate("droneAttack") ?? "",'',ImageHelper.planeIc,
                        (GuardLocalizations.of(context)!.translate("droneAttack") ?? "")==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(incidentName:GuardLocalizations.of(context)!.translate("droneAttack") ?? ""));
                          context.pop();
                        }),
                    _buildListTile(GuardLocalizations.of(context)!.translate("animalAbuse") ?? "",'',ImageHelper.dogIc,
                        (GuardLocalizations.of(context)!.translate("animalAbuse") ?? "")==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(incidentName:GuardLocalizations.of(context)!.translate("animalAbuse") ?? ""));
                          context.pop();
                        }),
                    _buildListTile(GuardLocalizations.of(context)!.translate("humanAbuse") ?? "",'',ImageHelper.humanIc,
                        (GuardLocalizations.of(context)!.translate("humanAbuse") ?? "")==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(incidentName:GuardLocalizations.of(context)!.translate("humanAbuse") ?? ""));
                          context.pop();
                        }),
                    _buildListTile(GuardLocalizations.of(context)!.translate("roadCloser") ?? "",'',ImageHelper.roadIc,
                        (GuardLocalizations.of(context)!.translate("roadCloser") ?? "")==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(incidentName:GuardLocalizations.of(context)!.translate("roadCloser") ?? ""));
                          context.pop();
                        }),
                    _buildListTile(GuardLocalizations.of(context)!.translate("landslide") ?? "",'',ImageHelper.landIc,
                        (GuardLocalizations.of(context)!.translate("landslide") ?? "")==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(incidentName:GuardLocalizations.of(context)!.translate("landslide") ?? ""));
                          context.pop();
                        }),
                    _buildListTile(GuardLocalizations.of(context)!.translate("fight") ?? "",'',ImageHelper.fightIc,
                        (GuardLocalizations.of(context)!.translate("fight") ?? "")==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(incidentName:GuardLocalizations.of(context)!.translate("fight") ?? ""));
                          context.pop();
                        }),
                    _buildListTile(GuardLocalizations.of(context)!.translate("others") ?? "",'',ImageHelper.otherIc,
                        (GuardLocalizations.of(context)!.translate("others") ?? "")==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(incidentName:GuardLocalizations.of(context)!.translate("others") ?? ""));
                          context.pop();
                        }),

                    CustomButton(text: GuardLocalizations.of(context)!.translate("select") ?? "", onTap: (){})
                  ],
                );
              }
              return Container();
            })
          ),
        ),
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
              SizedBox(width: 25,height:25,child: SvgPicture.asset(assetName)),
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
