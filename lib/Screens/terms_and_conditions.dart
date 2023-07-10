import 'package:flutter/material.dart';

class TermsAndconditions extends StatelessWidget {
  const TermsAndconditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Condditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heading('END USER LICENSE AGREEMENT'),
              const SizedBox(
                height: 5,
              ),
              heading('Last updated 15 June, 2023 \nDeveloped by: Arnold'),
              const SizedBox(
                height: 5,
              ), 
              para(
                'Bloodfy is licensed to You (End-User) by Silver Soft ("Licensor"), for use only under the terms of this License Agreement. By downloading the Licensed Application from Google\'s software distribution platform ("Google Play Store"), and any update thereto (as permitted by this License Agreement), You indicate that You agree to be bound by all of the terms and conditions of this License Agreement, and that You accept this License Agreement. Google Play Store is referred to in this License Agreement as "Services."  The parties of this License Agreement acknowledge that the Services are not a Party to this License Agreement and are not bound by any provisions or obligations with regard to the Licensed Application, such as warranty, liability, maintenance and support thereof. Silver Soft, not the Services, is solely responsible for the Licensed Application and the content thereof.'
              ),
              const SizedBox(
                height: 5.0,
              ),
              heading('THE APPLICATION '),
              const SizedBox(
                height: 5,
              ),
              para('Bloodfy ("Licensed Application") is a piece of software created to educate donors about blood donation — and customized for android mobile devices ("Devices"). It is an education tool.'),
              const SizedBox(
                height: 5,
              ),
              heading('LEGAL COMPLIANCE'),
              const SizedBox(
                height: 5,
              ),
              para('You represent and warrant that You are not located in a country that is subject to a Uganda Government embargo, or that has been designated by the Uganda Government as a "terrorist supporting" country; and that You are not listed on any Uganda Government list of prohibited or restricted parties'),
              const SizedBox(
                height: 5,
              ),
              heading('CONTACT INFORMATION'),
              const SizedBox(
                height: 5,
              ),
              para(
                'For general inquiries, complaints, questions or claims concerning the Licensed Application, please contact: Developed by: Arnold,'
                ' Kyambogo University, Kampala, Uganda '
              ),
              heading('INTELLECTUAL PROPERTY RIGHTS'),
              const SizedBox(
                height: 5,
              ),
              para('Silver Soft and the End-User acknowledge that, in the event of any third-party claim that the Licensed Application or the End-User\'s possession and use of that Licensed Application infringes on the third party\'s intellectual property rights, Silver Soft, and not the Services, will be solely responsible for the investigation, defense, settlement, and discharge or any such intellectual property infringement claims.'),
              Container(
                alignment: Alignment.bottomRight,
                child: MaterialButton(
                  color: Colors.blue,
                  child: const Text('Agree'),
                  onPressed: (){
                    Navigator.pop(context);
                    print('Navigate to the homepage Screen');
                  }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget heading(String head) {
  return Text(
    head,
    style: const TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 16.0,
    ),
  );
}

Widget para(String para) {
  return Text(
    para,
    style: const TextStyle(
      fontSize: 12.0,
    ),
  );
}
