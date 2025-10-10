import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/bloc/blocked_list_bloc.dart';
import 'package:untitled/common/service/common_builder_dialog.dart';
import 'package:untitled/constants/colors_constant.dart';
import 'package:untitled/constants/strings.dart';

import '../../api/model/main/blocked_list_model.dart';
import '../../constants/app_config.dart';

class BlockedIncidents extends StatefulWidget {
  const BlockedIncidents({super.key});

  @override
  State<BlockedIncidents> createState() => _BlockedIncidentsState();
}

class _BlockedIncidentsState extends State<BlockedIncidents> {

  Color getStatusColor(String status) {
    switch (status) {
      case "Blocked":
        return Colors.red;
      case "Need Info":
        return Colors.amber;
      case "Under Review":
        return Colors.white;
      default:
        return Colors.grey;
    }
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback){
      BlocProvider.of<BlockedIncidentsBloc>(context).add(BlockedIncidentsRefreshEvent(size: 10,offset: 0));
    });
  }

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
            StringHelper.blockedIncidents,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<BlockedIncidentsBloc,BlockedIncidentsState>(
          builder: (context,incidentState){
          if(incidentState is BlockedIncidentsLoadingState){
            return BuilderDialog();
          }
          else if(incidentState is BlockedIncidentsSuccessState){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: incidentState.blockedListModel.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 8,
                  mainAxisExtent: 200,
                ),
                itemBuilder: (context, index) {
                  BlockedListModel incident = incidentState.blockedListModel[index];
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          incident.isVideo =='true'? AppConfig.HOST +incident.media![0].thumbnail.toString():
                          AppConfig.HOST + incident.media![0].name.toString(),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: getStatusColor(incident.status??""),
                            ),
                            color: getStatusColor(
                              incident.status??"",
                            ).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                incident.status??"",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }
          else if(incidentState is BlockedIncidentsErrorState){
            return Center(child: Text(incidentState.errorMsg));
          }
          return SizedBox();
        })
      ),
    );
  }
}
