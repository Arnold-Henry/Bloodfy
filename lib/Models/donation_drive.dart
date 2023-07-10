
class DonationDriveModel {
  String driveName;
  String seats;
  String description;
  String image;
  DriveLocation location;
  DriveStatus driveStatus;

  DonationDriveModel(
      {required this.driveName,
      required this.seats,
      required this.description,
      required this.driveStatus,
      required this.location,
      required this.image});
}

class DriveStatus {
  final String startTime;
  final String endTime;
  final String status;

  DriveStatus({
    required this.status,
    required this.startTime,
    required this.endTime,
  });
}

class DriveLocation {
  final String address;
  final double latitude;
  final double longitude;

  DriveLocation({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}