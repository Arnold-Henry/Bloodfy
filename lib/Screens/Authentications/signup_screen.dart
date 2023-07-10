import 'package:bloodfy/Models/donors_model.dart';
import 'package:bloodfy/firebase_authentication/firebase_authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../Components/text_form_field.dart';
import 'login_screen.dart';
import 'otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController fullNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController contactController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController rePasswordController = TextEditingController();

  late String role;
  late String type;

  bool isLoading = false;
  bool _isShow = false;

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
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      controller: fullNameController,
                      cursorColor: const Color.fromARGB(255, 255, 113, 113),
                      style: const TextStyle(fontSize: 18.0),
                      decoration: textFormFieldDecoration.copyWith(
                        labelText: 'Full Name',
                      ),
                    ),
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
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      controller: contactController,
                      keyboardType: TextInputType.number,
                      cursorColor: const Color.fromARGB(255, 255, 113, 113),
                      style: const TextStyle(fontSize: 18.0),
                      decoration: textFormFieldDecoration.copyWith(
                          labelText: 'Contact', prefixText: '+256'),
                    ),
                  ),
                  ReusableDropDown(onChanged: (value) {
                    setState(() {
                      role = value!; 
                      
                    });
                  }),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      controller: passwordController,
                      cursorColor: const Color.fromARGB(255, 255, 113, 113),
                      style: const TextStyle(fontSize: 18.0),
                      obscureText: true,
                      decoration: textFormFieldDecoration.copyWith(
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      controller: rePasswordController,
                      cursorColor: Colors.white,
                      style: const TextStyle(fontSize: 18.0),
                      obscureText: true,
                      decoration: textFormFieldDecoration.copyWith(
                        labelText: 'Re-Enter Password',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                MaterialButton(
                    onPressed: () async {
                      if(fullNameController.text.isEmpty &&
                         emailController.text.isEmpty &&
                         contactController.text.isEmpty &&
                         role == 'Select' &&
                         passwordController.text.isEmpty
                      ){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please fill in all the fields')));
                      } else {
                        if(
                          passwordController.text !=
                          rePasswordController.text
                        ){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Password Not match')));    
                        } else {
                            setState(() {
                            isLoading = true;
                          });
                          const donorId = Uuid();
                          final userModel = DonorInfo(
                            donorId: donorId.v1(), 
                            donorFullName: fullNameController.text, 
                            donorEmail: emailController.text, 
                            donorContact: '+256${contactController.text}', 
                            role: role, 
                            donorPassword: passwordController.text);
                          sendSms(userModel.donorContact).whenComplete(() {
                            setState(() {
                              isLoading = false;
                            });
                          });  
                            Navigator.push(context, 
                            CupertinoPageRoute(builder: (context)=>
                              OneTimePasswordScreen(user: userModel,)));
                        }
                      }
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
                              'Signup',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20.0,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have account? '),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                              CupertinoPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 240, 132, 132)),
                        ),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReusableDropDown extends StatelessWidget {
  const ReusableDropDown({Key? key, required this.onChanged}) : super(key: key);

  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: 'Select',
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 113, 113),
        ),
        items: <String>['Select', 'Donor', 'D-Center']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: textFormFieldDecoration,
        onChanged: onChanged);
  }
}

