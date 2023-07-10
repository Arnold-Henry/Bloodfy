class DonorInfo {
  final String donorId;
  final String donorFullName;
  final String donorEmail;
  final String donorContact;
  final String donorPassword;
  final String role;

  DonorInfo(
      {required this.donorId,
      required this.donorFullName,
      required this.donorEmail,
      required this.donorContact,
      required this.role,
      required this.donorPassword});
}