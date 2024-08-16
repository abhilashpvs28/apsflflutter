class EpCafInstallationAddress {
  final String buildingName;
  final String address;
  final String gpeDeviceLocation;
  final String area;
  final String alternateMobile;
  final String pincode;
  final String mobile;
  final String stdCode;
  final String enterLandline;

  final int? district;
  final String? mandalName; // Add this line
  // final int mandal;
  final int? popid;
  final String? popname;
  final String? villagename;
  final int? villageorCity;
  final int? villagecode;

  EpCafInstallationAddress({
    required this.buildingName,
    required this.address,
    required this.gpeDeviceLocation,
    required this.area,
    required this.alternateMobile,
    required this.pincode,
    required this.mobile,
    required this.stdCode,
    required this.enterLandline,
    required this.popname,
    required this.popid,
    required this.villageorCity,
    required this.district,
    this.mandalName, // Add this line
    required this.villagecode,
    required this.villagename,
    // required this.mandal,
  });
}
