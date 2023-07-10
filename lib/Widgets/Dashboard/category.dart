import 'package:bloodfy/Screens/all_centers.dart';
import 'package:bloodfy/theme/extention.dart';
import 'package:bloodfy/theme/light_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Models/donation_center_model.dart';
import '../../theme/text_styles.dart';
import '../../theme/theme.dart';
import 'category_card.dart';

Widget category(List<DonationCenterModel> availableCenterList, BuildContext context){
  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
             Text('Availabe Centers', style: TextStyles.title.bold),
            Text(
              "See all",
              style: TextStyles.titleNormal.copyWith(color: Theme.of(context).primaryColor),
            ).p(8).ripple((){
              Navigator.push(context, 
              CupertinoPageRoute(builder: (context) => const AllCenters()));
            })
          ],
        ),
      ),
      SizedBox(
        height: AppTheme.fullHeight(context)* .28,
        width: AppTheme.fullWidth(context),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            getavailablecenterList(availableCenterList, context)
          ]
        ),

      )
    ],
  );

}

Widget getavailablecenterList(List<DonationCenterModel> availableCenterList, BuildContext context){
  return Column(
    children: availableCenterList.map((x) {
    return categoryCardWidget(
              context,
              x,
              color: LightColor.orange,
              lightColor: LightColor.lightOrange,
            );
    }).toList()
  );
}