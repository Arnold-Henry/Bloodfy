import 'package:bloodfy/theme/extention.dart';
import 'package:bloodfy/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_manager/data_manager.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Hello,",
          style: TextStyles.title,
        ),
        Text(
            Provider.of<DataManagerProvider>(context)
                .currentUser
                .donorFullName,
            style: TextStyles.h1Style),
      ],
    ).p16;
  }
}