import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Components/text_form_field.dart';
import 'package:email_validator/email_validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                'Bloodfy',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 255, 113, 113),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              const Text('Enter your email to reset password'),
              const SizedBox(
                height: 12.0,
              ),
              SizedBox(
                height: 60,
                child: TextFormField(
                  controller: emailController,
                  cursorColor: Colors.white,
                  style: const TextStyle(fontSize: 18.0),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: textFormFieldDecoration.copyWith(
                    labelText: 'Enter valid Email',
                  ),
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid Email'
                          : null,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              MaterialButton(
                onPressed: verifyEmail,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: const Color.fromARGB(255, 255, 113, 113),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    'Enter',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20.0,
                      color: Colors.white,
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

  Future verifyEmail() async {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context)=>Center(child: CircularProgressIndicator(),));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      AlertDialog(
        title: Text('Email sent'),
        content: Text(
            'The reset password email was sent to your email $emailController.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      Navigator.of(context).pop();
    }
  }
}
