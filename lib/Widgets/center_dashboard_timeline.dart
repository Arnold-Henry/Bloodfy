import 'package:bloodfy/data_manager/data_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationCenterTL extends StatefulWidget {
  const DonationCenterTL({
    Key? key,
      required this.startTime,
      required this.seats,
      required this.endTime,
      required this.centerId,
      required this.centerName,
      required this.centerAddress,
      required this.centerContact
  }) : super(key: key);

  final String startTime;
  final int seats;
  final String endTime;
  final String centerId;
  final String centerName;
  final String centerAddress;
  final String centerContact;

  @override
  State<DonationCenterTL> createState() => _DonationCenterTLState();
}

class _DonationCenterTLState extends State<DonationCenterTL> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      child: Consumer<DataManagerProvider>(
        builder: (context, provider, child) {
          return Material(
            borderRadius: BorderRadius.circular(15.0),
            elevation: 8.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                height: 300,
                child: ListView.builder(
                  itemCount: widget.seats,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    bool booked = false;
                    if (index == 0) {
                      return Text(
                        'Slot > ${widget.startTime}-${widget.endTime}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    } else {
                      for (var data in provider.appointmentList) {
                        if (data.startTime == widget.startTime &&
                            data.seatNo == index &&
                            data.appointmentStatus == 'Booked') {
                          booked = true;
                        }
                      }
                      return singleApp(index, context, booked);
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget singleApp(int seatNo, BuildContext context, bool isBooked) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$seatNo',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Icon(
              Icons.event_seat_rounded,
              size: 45,
              color: isBooked ? Colors.grey : Colors.green,
            ),
            AbsorbPointer(
              absorbing: isBooked ? false : true,
              child: MaterialButton(
                color: isBooked ? Colors.red : Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onPressed: () async {
                  if (isBooked) {
                    QuerySnapshot querySnap = await FirebaseFirestore.instance
                        .collection('Centers')
                        .where('centerId', isEqualTo: Provider.of<DataManagerProvider>(context, listen: false).getCenterProfile.center.centerId)
                        .get();
                    QueryDocumentSnapshot doc = querySnap.docs[0];
                    DocumentReference docRef = doc.reference;
                    await docRef.delete();
                  }
                },
                child: Text(
                  isBooked ? 'Cancel' : 'Waiting',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}




