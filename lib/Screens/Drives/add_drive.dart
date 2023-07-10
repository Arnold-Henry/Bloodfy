import 'dart:io';
import 'package:bloodfy/firebase_data/firebase_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../Widgets/Dashboard/BD_drive_list.dart';
import '../../data_manager/data_manager.dart';


class BloodDonationDriveForm extends StatefulWidget {
  const BloodDonationDriveForm({Key? key}) : super(key: key);

  @override
  State<BloodDonationDriveForm> createState() => _BloodDonationDriveFormState();
}

class _BloodDonationDriveFormState extends State<BloodDonationDriveForm> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  String _location = '';
  String _name = '';
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  File? _image;
  String _description = '';

  TextEditingController driveNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  late TextEditingController _dateController;
  late TextEditingController _timeController = TextEditingController();

   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dateController = TextEditingController(text: _date.toString().split(' ')[0]);
    _timeController = TextEditingController(text: _time.format(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Blood Donation Drive'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: driveNameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
                onChanged: (value) {
                  _location = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Date'),
                controller: _dateController,
                readOnly: true,
                onTap: _selectDate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Time'),
                controller: _timeController,
                readOnly: true,
                onTap: _selectTime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a time';
                  }
                  return null;
                }
                
              ),
              GestureDetector(
                onTap: _selectImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: _image != null
                      ? Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Text(
                            'Select an Image',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
              TextFormField(
                controller: descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  _description = value;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addDrive,
                child: const Text('Add Drive'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (date != null) {
      setState(() {
        _date = date;
        _dateController.text = _date.toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (time != null) {
      setState(() {
        _time = time;
        _timeController.text = _time.format(context);
      });
    }
  }

  Future<void> _selectImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _addDrive() async {
    if (_formKey.currentState!.validate()) {
      // Upload image
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');
      final uploadTask = storageRef.putFile(_image!);
      final imageUrl = await (await uploadTask).ref.getDownloadURL();

      String driveId = Uuid().v4();

      // Add data to Firestore
      Provider.of<DataManagerProvider>(context, listen: false)
          .setBDDriveInfo( 
            driveId,
            driveNameController.text, 
            locationController.text, 
            _dateController.text, 
            _timeController.text, 
            imageUrl, 
            descriptionController.text);
          addDriveInfo(context).whenComplete(() {
            Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) =>  BloodDonationDriveDetails(driveId: driveId),
        ),
      );
          });
          

    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}