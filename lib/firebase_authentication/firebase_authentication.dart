import 'package:bloodfy/Models/donors_model.dart';
import 'package:bloodfy/Screens/Centers/center_dashboard.dart';
import 'package:bloodfy/Screens/Centers/center_details.dart';
import 'package:bloodfy/data_manager/data_manager.dart';
import 'package:bloodfy/firebase_data/firebase_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/home_dashboard.dart';

String verificationID = '';
Future<void> sendSms(String phoneNumber) async{
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) {},
    verificationFailed: (FirebaseAuthException e) {},
    codeSent: (String verificationId, int? resendToken) {
      verificationID = verificationId;
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}

Future<void> verify(
  smsCode, BuildContext context, DonorInfo donor)async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: smsCode);
    late SharedPreferences login;
    try{
      login = await SharedPreferences.getInstance();
      await FirebaseAuth.instance.signInWithCredential(credential);
      try{
        final userResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: donor.donorEmail, password: donor.donorPassword);
        if(userResult != null){
          await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: donor.donorEmail, 
              password: donor.donorPassword)
            .whenComplete(() {
              if(donor.role == 'Donor'){
                // provide data from the data manager for the donor
                Provider.of<DataManagerProvider>(context, listen: false)
                    .setDonorProfile(donor);
                addDonorProfileData(donor, context);
                login.setString('email', donor.donorEmail);
                login.setString('password', donor.donorPassword);
                login.setString('role', donor.role);
                login.setBool('login', false);
                Navigator.of(context,).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePageScreen()),
                   (Route<dynamic> route) => false);
              } else{
                // provide data from the data manager for the donation center
                Provider.of<DataManagerProvider>(context, listen: false)
                    .setDonationCenterInfo(
                      userResult.user!.uid, 
                      donor.donorFullName, 
                      donor.donorEmail, 
                      donor.donorContact);
                login.setString('email', donor.donorEmail);
                login.setString('password', donor.donorPassword);
                login.setString('role', donor.role);
                login.setBool('login', false);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const CenterDetailsScreen()), 
                  (Route<dynamic> route) => false);
              }
            });
        }
      } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${e.message}')));
    }
    } on FirebaseAuthException catch (e) {
    if (e.code == 'invalid-verification-code') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Invalid code')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
  }
  }

  Future<void> signIn(
    String email, String password, String role, BuildContext context)async {
     try{
      final userResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
        if (userResult != null){
          if (role == 'Donor'){
            await getDonorProfile(email, context).whenComplete(() {
              Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePageScreen()),
              (Route<dynamic> route) => false);
            });
          } else{
            await getCenterProflie(email, context).whenComplete(() {
              Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => CenterDashboard()),
              (Route<dynamic> route) => false);
            });
          }
        }
     } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${e.message}')));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
  }
    }