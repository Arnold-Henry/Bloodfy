import 'package:bloodfy/Models/appointment_model.dart';
import 'package:bloodfy/data_manager/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase_data/firebase_data.dart';

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({
    Key? key,
    required this.seats,
    required this.centerName,
    required this.centerAddress,
    required this.centerContact,
    required this.centerId,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);
    final int seats;
    final String centerName;
    final String centerAddress;
    final String centerContact;
    final String centerId;
    final String startTime;
    final String endTime;

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      child: Consumer<DataManagerProvider>(
        builder: (context, provider, child) {
          return Consumer<DataManagerProvider>(
            builder: (context, provider, child) {
              return Material(
                borderRadius: BorderRadius.circular(15.0),
                elevation: 8.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListView.builder(
                      itemCount: widget.seats,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        bool booked = false;

                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Slot > ${widget.startTime} - ${widget.endTime}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        } else {
                          bool booked = false;
                          for (var data in provider.appointmentList) {
                            if (data.startTime == widget.startTime &&
                                data.seatNo == index &&
                                data.appointmentStatus == 'Booked') {
                              booked = true;
                            }
                          }
                          return singleApp(index, context, booked);
                        }
                      }
                    ),
                  ),
                );
               },
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
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),
            ),
            Icon(Icons.event_seat_rounded,
            size: 45.0,
            color: isBooked ? Colors.grey : Colors.green,),
            AbsorbPointer(
              absorbing: isBooked ? true : false,
                child: MaterialButton(
                  color: isBooked ? Colors.grey : Colors.green[800],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                       onPressed: () { 
                        final donrId = 
                            Provider.of<DataManagerProvider>(context,listen: false)
                                .currentUser
                                .donorId;
                        AppointmentModel model = AppointmentModel(
                          centerId: widget.centerId, 
                          startTime: widget.startTime, 
                          endTime: widget.endTime, 
                          centerName: widget.centerName, 
                          centerAddress: widget.centerAddress, 
                          centerContact: widget.centerContact, 
                          appointmentStatus: 'Booked', 
                          donorId: donrId, 
                          seatNo: seatNo);

                        setAppointment(model).whenComplete(() {
                          getAppointmentFromFirebase(widget.centerId, context);
                        });

                        },
                        child: Text(
                          isBooked ? 'Booked' : 'Book Now',
                          style: const TextStyle(
                            color: Colors.white
                          ),
                        ),)

            )
          ],
        )
      ],
    );
}
}

