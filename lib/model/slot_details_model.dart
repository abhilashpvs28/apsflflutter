class SlotDetailsModel{
  final dynamic splt_id;
  final dynamic olt_slt_id;
  final dynamic onu_id;
  final dynamic splt1_nu;
  final dynamic splt2_nu;
  final dynamic splt3_nu;
  final dynamic caf_id;
  final dynamic crte_usr_id;
  final dynamic updte_usr_id;
  final dynamic a_in;
  final dynamic d_ts;
  final dynamic u_ts;
  final dynamic i_ts;


  SlotDetailsModel({
    required this.splt_id,
    required this.olt_slt_id,
    required this.onu_id,
    required this.splt1_nu,
    required this.splt2_nu,
    required this.splt3_nu,
    required this.caf_id,
    required this.crte_usr_id,
    required this.updte_usr_id,
    required this.a_in,
    required this.d_ts,
    required this.u_ts,
    required this.i_ts,

  });

  factory SlotDetailsModel.fromJson(Map<String,dynamic> json){
    return SlotDetailsModel(
      splt_id: json['splt_id'], 
      olt_slt_id: json['olt_slt_id'], 
      onu_id: json['onu_id'], 
      splt1_nu: json['splt1_nu'], 
      splt2_nu: json['splt2_nu'], 
      splt3_nu: json['splt3_nu'], 
      caf_id: json['caf_id'], 
      crte_usr_id: json['crte_usr_id'], 
      updte_usr_id: json['updte_usr_id'], 
      a_in: json['a_in'], 
      d_ts: json['d_ts'], 
      u_ts: json['u_ts'], 
      i_ts: json['i_ts'],

      );
  }


}