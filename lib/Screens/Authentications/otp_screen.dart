import 'package:bloodfy/Models/donors_model.dart';
import 'package:bloodfy/Screens/Centers/center_details.dart';
import 'package:bloodfy/Screens/home_dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../firebase_authentication/firebase_authentication.dart';

class OneTimePasswordScreen extends StatefulWidget {
  const OneTimePasswordScreen({Key? key, required this.user}) : super(key: key);

  final DonorInfo user;
  
  

  @override
  State<OneTimePasswordScreen> createState() => _OneTimePasswordScreenState();
}

class _OneTimePasswordScreenState extends State<OneTimePasswordScreen> {

  bool isLoading = false;
  late String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                'Phone Verification',
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                'Enter 6 digit code sent to your number ',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Pinput(
                length: 6,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 255, 113, 113),
                      fontWeight: FontWeight.w600),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (s) {},
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onCompleted: (pin) async {
                  setState(() {
                    isLoading = true;
                  });

                  verify(pin, context, widget.user)
                      .whenComplete(() => setState(() {
                            isLoading = false;
                          }));
                },
              ),
              const SizedBox(
                height: 40.0,
              ),
              MaterialButton(
                onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                         builder: (context) => HomePageScreen()));
                  
                  // On Verification navigate to Homepage Screen
                },
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Color.fromARGB(255, 255, 113, 113),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Verify',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                            color: Colors.white
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}