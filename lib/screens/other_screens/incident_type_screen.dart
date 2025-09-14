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
import 'package:untitled/constants/strings.dart';

class IncidentTypeScreen extends StatefulWidget {
  const IncidentTypeScreen({super.key});

  @override
  State<IncidentTypeScreen> createState() => _IncidentTypeScreenState();
}

class _IncidentTypeScreenState extends State<IncidentTypeScreen> {
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
            StringHelper.typeOfIncident,
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
                    _buildListTile(StringHelper.bomBlast,'',ImageHelper.bombIc,
                        StringHelper.bomBlast==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(StringHelper.bomBlast));
                          context.pop();
                        }),
                    _buildListTile(StringHelper.planeCrash,'',ImageHelper.missileIc,
                        StringHelper.planeCrash==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(StringHelper.planeCrash));
                          context.pop();
                        }),
                    _buildListTile(StringHelper.missileAttack,'',ImageHelper.attackIc,
                        StringHelper.missileAttack==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(StringHelper.missileAttack));
                          context.pop();
                        }),
                    _buildListTile(StringHelper.droneAttack,'',ImageHelper.planeIc,
                        StringHelper.droneAttack==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(StringHelper.droneAttack));
                          context.pop();
                        }),
                    _buildListTile(StringHelper.animalAbuse,'',ImageHelper.dogIc,
                        StringHelper.animalAbuse==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(StringHelper.animalAbuse));
                          context.pop();
                        }),
                    _buildListTile(StringHelper.humanAbuse,'',ImageHelper.humanIc,
                        StringHelper.humanAbuse==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(StringHelper.humanAbuse));
                          context.pop();
                        }),
                    _buildListTile(StringHelper.roadCloser,'',ImageHelper.roadIc,
                        StringHelper.roadCloser==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(StringHelper.roadCloser));
                          context.pop();
                        }),
                    _buildListTile(StringHelper.landslide,'',ImageHelper.landIc,
                        StringHelper.landslide==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(StringHelper.landslide));
                          context.pop();
                        }),
                    _buildListTile(StringHelper.fight,'',ImageHelper.fightIc,
                        StringHelper.fight==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(StringHelper.fight));
                          context.pop();
                        }),
                    _buildListTile(StringHelper.others,'',ImageHelper.otherIc,
                        StringHelper.others==incidentState.selectedIncidentName,(){
                          BlocProvider.of<SetIncidentsBloc>(context).add(SetIncidentsRefreshEvent(StringHelper.others));
                          context.pop();
                        }),

                    CustomButton(text: StringHelper.select, onTap: (){})
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
