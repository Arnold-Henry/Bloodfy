import 'package:bloodfy/Screens/Centers/center_profile.dart';
import 'package:bloodfy/Screens/terms_and_conditions.dart';
import 'package:bloodfy/data_manager/data_manager.dart';
import 'package:bloodfy/firebase_data/firebase_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/Authentications/login_screen.dart';
import '../Screens/Centers/center_reviews.dart';
import 'logout.dart';

class CenterDrawer extends StatelessWidget {
  const CenterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      backgroundColor: Colors.redAccent,
      child: SafeArea(
        child: Padding(
          padding:  const EdgeInsets.only(top: 50.0, left: 10.0),
          child: Column(
            children: [
              Image.asset(
                'images/logo.png',
                scale: 5,
              ),
              const Text(
                'Bloodfy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              InkWell(
                onTap: () {
                  print('navigate to center profil screen');
                  Navigator.push(
                    context, 
                    CupertinoPageRoute(
                      builder: (context) => const CenterUserProfileScreen()));
                },
                child: drawerChild(Icons.account_circle_outlined, 'Profile'),
              ),
              InkWell(
                onTap: () {
                  print('navigate to reviews screen');
                  final myId = 
                    Provider.of<DataManagerProvider>(context, listen: false)
                        .currentUser
                        .donorId;
                    getMyAppointmentsFromFirebase(myId, context)
                        .whenComplete((){
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const ReviewsScreen()));

                      });
                },
                child:  drawerChild(
                  Icons.reviews, 'Reviews'),
              ),
              InkWell(
                onTap: () {
                  print('navigate to T&S');
                  Navigator.push(
                    context, 
                    CupertinoPageRoute(
                      builder: (context) => const TermsAndconditions()));
                  
                },
                child: 
                drawerChild(Icons.policy_outlined, 'Terms & Conditions'),
              ),
              drawerChild(Icons.help_center_outlined, 'Help Center'),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: MaterialButton(onPressed: (){
                  print('Logout Logic');
                  Logout().accountLogout().whenComplete((){
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (Route<dynamic> route)=> false);
                   });
                },
                color: Colors.grey[700],
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900
                  ),
                ),),)
            ],
          ),)),
    );
  }
  Widget drawerChild(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30.0,
            color: Colors.white,
          ),
          const SizedBox(
            width: 20.0,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}