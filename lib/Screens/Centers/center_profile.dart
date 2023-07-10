import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widgets/logout.dart';
import '../../data_manager/data_manager.dart';
import '../Authentications/login_screen.dart';

class CenterUserProfileScreen extends StatelessWidget {
  const CenterUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<DataManagerProvider>(
        builder:(context, provider, child) {
          return Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: (){
                      print('pop context');
                       Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Color.fromARGB(255, 183, 58, 58),
                      backgroundImage: AssetImage("images/logo.png"),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(provider.centerProfile.centerName, style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20
                    ),),
                    
                    const SizedBox(
                      height: 8,
                    ),
                    Text(provider.centerProfile.center.centerEmail, style: const TextStyle(
                      fontSize: 18
                    ),),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(provider.centerProfile.center.centerContact, style: const TextStyle(
                      fontSize: 18
                    ),),
                    const SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                      onPressed: (){
                        print('Navigate to Login Screen');
                        Logout().accountLogout().whenComplete((){
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  (Route<dynamic> route) => false);
                        });
                      },
                      color: Colors.grey[700],
                      child: const Text('Logout', style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),),
                    )
                  ],
                ),
              )
            ],
          );
        },),
    );
  }
}