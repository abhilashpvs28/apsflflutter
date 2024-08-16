class EpCafCustomerInformation {
  final String aadharNumber;
  final String organisationName;
  final String organisationPerson;
  final String organisationCode;
  final String dateOfIncorporation;
  final int? selectedFrequencyId;
  final int? selectedentDepartmentNamesId;
  final int? custmr_id;
  EpCafCustomerInformation({
    required this.aadharNumber,
    required this.organisationName,
    required this.organisationPerson,
    required this.dateOfIncorporation,
    required this.selectedFrequencyId,
    required this.selectedentDepartmentNamesId,
    required this.organisationCode,
    required this.custmr_id,
  });
}
