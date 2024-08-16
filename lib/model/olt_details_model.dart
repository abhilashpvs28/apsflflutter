

class OltDetailsModel{
 final dynamic olt_id;
 final dynamic olt_nm;
 final dynamic olt_srl_nu;
 final dynamic olt_ip_addr_tx;
 final dynamic crd_id;
 final dynamic sbstn_id;
 final dynamic pop_id;

 final dynamic olt_prt_id;
 final dynamic olt_acs_nde_id;
 final dynamic olt_prt_nm;
 final dynamic sltsct;
 final dynamic solts;


 final dynamic olt_slt_id;
 final dynamic slt1_id;
 final dynamic slt2_id;
 final dynamic slt3_id;



 

OltDetailsModel({
  required this.olt_id,
  required this.olt_nm,
  required this.olt_srl_nu,
  required this.olt_ip_addr_tx,
  required this.crd_id,
  required this.sbstn_id,
  required this.pop_id,

  this.olt_prt_id,
  this.olt_acs_nde_id,
  this.olt_prt_nm,
  this.sltsct,
  this.solts,

  this.olt_slt_id,
  this.slt1_id,
  this.slt2_id,
  this.slt3_id,


});


factory OltDetailsModel.fromJson(Map<String,dynamic> json){
  return OltDetailsModel(
    olt_id: json['olt_id'],
    olt_nm: json['olt_nm'], 
    olt_srl_nu: json['olt_srl_nu'], 
    olt_ip_addr_tx: json['olt_ip_addr_tx'], 
    crd_id: json['crd_id'], 
    sbstn_id: json['sbstn_id'], 
    pop_id: json['pop_id'],

    olt_prt_id: json['olt_prt_id'],
    olt_acs_nde_id: json['olt_acs_nde_id'],
    olt_prt_nm: json['olt_prt_nm'],
    sltsct: json['sltsct'],
    solts: json['solts'],


    olt_slt_id: json['olt_slt_id'],
    slt1_id: json['slt1_id'],
    slt2_id: json['slt2_id'],
    slt3_id: json['slt3_id'],
    
    );
}

}