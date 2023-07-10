import 'package:bloodfy/data_manager/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Widgets/apointment_card.dart';

class DonorAppointmentScreen extends StatefulWidget {
  const DonorAppointmentScreen({
    Key? key,
    required this.centerName,
    required this.centerFullName,
    required this.seats,
    required this.centerAddress,
    required this.centerContact,
    required this.centerId,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  final String centerName;
  final String centerFullName;
  final int seats;
  final String centerAddress;
  final String centerContact;
  final String centerId;
  final String startTime;
  final String endTime;

  @override
  _DonorAppointmentScreenState createState() => _DonorAppointmentScreenState();
}

class _DonorAppointmentScreenState extends State<DonorAppointmentScreen> {
  DateTime now = DateTime.now();
  late DateTime startTime;
  late DateTime endTime;
  late Duration step;

  List<String> timeSlots = [];
  late DateTime sTime;
  late DateTime eTime;

  @override
  initState() {
    super.initState();
    initializeDateFormatting();

    sTime = DateFormat.jm().parse(widget.startTime);
    eTime = DateFormat.jm().parse(widget.endTime);

    startTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(DateFormat("HH").format(sTime)),
        int.parse(DateFormat("mm").format(sTime)),
        0);
    endTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(DateFormat("HH").format(eTime)),
        int.parse(DateFormat("mm").format(eTime)),
        0);
    step = const Duration(minutes: 30);

    while (startTime.isBefore(endTime)) {
      DateTime timeIncrement = startTime.add(step);
      timeSlots.add(DateFormat.Hm().format(timeIncrement));
      startTime = timeIncrement;
    }
    print(timeSlots);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Consumer<DataManagerProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
              itemCount: timeSlots.length ~/ 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        widget.centerName,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w700),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          widget.centerAddress,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      )
                    ],
                  );
                } else {
                  return AppointmentCard(
                      seats: widget.seats,
                      centerName: widget.centerName,
                      centerAddress: widget.centerAddress,
                      centerContact: widget.centerContact,
                      centerId: widget.centerId,
                      startTime: timeSlots[index - 1],
                      endTime: timeSlots[index]);
                }
              });
        },
      )),
    );
  }
}
