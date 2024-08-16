class CustomerInformation {
  final String aadharNumber;
  final String firstName;
  final String middleName;
  final String surname;
  final String guardianName;
  final String dateOfBirth;
  final String email;
  final int? selectedFrequencyId;
  final int selectedGenderIndex;
  // final String gender;

  CustomerInformation({
    required this.aadharNumber,
    required this.firstName,
    required this.middleName,
    required this.surname,
    required this.guardianName,
    required this.dateOfBirth,
    required this.email,
    required this.selectedFrequencyId,
    required this.selectedGenderIndex,
    // required this.gender,
  });
}
