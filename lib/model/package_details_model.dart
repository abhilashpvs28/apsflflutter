

class PackageDetailsModel{
  // final int old_pack_id;
  // final int cpe_chrge;

  // final int package_id;
  // final int lckn_dys_ct;
  // final String package_name;
  // final double cust_price;
  // final double lco_price;
  // final double pack_tax;
  // final int ttl_cst9;
  // final String created_at;
  // final int cpe_charge;
  // String? pckge_dscn_tx;
  // final String tot_chrge9;
  // final String tot_gst_at9;
  // final String ttl_cst;


 final dynamic package_id;
  final dynamic lckn_dys_ct;
  final dynamic package_name;
  final dynamic cust_price;
  final dynamic lco_price;
  final dynamic pack_tax;
  final dynamic ttl_cst9;
  final dynamic created_at;
  final dynamic cpe_charge;
  dynamic? pckge_dscn_tx;
  final dynamic tot_chrge9;
  final dynamic tot_gst_at9;
  final dynamic ttl_cst;







  // final dynamic ID;
  // final dynamic HBasic_HMini;
  // final dynamic Home_Essential;
  // final dynamic Home_Premium;
  // final dynamic base_pack;
  // final dynamic a_in;
  // final dynamic u_ts;
  // final dynamic i_ts;

  PackageDetailsModel({
    // required this.old_pack_id,
    // required this.cpe_chrge,

     this.package_id,
     this.lckn_dys_ct,
     this.package_name,
    this.cust_price,
    this.lco_price,
    this.pack_tax,
    this.ttl_cst9,
     this.created_at,
     this.cpe_charge,
    this.pckge_dscn_tx,
     this.tot_chrge9,
     this.tot_gst_at9,
    this.ttl_cst,

    // required this.ID,
    // required this.HBasic_HMini,
    // required this.Home_Essential,
    // required this.Home_Premium,
    // required this.base_pack,
    // required this.a_in,
    // required this.u_ts,
    // required this.i_ts,
  });


  factory PackageDetailsModel.fromJson(Map<String,dynamic> json){
    return PackageDetailsModel(
      // old_pack_id: json['old_pack_id'],
      // cpe_chrge: json['cpe_chrge'],

      package_id: json['package_id'] ,
      lckn_dys_ct: json['lckn_dys_ct'] ,         
      package_name: json['package_name'], 
      cust_price: json['cust_price'], 
      lco_price: json['lco_price'],
      pack_tax: json['pack_tax'], 
      ttl_cst9: json['ttl_cst9'] , 
      created_at: json['created_at'] , 
      cpe_charge: json['cpe_charge'] , 
      pckge_dscn_tx: json['pckge_dscn_tx'] ,
      tot_chrge9: json['tot_chrge9'], 
      tot_gst_at9: json['tot_gst_at9'] , 
      ttl_cst: json['ttl_cst'] , 

      // ID: json['ID'], 
      // HBasic_HMini: json['HBasic_HMini'], 
      // Home_Essential: json['Home_Essential'], 
      // Home_Premium: json['Home_Premium'], 
      // base_pack: json['base_pack'], 
      // a_in: json['a_in'], 
      // u_ts: json['u_ts'], 
      // i_ts: json['i_ts']
      
      );
  }




  Map<String, dynamic> toJson() {
    return {
      'package_id': package_id,
      'lckn_dys_ct': lckn_dys_ct,
      'package_name': package_name,
      'cust_price': cust_price,
      'lco_price': lco_price,
      'pack_tax': pack_tax,
      'ttl_cst': ttl_cst,
      'created_at': created_at,
      'cpe_charge': cpe_charge,
      'pckge_dscn_tx': pckge_dscn_tx,
      'tot_chrge9': tot_chrge9,
      'tot_gst_at9': tot_gst_at9,
      'ttl_cst9': ttl_cst9,
    };
  }



}