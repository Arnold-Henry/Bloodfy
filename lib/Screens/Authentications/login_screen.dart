import 'package:bloodfy/Screens/Authentications/forgot_password_screen.dart';
import 'package:bloodfy/Screens/Authentications/signup_screen.dart';
import 'package:bloodfy/firebase_authentication/firebase_authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showPassword = true;
  bool isLoading = false;
  bool isCenter = false;

  late SharedPreferences login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                    'images/logo.png',
                      height: 100,
                    width: 100,
                    color: const Color.fromARGB(255, 255, 113, 113),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'Bloodfy',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 255, 113, 113),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      controller: emailController,
                      cursorColor: const Color.fromARGB(255, 255, 113, 113),
                      style: const TextStyle(fontSize: 18.0),
                      decoration: textFormFieldDecoration.copyWith(
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      controller: passwordController,
                      cursorColor: const Color.fromARGB(255, 255, 113, 113),
                      style: const TextStyle(fontSize: 18.0),
                      obscureText: showPassword,
                      decoration: textFormFieldDecoration.copyWith(
                          labelText: 'Password',
                          suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              child: Icon(showPassword
                                  ? CupertinoIcons.eye
                                  : CupertinoIcons.eye_slash))),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                const ForgotPasswordScreen()));
                    },
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    contentPadding: const EdgeInsets.all(0.0),
                    title: const Text("Login as Donation Center"),
                    value: isCenter,
                    activeColor: const Color.fromARGB(255, 255, 113, 113),
                    onChanged: (newValue) {
                      setState(() {
                        isCenter = newValue!;
                      });
                    },
                    controlAffinity:
                        ListTileControlAffinity.leading, //  <-- leading Checkbox
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  MaterialButton(
                    elevation: 10.0,
                    onPressed: ()  async {
                      login = await SharedPreferences.getInstance();
                    setState(() {
                      isLoading = true;
                    });
                    if(isCenter){
                      try{
                        signIn(emailController.text, passwordController.text, 'D-Center', context)
                            .whenComplete(() => setState(() {
                              login.setString('email', emailController.text);
                              login.setString('password', passwordController.text);
                              login.setString('role', 'D-Center');
                              login.setBool('login', false);
                              isLoading = false;
                            },));

                      }catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$e')));
                        setState(() {
                          isLoading = false;
                        });
                      }
                    } else{
                      final userProfile = await FirebaseFirestore.instance
                          .collection('Donor')
                          .where('email', isEqualTo: emailController.text)
                          .get();
                      if (userProfile.docs.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User not found')));
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        signIn(emailController.text, passwordController.text, 
                        'Donor', context)
                            .whenComplete(() => setState(() {
                              login.setString('email', emailController.text);
                              login.setString('role', 'Donor');
                              login.setString('password', passwordController.text);
                              login.setBool('login', false);
                              isLoading = false;
                            },));
                      }
                    }
                      // 
                    },
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: const Color.fromARGB(255, 255, 113, 113),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20.0,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have account? ',
                        style: TextStyle(color: Colors.black),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const SignUpScreen()));
                          // Navigate to SignUp Screen
                        },
                        child: const Text(
                          'Signup',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 240, 132, 132)),
                        ),
                      )
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}