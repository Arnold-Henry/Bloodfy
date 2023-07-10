import 'package:cloud_firestore/cloud_firestore.dart';

class DonationCenterModel {
  String centerName;
  DonationCenterInfo center;
  String seats;
  String description;
  double rating;
  int goodReviews;
  String image;
  Location location;
  CenterStatus centerStatus;

  DonationCenterModel(
      {required this.centerName,
      required this.center,
      required this.seats,
      required this.description,
      required this.rating,
      required this.goodReviews,
      required this.centerStatus,
      required this.location,
      required this.image});

  static fromDocument(DocumentSnapshot<Object?> doc) {}
}

class CenterStatus {
  final String startTime;
  final String endTime;
  final String status;

  CenterStatus({
    required this.status,
    required this.startTime,
    required this.endTime,
  });
}

class Location {
  final String address;
  final double latitude;
  final double longitude;

  Location({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class DonationCenterInfo {
  final String centerId;
  final String centerFullName;
  final String centerEmail;
  final String centerContact;
  final String centerPassword;
  final String role;

  DonationCenterInfo({
    required this.centerFullName,
    required this.centerEmail,
    required this.centerContact,
    required this.centerPassword,
    required this.role,
    required this.centerId,
  });
}
