import 'package:bloodfy/Models/appointment_model.dart';
import 'package:bloodfy/Models/donation_center_model.dart';
import 'package:bloodfy/Models/donors_model.dart';
import 'package:bloodfy/data_manager/data_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/blood_donation_drive.dart';
import '../Models/donation_drive.dart';

Future<void> addDonorProfileData(
  DonorInfo user, BuildContext context)async {
    try{
      await FirebaseFirestore.instance.collection('Donor').add({
        'donorId': user.donorId,
        'fullName': user.donorFullName,
        'email': user.donorEmail,
        'contact': user.donorContact,
      });
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }

}



// Update drive details in Firestore
Future<void> updateDriveInfo(BuildContext context, String driveId,  String driveName,
  String location,
  String date,
  String time,
  String imageUrl,
  String description,) async {
  try {
    // Get a reference to the Firestore collection
    CollectionReference drivesCollection =
        FirebaseFirestore.instance.collection('donation Drives');

    // Update the document with the provided driveId
    await drivesCollection.doc(driveId).update({
      'driveName': driveName,
      'driveLocation': drivesCollection,
      'driveDate': date,
      'driveTime': time,
      'imageUrl': imageUrl,
      'description': description,
    });

    // Show a success message or perform any other desired actions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Drive details updated successfully'),
      ),
    );
  } catch (error) {
    // Show an error message or perform any other desired actions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to update drive details'),
      ),
    );
  }
}


Future<void> getDonorProfile(email, BuildContext context )async{
  try{
    final userProfile = await FirebaseFirestore.instance
        .collection('Donor')
        .where('email', isEqualTo: email)
        .get();
    for (var user in userProfile.docs){
      final userData = DonorInfo(
        donorId: user['donorId'], 
        donorFullName: user['fullName'], 
        donorEmail: user['email'], 
        donorContact: user['contact'], 
        role: 'Donor', 
        donorPassword: '',
        );
        Provider.of<DataManagerProvider>(context, listen: false)
            .setDonorProfile(userData);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
  }
} 

Future<void> getAllCenters(BuildContext context) async {
  final result = await FirebaseFirestore.instance
  .collection('Centers')
  .get();

  List<DonationCenterModel> centerList = [];

  for(var data in result.docs){
    DonationCenterInfo center = DonationCenterInfo(
      centerFullName: data['fullName'], 
      centerEmail: data['email'], 
      centerContact: data['contact'], 
      centerPassword: '', 
      role: 'D-Center', 
      centerId: data['centerId']);
   
    Location location = Location(
      address: data['address'], 
      latitude: data['latitude'], 
      longitude: data['longitude']);
   
    CenterStatus status = CenterStatus(
      status: data['centerStatus'], 
      startTime: data['startTime'], 
      endTime: data['endTime']);

    centerList.add(DonationCenterModel(
      centerName: data['centerName'], 
      center: center, 
      description: data['description'], 
      rating: double.parse("${data['rating']}"), 
      goodReviews: data['goodReviews'], 
      centerStatus: status, 
      location: location, 
      image: data['image'], 
      seats: data['seats']));
    
  }
  Provider.of<DataManagerProvider>(context, listen: false)
  .setAllCenters(centerList);
}

Future<void> getDrives(BuildContext context, String driveId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('donation Drives').where('driveId', isEqualTo: driveId)
      .get();

  final driveList = snapshot.docs.map((doc) {
    final data = doc.data();
    return BloodDonationDrive(
        driveId: doc.id,
        name: data['driveName'],
        location: data['driveLocation'],
        date: data['driveDate'],
        imageUrl: data['imageUrl'],
        description: data['description'],
        time: data['driveTime'],
      );
  }).toList();
  Provider.of<DataManagerProvider>(context, listen: false)
      .setDrives(driveList);
  
}

Future<void> getAllDrives(BuildContext context) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('donation Drives')
      .get();

  final driveList = querySnapshot.docs.map((doc) {
    final data = doc.data();

    final location = DriveLocation(
      address: data['address'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );

    final status = DriveStatus(
      status: data['centerStatus'],
      startTime: data['startTime'],
      endTime: data['endTime'],
    );

    return DonationDriveModel(
      driveName: data['driveName'],
      seats: data['seats'],
      description: data['description'],
      driveStatus: status,
      location: location,
      image: data['image'],
    );
  }).toList();

  Provider.of<DataManagerProvider>(context, listen: false)
      .setAllDrives(driveList);
  
   // Print the length of the driveList
  print('Number of drives: ${driveList.length}');
}


Future<void> getAvailableCenters(BuildContext context)async {
  final result =
      await FirebaseFirestore.instance.collection('Available Centers').get();
  List<DonationCenterModel> availableList = [];

  for(var data in result.docs){
    DonationCenterInfo center = DonationCenterInfo(
      centerFullName: data['fullName'], 
      centerEmail: data['email'], 
      centerContact: data['contact'], 
      centerPassword: '', 
      role: 'D-Center', 
      centerId: data['centerId']);

    Location location = Location(
      address: data['address'], 
      latitude: data['latitude'], 
      longitude: data['longitude']);

    CenterStatus status = CenterStatus(
      status: data['centerStatus'], 
      startTime: data['startTim'], 
      endTime: data['endTime']);

    availableList.add(DonationCenterModel(
      centerName: data['centerName'], 
      center: center, 
      description: data['description'], 
      rating: double.parse("${data['rating']}"), 
      goodReviews: data['goodReviews'], 
      centerStatus: status, 
      location: location, 
      image: data['image'], 
      seats: data['seats']));

  }
  Provider.of<DataManagerProvider>(context,listen: false)
      .setAvailableCenters(availableList);
}

Future <void> getCenterProflie(email, BuildContext context) async{
  try{
    final userProfile = await FirebaseFirestore.instance
      .collection('Centers')
      .where('email', isEqualTo: email)
      .get();
    late DonationCenterModel centP;
    
    for (var data in userProfile.docs){
      DonationCenterInfo center = DonationCenterInfo(
        centerFullName: data['fullName'], 
        centerEmail: data['email'], 
        centerContact: data['contact'], 
        centerPassword: '', 
        role: 'D-Center', 
        centerId: data['centerId']);

      Location location = Location(
        address: data['address'], 
        latitude: data['latitude'], 
        longitude: data['longitude']);
      
      CenterStatus status = CenterStatus(
        status: data['centerStatus'], 
        startTime: data['startTime'], 
        endTime: data['endTime']);
      
      centP = DonationCenterModel(
        centerName: data['centerName'], 
        center: center, 
        seats: data['seats'], 
        description: data['description'], 
        rating: double.parse("${data['rating']}"), 
        goodReviews: data['goodReviews'], 
        centerStatus: status, 
        location: location, 
        image: data['image']);

    }
    Provider.of<DataManagerProvider>(context, listen: false)
        .setCenterProfile(centP);

  }catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
  }
}

