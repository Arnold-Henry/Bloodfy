import 'package:bloodfy/Components/text_form_field.dart';
import 'package:bloodfy/data_manager/data_manager.dart';
import 'package:bloodfy/firebase_data/firebase_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_address_picker/map_address_picker.dart';
import 'package:map_address_picker/models/location_result.dart';
import 'package:provider/provider.dart';

import '../../Widgets/pic_up_location.dart';
import 'center_dashboard.dart';

class CenterDetailsScreen extends StatefulWidget {
  const CenterDetailsScreen({super.key});

  @override
  State<CenterDetailsScreen> createState() => _CenterDetailsScreenState();
}

class _CenterDetailsScreenState extends State<CenterDetailsScreen> {
  TextEditingController centerNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController seatsController = TextEditingController();

  TimeOfDay initialTime = TimeOfDay.now();

  final formKey = GlobalKey<FormState>();

  late TimeOfDay startingTime;
  late TimeOfDay endingTime;
  bool startingTimeSelected = false;
  bool endingTimeSelected = false;
  bool selectedLocation = false;
  bool isLoading = false;

  LocationResult? locationResult;

  Future<void> _startingTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    setState(() {
      startingTime = pickedTime!;

      startingTimeSelected = true;
    });
  }

  Future<void> _endingTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    endingTimeSelected = true;
    setState(() {
      endingTime = pickedTime!;
    });
  }

  openLocationPicker() async {
    var result = await showLocationPicker(
      context,
      initialCenter: const LatLng(0.3540014995827995, 32.62554135767036),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      layersButtonEnabled: true,
    );
    if (mounted) setState(() => locationResult = result);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SafeArea(
              child: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter more Center Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: centerNameController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Text is empty';
                        }
                        return null;
                      },
                      decoration: textFormFieldDecoration.copyWith(
                        hintText: 'Center Name',
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Text is empty';
                        }
                        return null;
                      },
                      controller: seatsController,
                      decoration: textFormFieldDecoration.copyWith(
                          hintText: 'Enter No. of Seats'),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 5,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Text is empty';
                        }
                        return null;
                      },
                      decoration: textFormFieldDecoration.copyWith(
                        hintText: 'Description',
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Text(
                      'Timings',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('From'),
                            const SizedBox(
                              height: 5,
                            ),
                            InkWell(
                              onTap: () {
                                _startingTime(context);
                                print('_starting Time Context');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    Text(
                                      startingTimeSelected
                                          ? startingTime.format(context)
                                          : 'Select Time',
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Icon(Icons.access_time),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('To'),
                            const SizedBox(
                              height: 5,
                            ),
                            InkWell(
                              onTap: () {
                                _endingTime(context);
                                print('_ending time context');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xffb8b5cb),
                                    ),
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Row(
                                  children: [
                                    Text(
                                      endingTimeSelected
                                          ? endingTime.format(context)
                                          : 'Select Time',
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Icon(Icons.access_time),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        openLocationPicker();
                        setState(() {
                          selectedLocation = false;
                        });
                        print('method get picked location');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Choose Center Location',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                          Icon(Icons.arrow_forward_sharp)
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    InkWell(
                      onTap: () {
                        openLocationPicker();
                        setState(() {
                          selectedLocation = false;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1.0,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: const Color(0xffb8b5cb))),
                        child: selectedLocation
                            ? InkWell(
                                onTap: () {
                                  openLocationPicker();
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: PickedUpLocation(
                                      latitude:
                                          locationResult!.latLng!.latitude,
                                      longitude:
                                          locationResult!.latLng!.longitude),
                                ),
                              )
                            : const Center(
                                child: Text('Tap and Pick'),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      locationResult == null
                          ? "Please select where the center is located."
                          : "${locationResult!.latLng!.latitude}\n${locationResult!.latLng!.longitude}",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (locationResult == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please fill in the missing fields')));
                          } else {
                            Provider.of<DataManagerProvider>(context,
                                    listen: false)
                                .setDCenterInfo(
                                    centerNameController.text,
                                    descriptionController.text,
                                    seatsController.text,
                                    locationResult.toString(),
                                    locationResult!.latLng!.longitude,
                                    locationResult!.latLng!.longitude,
                                    startingTime.format(context),
                                    endingTime.format(context));
                            addCenterProfileData(context).whenComplete(() {
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => CenterDashboard()));
                            });
                          }
                        }
                        print('validate the inputs');
                      },
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.redAccent,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          'Next',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20.0,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                )),
          )),
        ),
      ),
    );
  }
}
