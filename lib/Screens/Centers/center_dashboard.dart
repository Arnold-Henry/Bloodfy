import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:bloodfy/Widgets/center_dashboard_timeline.dart';
import 'package:bloodfy/Widgets/center_drawer.dart';
import 'package:bloodfy/data_manager/data_manager.dart';
import 'package:bloodfy/firebase_data/firebase_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CenterDashboard extends StatefulWidget {
  CenterDashboard({Key? key}) : super(key: key);
  @override
  State<CenterDashboard> createState() => _CenterDashboardState();
}

class _CenterDashboardState extends State<CenterDashboard> {
  final _advancedDrawerController1 = AdvancedDrawerController();
  DateTime now = DateTime.now();
  late DateTime startTime;
  late DateTime endTime;
  late Duration step;
  List<String> timeSlots = [];
  late DateTime sTime;
  late DateTime eTime;
  bool isOpen = false;

  Future<void> updateCenterStatus(BuildContext context, String status) async {
    String centerId = Provider.of<DataManagerProvider>(context, listen: false)
        .getCenterProfile
        .center
        .centerId;
    print('Center ID: $centerId');
    try {
      QuerySnapshot querySnap = await FirebaseFirestore.instance
          .collection('Centers')
          .where('centerId',
              isEqualTo:
                  Provider.of<DataManagerProvider>(context, listen: false)
                      .getCenterProfile
                      .center
                      .centerId)
          .get();
      print('Query Snapshot: $querySnap');
      if (querySnap.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnap.docs) {
          print('Document ID: ${doc.id}');
          print('Document Data: ${doc.data()}');
          DocumentReference docRef = doc.reference;
          print('Document Reference: $docRef');
          await docRef.update({'centerStatus': status});
        }
        QueryDocumentSnapshot doc = querySnap.docs[0];
        DocumentReference docRef = doc.reference;
        await docRef.update({'centerStatus': status});
      }
    } catch (e, stackTrace) {
      // Log the error and stack trace
      print('Error updating center status: $e');
      print('Stack trace: $stackTrace');
    }
  }

  @override
  void initState() {
    super.initState();
    getAppointmentFromFirebase(
      Provider.of<DataManagerProvider>(context, listen: false)
          .getCenterProfile
          .center
          .centerId,
      context,
    );

    initializeDateFormatting();
    String esTime = '10:00 AM';
    String etTime = '9:00 AM';
    sTime = DateFormat.jm().parse(esTime);
    eTime = DateFormat.jm().parse(etTime);
    startTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(DateFormat("HH").format(sTime)),
      int.parse(DateFormat("mm").format(sTime)),
      0,
    );
    endTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(DateFormat("HH").format(eTime)),
      int.parse(DateFormat("mm").format(eTime)),
      0,
    );
    step = Duration(minutes: 30);
    while (startTime.isBefore(endTime)) {
      DateTime timeIncrement = startTime.add(step);
      timeSlots.add(DateFormat.Hm().format(timeIncrement));
      startTime = timeIncrement;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
        backdropColor: Colors.blueGrey,
        controller: _advancedDrawerController1,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        animateChildDecoration: true,
        rtlOpening: false,
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        drawer: const CenterDrawer(),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('Appointments').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            print('object ${snapshot.connectionState}');

            if (snapshot.hasData) {
              print(
                  'centerId: ${Provider.of<DataManagerProvider>(context, listen: false).getCenterProfile.center.centerId}');
              return Scaffold(
                appBar: AppBar(
                  leading: InkWell(
                    onTap: () {
                      _advancedDrawerController1.showDrawer();
                    },
                    child: const Icon(
                      Icons.menu,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  title: const Text(
                    'Dashboard',
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedToggleSwitch<bool>.dual(
                        current: isOpen,
                        first: false,
                        second: true,
                        dif: 50.0,
                        borderColor: Colors.transparent,
                        borderWidth: 5.0,
                        height: 55,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1.5),
                          ),
                        ],
                        onChanged: (b) async {
                          setState(() {
                            isOpen = b;
                          });
                          String status = isOpen ? 'Open' : 'Closed';

                          // Call the updateCenterStatus method to update the status
                          await updateCenterStatus(context, status);
                        },
                        colorBuilder: (b) => b ? Colors.red : Colors.green,
                        iconBuilder: (value) => value
                            ? Icon(Icons.arrow_back_ios)
                            : Icon(Icons.arrow_forward_ios_sharp),
                        textBuilder: (value) => value
                            ? Center(child: Text('Oh no...'))
                            : Center(child: Text('Nice :)')),
                      ),
                    ),
                  ],
                ),
              body: SafeArea(
                child: Consumer<DataManagerProvider>(
                  builder: (context, provider, child) {
                    return ListView.builder(
                      itemCount: timeSlots.length ~/ 2,
                      itemBuilder: (context, index) {
                        return DonationCenterTL(
                          seats: int.parse(provider.getCenterProfile.seats),
                          centerAddress: provider.getCenterProfile.location.address,
                          centerContact: provider.getCenterProfile.center.centerContact,
                          centerName: provider.getCenterProfile.centerName,
                          centerId: provider.getCenterProfile.center.centerId,
                          startTime: timeSlots[index],
                          endTime: timeSlots[index + 1],
                        );
                      },
                    );
                  },
                ),
              ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}