Future<void> addCenterProfileData(BuildContext context)async {
 final dcenter = 
      Provider.of<DataManagerProvider>(context, listen: false).getDonationCenterDetails;
      try {
        await FirebaseFirestore.instance.collection('Centers').add({
          'centerId': dcenter.center.centerId,
          'fullName': dcenter.center.centerFullName,
          'centerName': dcenter.centerName,
          'email': dcenter.center.centerEmail,
          'contact': dcenter.center.centerContact,
          'description': dcenter.description,
          'seats': dcenter.seats,
          'rating': 0.0,
          'goodReviews': 0,
          'image': dcenter.image,
          'address': dcenter.location.address,
          'latitude': dcenter.location.latitude,
          'longitude': dcenter.location.longitude,
          'startTime': dcenter.centerStatus.startTime,
          'endTime': dcenter.centerStatus.endTime,
          'centerStatus': dcenter.centerStatus.status,
          
        });

        await FirebaseFirestore.instance.collection('Available Donation Centers').add({
          'centerId': dcenter.center.centerId,
          'fullName': dcenter.center.centerFullName,
          'centerName': dcenter.centerName,
          'email': dcenter.center.centerEmail,
          'contact': dcenter.center.centerContact,
          'description': dcenter.description,
          'seats': dcenter.seats,
          'rating': 0.0,
          'goodReviews': 0,
          'image': dcenter.image,
          'address': dcenter.location.address,
          'latitude': dcenter.location.latitude,
          'longitude': dcenter.location.longitude,
          'startTime': dcenter.centerStatus.startTime,
          'endTime': dcenter.centerStatus.endTime,
          'centerStatus': dcenter.centerStatus.status,
          
        });
      } catch (e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
}

Future<void> addDriveInfo(BuildContext context)async {
  final bloodDrive = 
  Provider.of<DataManagerProvider>(context, listen: false).getDriveDetails;

  try{
    await FirebaseFirestore.instance.collection('donation Drives').add({
      'driveId': bloodDrive.driveId,
      'driveName': bloodDrive.name,
      'driveTime': bloodDrive.time,
      'driveDate': bloodDrive.date,
      'description': bloodDrive.description,
      'imageUrl': bloodDrive.imageUrl

    });

  } catch (e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
}

Future<void> addDonationDriveInfo (BuildContext context) async{
  final dDrive =
  Provider.of<DataManagerProvider>(context, listen: false).getDonationDriveDetails;
  try{
    await FirebaseFirestore.instance.collection('donation Drives').add({
          'driveName': dDrive.driveName,
          'description': dDrive.description,
          'seats': dDrive.seats,
          'image': dDrive.image,
          'address': dDrive.location.address,
          'latitude': dDrive.location.latitude,
          'longitude': dDrive.location.longitude,
          'startTime': dDrive.driveStatus.startTime,
          'endTime': dDrive.driveStatus.endTime,
          'driveStatus': dDrive.driveStatus.status,

    });
    
  } catch (e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
}

//////////////////////Appointments
Future<void> setAppointment(AppointmentModel model)async {
await FirebaseFirestore.instance.collection('Appointments').add({
  'donorId': model.donorId,
    'centerId': model.centerId,
    'seatNo': model.seatNo,
    'startTime': model.startTime,
    'endTime': model.endTime,
    'centerName': model.centerName,
    'centerAddress': model.centerAddress,
    'centerContact': model.centerContact,
    'status': model.appointmentStatus,
});
}

Future<void> getAppointmentFromFirebase(
    String centerId, BuildContext context) async {
  final result = await FirebaseFirestore.instance
      .collection('Appointments')
      .where('centerId', isEqualTo: centerId)
      .get();
  List<AppointmentModel> app = [];
  for (var data in result.docs) {
    app.add(AppointmentModel(
        donorId: data['donorId'],
        centerId: data['centerId'],
        startTime: data['startTime'],
        endTime: data['endTime'],
        seatNo: data['seatNo'],
        appointmentStatus: data['status'],
        centerAddress: data['centerAddress'],
        centerName: data['centerName'],
        centerContact: data['centerContact']));
  }
  Provider.of<DataManagerProvider>(context, listen: false)
      .setAppointmentList(app);
}



Future<void> getMyAppointmentsFromFirebase(
  String myid, BuildContext context
) async {
  final result = await FirebaseFirestore.instance
      .collection('Appointments')
      .where('donorId', isEqualTo: myid)
      .get();
  List<AppointmentModel> app =[];
  for (var data in result.docs){
    app.add(AppointmentModel(
      centerId: data['centerId'], 
      startTime: data['startTime'], 
      endTime: data['endTime'], 
      centerName: data['centerName'], 
      centerAddress: data['centerAddress'], 
      centerContact: data['centerContact'], 
      appointmentStatus: data['status'], 
      donorId: data['donorId'], 
      seatNo: data['seatNo'],));
  }
  Provider.of<DataManagerProvider>(context, listen: false)
      .setMyAppointments(app);
  
}

Future <void> getMyAppointmentWithCenterFromFirebase(
  String id, BuildContext context) async{
    try{
      final userProfile = await FirebaseFirestore.instance
          .collection('Centers')
          .where('centerId', isEqualTo: id)
          .get();
      late DonationCenterModel centP;

      for (var data in userProfile.docs){
        DonationCenterInfo center = DonationCenterInfo(
          centerFullName: data['fullName'], 
          centerEmail: data['email'], 
          centerContact: data['contact'], 
          centerPassword: '', 
          role: 'Center', 
          centerId: data['centerId']);
        Location location = Location(
          address: data['address'], 
          latitude: data['latitude'], 
          longitude: data['longitude']);
        CenterStatus status = CenterStatus(
          status: data['centerStatus'], 
          startTime: data['startTime'], 
          endTime: data['endTme']);
        
        centP = DonationCenterModel(
          centerName: data['centerName'], 
          center: center, 
          seats: data['seats'], 
          description: data['description'], 
          rating: double.parse("${data['rating']}"), 
          goodReviews: data['goodReviews'], 
          centerStatus: status, 
          location: location, 
          image: data['image']);
      }
      Provider.of<DataManagerProvider>(context, listen: false)
          .setMyAppointmentWithCenter(centP);
    } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
  }
  }

Future<bool> validateContactNumber(String contactNumber) async {
  // Remove any leading/trailing spaces
  contactNumber = contactNumber.trim();

  // Replace any special characters like "+" or spaces
  contactNumber = contactNumber.replaceAll(RegExp('[^0-9]'), '');

  final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
      .collection('Donor')
      .where('contact', isEqualTo: '+$contactNumber')
      .get();

  return snapshot.docs.isNotEmpty;
}
