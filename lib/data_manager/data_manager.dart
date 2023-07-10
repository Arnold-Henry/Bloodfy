import 'dart:math';

import 'package:bloodfy/Models/donors_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../Models/appointment_model.dart';
import '../Models/blood_donation_drive.dart';
import '../Models/data.dart';
import '../Models/donation_center_model.dart';
import '../Models/donation_drive.dart';

class DataManagerProvider extends ChangeNotifier {
  bool isLoading = false;

  late DonationCenterModel centerProfile = dCenterModel();

  DonationCenterModel dCenterModel() {
    return DonationCenterModel(
      centerName: '',
      center: DonationCenterInfo(
        centerFullName: '',
        centerEmail: '',
        centerContact: '',
        centerPassword: '',
        role: '',
        centerId: '',
      ),
      seats: '',
      description: '',
      rating: 0.0,
      goodReviews: 0,
      centerStatus: CenterStatus(
        startTime: '',
        endTime: '',
        status: '',
      ),
      location: Location(
        address: '',
        latitude: 0.0,
        longitude: 0.0,
      ),
      image: '',
    );
  }

  late DonationCenterInfo donationCenterInfo;

  late List<DonationCenterModel> allCenters = [];

  late List<DonationDriveModel> allDrives = [];

  late List<BloodDonationDrive> drives = [];

  late List<DonationCenterModel> availableCenters = [];

  late DonationCenterModel dCenterCompleteData;

  late DonationDriveModel donationDriveData;

  late BloodDonationDrive driveData;

  List<DonationCenterModel> searchList = [];

  List<AppointmentModel> appointmentList = [];

  late List<AppointmentModel> myAppointments = [];

  late DonationCenterModel myAppointmentWithCenter;

  late DonorInfo donorProfile = dInfo();

  DonorInfo dInfo() {
    return DonorInfo(
        donorId: '',
        donorFullName: '',
        donorEmail: '',
        donorContact: '',
        role: '',
        donorPassword: '');
  }

  late bool isSearching = false;

  void setLoadingStatus(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  bool get loading => isLoading;

  void setDonorProfile(DonorInfo user) {
    donorProfile = user;
    notifyListeners();
  }

  DonorInfo get currentUser => donorProfile;

void setCenterProfile(DonationCenterModel profile) {
  centerProfile = profile;
  notifyListeners();
}

  DonationCenterModel get getCenterProfile => centerProfile;

  void setAllCenters(List<DonationCenterModel> driveMapList) {
    allCenters = driveMapList;
    notifyListeners();
  }

    void searchCenters(String query) {
    if (query.isEmpty) {
      // If the query is empty, clear the searchList and exit search mode
      searchList.clear();
      isSearching = false;
    } else {
      // Perform the search based on the query
      searchList = allCenters.where((center) {
        final centerName = center.centerName.toLowerCase();
        final searchQuery = query.toLowerCase();
        return centerName.contains(searchQuery);
      }).toList();
      isSearching = true;
    }

    notifyListeners(); // Notify listeners of the data change
  }

  List<DonationCenterModel> get getAllCenters => allCenters;

  void setAllDrives(List<DonationDriveModel> driveMapList) {
    allDrives = driveMapList;
    notifyListeners();
  }

  List<DonationDriveModel> get getAllDrives => allDrives;

  void setDrives(List<BloodDonationDrive> driveMapList) {
    drives = driveMapList;
    notifyListeners();
  }

  List<BloodDonationDrive> get getDrives => drives;

  void setAvailableCenters(List<DonationCenterModel> availableCentersList) {
    availableCenters = availableCentersList;
    notifyListeners();
  }

  List<DonationCenterModel> get getAvailableCenters => availableCenters;

  void getSearch(String searchKey) {
    allCenters.forEach((element) {
      if (element.centerName
              .toLowerCase()
              .startsWith(searchKey.toLowerCase()) ||
          element.centerName.startsWith(searchKey.toLowerCase())) {
        searhResult(element);
      }
    });
  }

  void setIsSearching(bool value) {
    isSearching = value;
    notifyListeners();
  }

  bool get searchingStart => isSearching;

  void searhResult(DonationCenterModel donationCenterModel) {
    searchList.add(donationCenterModel);
    notifyListeners();
  }

  List<DonationCenterModel> get getSearchList => searchList;

  void setDonationCenterInfo(
      String id, String name, String email, String contact) {
    donationCenterInfo = DonationCenterInfo(
        centerId: id,
        centerFullName: name,
        centerEmail: email,
        centerContact: contact,
        role: 'D-Center',
        centerPassword: '');
    notifyListeners();
  }

 void setBDDriveInfo (
  String driveId,
  String name,
  String location,
  String date,
  String time,
  String imageUrl,
  String description,
 ){
  driveData = BloodDonationDrive(
    name: name, 
    location: location, 
    date: date, 
    time: time, 
    imageUrl: imageUrl,
    description: description, 
    driveId: driveId);
    notifyListeners();
 }

 BloodDonationDrive get getDriveDetails => driveData;
 
  void setDonationDriveInfo(
      String driveName,
      String description,
      String seats,
      String address,
      double latitude,
      double longitude,
      String startTime,
      String endTime

  ){
    DriveLocation driveLocation =DriveLocation(address: address, latitude: latitude, longitude: longitude);
    DriveStatus driveStatus = DriveStatus(status: 'Open', startTime: startTime, endTime: endTime);
    final random = Random();
    String index = urls[random.nextInt(urls.length)];
    donationDriveData = DonationDriveModel(
      driveName: driveName,
      seats: seats, 
      description: description, 
      driveStatus: driveStatus, 
      location: driveLocation, 
      image: index);
    notifyListeners();

  }

  DonationDriveModel get getDonationDriveDetails => donationDriveData;

  void setDCenterInfo(
      String centerName,
      String description,
      String seats,
      String address,
      double latitude,
      double longitude,
      String startTime,
      String endTime) {
    Location location =
        Location(address: address, latitude: latitude, longitude: longitude);
    CenterStatus status =
        CenterStatus(status: 'Open', startTime: startTime, endTime: endTime);
    final random = Random();
    String index = urls[random.nextInt(urls.length)];
    dCenterCompleteData = DonationCenterModel(
      centerName: centerName,
      center: donationCenterInfo,
      description: description,
      rating: 0.0,
      goodReviews: 0,
      centerStatus: status,
      location: location,
      image: index,
      seats: seats,
    );
    notifyListeners();
  }

  DonationCenterModel get getDonationCenterDetails => dCenterCompleteData;

  ///////////////Appointment
 void setAppointmentList(List<AppointmentModel> model) {
    print('Setting appointment list: $model');
    appointmentList = model;
    notifyListeners();
  }


  void setMyAppointments(List<AppointmentModel> model) {
    myAppointments = model;
    notifyListeners();
  }

  void setMyAppointmentWithCenter(DonationCenterModel donationCenterModel) {
    myAppointmentWithCenter = donationCenterModel;
    notifyListeners();
  }
}
