class AppointmentModel{
   final String donorId;
   final String centerId;
   final String startTime;
   final String endTime;
   final String centerName;
   final String centerAddress;
   final String centerContact;
   final String appointmentStatus;
   final int seatNo;

   const AppointmentModel({
    required this.centerId, 
    required this.startTime, 
    required this.endTime, 
    required this.centerName, 
    required this.centerAddress, 
    required this.centerContact, 
    required this.appointmentStatus, 
    required this.donorId,
    required this.seatNo,
   });
}