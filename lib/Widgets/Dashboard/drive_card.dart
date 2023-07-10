import 'package:bloodfy/Models/donation_drive.dart';
import 'package:bloodfy/theme/extention.dart';
import 'package:bloodfy/theme/light_color.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../theme/text_styles.dart';
import '../../theme/theme.dart';
import '../random_color.dart';

Widget driveCardWidget(BuildContext context,
{
  required Color color,
  required Color lightColor,
}) {
  TextStyle titleStyle = TextStyles.title.bold.white;
  TextStyle subtitleStyle = TextStyles.body.bold.white;
  if (AppTheme.fullWidth(context) < 392) {
    titleStyle = TextStyles.body.bold.white;
    subtitleStyle = TextStyles.bodySm.bold.white;
  }
  return AspectRatio(
    aspectRatio: 6 / 8,
    child: Container(
      height: 280,
      width: AppTheme.fullWidth(context) * .35,
      margin: const EdgeInsets.only(left: 10, right: 15, bottom: 20, top: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     offset: const Offset(1.0, 1.0),
        //     offset: const Offset(1.0, 1.0),
        //     blurRadius: 3.0,
        //     color: Colors.deepOrangeAccent,
        //   )
        // ],
      ),
      child: Material(
        elevation: 10.0,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/hhh.jpg'), fit: BoxFit.cover)
            ),
            child: Container(
              color: Colors.black38,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Flexible(child: Text('Are You Eligible ?', style: titleStyle,).hP8),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Flexible(child: Text('Find Out Today', style: subtitleStyle).hP8)
                ],
              ).p16,
            ),
          ),
        ),
      ),
    ),
  );
}
