import 'package:bloodfy/data_manager/data_manager.dart';
import 'package:bloodfy/theme/extention.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/light_color.dart';

class MyAppointments extends StatelessWidget {
  const MyAppointments({Key? key}) : super(key: key);

  launchCaller(String phone) async {
    String url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
      ),
      body: Consumer<DataManagerProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: provider.myAppointments.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Material(
                    elevation: 10.0,
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.myAppointments[index].centerName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20.0,
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            provider.myAppointments[index].centerAddress,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Seat No: ${provider.myAppointments[index].seatNo}',
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    'Time: ${provider.myAppointments[index].startTime} - ${provider.myAppointments[index].endTime}',
                                  ),
                                ],
                              ),
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: LightColor.grey.withAlpha(150),
                                ),
                                child: const Icon(
                                  Icons.call,
                                  color: Colors.white,
                                ),
                              ).ripple(
                                () {
                                  launchCaller(
                                      provider.myAppointments[index].centerContact);
                                },
                                borderRadius: BorderRadius.circular(10),
                              ),
                              MaterialButton(
                                height: 40.0,
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                onPressed: () async {
                                  QuerySnapshot querySnap = await FirebaseFirestore
                                      .instance
                                      .collection('Appointments')
                                      .where('donorId',
                                          isEqualTo: provider
                                              .myAppointments[index].centerId)
                                      .get();
                                  QueryDocumentSnapshot doc = querySnap.docs[0];
                                  // Assumption: the query returns only one document, THE doc you are looking for.
                                  DocumentReference docRef = doc.reference;
                                  await docRef.delete();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15,)
                ],
              );
            },
          );
        },
      ),
    );
  }
}
