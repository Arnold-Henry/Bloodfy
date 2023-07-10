import 'package:bloodfy/Screens/terms_and_conditions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/Appointments/my_appointment.dart';
import '../Screens/Authentications/login_screen.dart';
import '../data_manager/data_manager.dart';
import '../firebase_data/firebase_data.dart';
import 'google_map.dart';
import 'logout.dart';

class Drawee extends StatelessWidget {
  const Drawee({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      backgroundColor: const Color.fromARGB(255, 96, 120, 139),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 180,
              child: DrawerHeader(
                child: Column(
                  children: [
                    Image.asset(
                      'images/logo.png',
                      scale: 9.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Blodfy',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 64, 64),
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                print('aaaaaaaaaaaaaaaaaaaaaaaaaaa');
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const MapSample(),
                  ),
                );
              },
              child: drawerChild(Icons.map_outlined, 'Find Nearby Centers'),
            ),
            InkWell(
              onTap: () {
                print('AAAAAAAAAAAAAAAAAAAAAAAAAAA');
                final myId = Provider.of<DataManagerProvider>(context, listen: false).currentUser.donorId;
                getMyAppointmentsFromFirebase(myId, context).whenComplete(() {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const MyAppointments(),
                    ),
                  );
                });
              },
              child: drawerChild(Icons.list, 'Appointments'),
            ),
            InkWell(
              onTap: () {
                print('GGGGGGGGGGGGGGGGGGGGGGGGG');
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const TermsAndconditions(),
                  ),
                );
              },
              child: drawerChild(Icons.policy_outlined, 'Terms & Conditions'),
            ),
            InkWell(
              onTap: () {
                print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAG');
              },
              child: drawerChild(Icons.help_outlined, 'Help Center'),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: MaterialButton(
                onPressed: () {
                  print('yyyyyyyyyyyyyyyyyy');
                  Logout().accountLogout().whenComplete(() {
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (BuildContext context) => LoginScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  });
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerChild(IconData icon, String text) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
