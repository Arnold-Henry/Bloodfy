import 'package:bloodfy/Screens/all_centers.dart';
import 'package:bloodfy/Widgets/center_tile.dart';
import 'package:bloodfy/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Models/donation_center_model.dart';
import '../../theme/text_styles.dart';

Widget centerList(List<DonationCenterModel> center, BuildContext context){
return SliverList(
  delegate: SliverChildListDelegate(
    [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Donation Centers", style: TextStyles.title.bold,),
          IconButton(
            onPressed: (){
              print('Navigate to all centers screen');
              Navigator.push(
                context, 
                CupertinoPageRoute(
                  builder: (context)=> const AllCenters()));
            }, 
            icon: const Icon(
              Icons.sort,
            ))
        ],
      ).hP16,
      getCenterWidgetList(center, context)
    ]
  ));
}

Widget getCenterWidgetList(List<DonationCenterModel> centerDataList, BuildContext context) {
  return Column(
    children: centerDataList.map((x) {
      return centerTile(x, context);
    }).toList(),
  );
}
