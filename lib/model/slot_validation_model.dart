class SlotValidationModel{
  final dynamic splitidoriginal;
  final dynamic slidoriginal;
  final dynamic onuorginal;
  final dynamic spone;
  final dynamic sptwo;
  final dynamic spthree;

  dynamic? splt1_nu;
  dynamic? splt2_nu;
  dynamic? splt3_nu;

  dynamic? splt_id;
  dynamic? olt_slt_id;
  dynamic? onu_id;
 
  


  SlotValidationModel({
    required this.splitidoriginal,
    required this.slidoriginal,
    required this.onuorginal,
    required this.spone,
    required this.sptwo,
    required this.spthree,

    this.splt1_nu,
    this.splt2_nu,
    this.splt3_nu,

    this.splt_id,
    this.olt_slt_id,
    this.onu_id,
   
  });

  factory SlotValidationModel.fromJson(Map<String,dynamic> json){
    return SlotValidationModel(
      splitidoriginal: json['splitidoriginal'], 
      slidoriginal: json['slidoriginal'], 
      onuorginal: json['onuorginal'], 
      spone: json['spone'], 
      sptwo: json['sptwo'], 
      spthree: json['spthree'], 

      splt1_nu: json['splt1_nu'],
      splt2_nu: json['splt2_nu'],
      splt3_nu: json['splt3_nu'],

      splt_id: json['splt_id'],
      olt_slt_id: json['olt_slt_id'],
      onu_id: json['onu_id'],
      

      );
  }


}