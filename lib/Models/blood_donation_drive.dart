import 'package:cloud_firestore/cloud_firestore.dart';

class BloodDonationDrive {
  String driveId;
  String name;
  String location;
  String date;
  String time;
  String imageUrl;
  String description;

  BloodDonationDrive({
    required this.driveId,
    required this.name,
    required this.location,
    required this.date,
    required this.time,
    required this.imageUrl,
    required this.description,
  });

  factory BloodDonationDrive.fromSnapshot(DocumentSnapshot<Object?> document) {
    final data = document.data()! as Map<String, dynamic>;
    return BloodDonationDrive(
      driveId: document.id,
      name: data['driveName'],
      location: data['driveLocation'],
      date: data['driveDate'],
      time: data['driveTime'],
      imageUrl: data['imageUrl'],
      description: data['description'],
    );
  }
}
