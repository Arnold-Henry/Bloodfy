import 'package:bloodfy/Widgets/Dashboard/drive_card.dart';
import 'package:bloodfy/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/light_color.dart';
import '../../theme/text_styles.dart';
import '../../theme/theme.dart';

Widget driveList( BuildContext context) {
  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("About Blood Donation", style: TextStyles.title.bold),
            GestureDetector(
              onTap: () {
                _launchURL();
              },
              child: Text(
                "Learn More",
                style: TextStyles.body.bold
                    .copyWith(color: Theme.of(context).primaryColor),
              ).p(8),
            )
          ],
        ),
      ),
      getDriveWidgetList( context)
    ],
  );
}

Widget getDriveWidgetList( BuildContext context) {
  return SizedBox(
    height: AppTheme.fullHeight(context) * 0.28,
    width: AppTheme.fullWidth(context),
    child: driveCardWidget(context, color: LightColor.grey, lightColor: LightColor.black)
  );
}

_launchURL() async {
   final Uri url = Uri.parse('https://www.redcrossblood.org/donate-blood/blood-types.html');
   if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
    }
}
