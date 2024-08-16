class BoxExchangeModel {
  // final int caf_id;
  // final int caf_nu;
  // final String adhr_nu;
  // final String olt_ip_addr_tx;
  // final int olt_crd_nu;
  // final int olt_prt_nm;
  // final int olt_onu_id;
  // final String aaa_cd;
  // final String aghra_cd;
  // final int mbl_nu;
  // final String instl_addr1_tx;
  // final String instl_addr2_tx;
  // final String instl_lcly_tx;
  // final String instl_ara_tx;
  // final int instl_dstrct_id;
  // String? dstrt_nm;
  // final int instl_mndl_id;
  // String? mndl_nm;
  // final int instl_vlge_id;
  // String? vlge_nm;
  // final String mdlwe_sbscr_id;
  // final int lmo_agnt_id;
  // final String agnt_cd;
  // final int iptv_stpbx_id;
  // final int onu_stpbx_id;
  // final String iptv_srl_nu;
  // final String iptv_mac_addr_tx;
  // final String onu_srl_nu;
  // final String onu_mac_addr_tx;
  // final String lagId;
  // final String accessid;
  // final String termn_req_sts;
  // final String frst_nm;
  // final String lst_nm;
  // final String cstmr_nm;
  // final int crnt_pln_id;
  // final int stpbx_id;
  // final String accId;
  // final int caf_type_id;
  // final String sts_nm;
  // final int enty_sts_id;
  // dynamic sts_clr_cd_tx;
  // final int combobox_flag;




  final dynamic caf_id;
  final dynamic caf_nu;
  final dynamic adhr_nu;
  final dynamic olt_ip_addr_tx;
  final dynamic olt_crd_nu;
  final dynamic olt_prt_nm;
  final dynamic olt_onu_id;
  final dynamic aaa_cd;
  final dynamic aghra_cd;
  final dynamic mbl_nu;
  final dynamic instl_addr1_tx;
  final dynamic instl_addr2_tx;
  final dynamic instl_lcly_tx;
  final dynamic instl_ara_tx;
  final dynamic instl_dstrct_id;
  dynamic dstrt_nm;
  final dynamic instl_mndl_id;
  dynamic mndl_nm;
  final dynamic instl_vlge_id;
  dynamic vlge_nm;
  final dynamic mdlwe_sbscr_id;
  final dynamic lmo_agnt_id;
  final dynamic agnt_cd;
  final dynamic iptv_stpbx_id;
  final dynamic onu_stpbx_id;
  final dynamic iptv_srl_nu;
  final dynamic iptv_mac_addr_tx;
  final dynamic onu_srl_nu;
  final dynamic onu_mac_addr_tx;
  final dynamic lagId;
  final dynamic accessid;
  final dynamic termn_req_sts;
  final dynamic frst_nm;
  final dynamic lst_nm;
  final dynamic cstmr_nm;
  final dynamic crnt_pln_id;
  final dynamic stpbx_id;
  final dynamic accId;
  final dynamic caf_type_id;
  final dynamic sts_nm;
  final dynamic enty_sts_id;
  dynamic sts_clr_cd_tx;
  final dynamic combobox_flag;

   dynamic? loc_addr1_tx;
   dynamic? loc_addr2_tx;
   dynamic? loc_lcly_tx;
   dynamic? loc_ara_tx;

   dynamic? olt_prt_splt_tx;
   dynamic? cstmr_id;
   dynamic? splt_id;
   dynamic? mdl_dtls_tx;

  
  dynamic pack_expry;
  dynamic pack_strt;
  dynamic frqncy_id;
  dynamic frqncy_nm;
  dynamic loc_std_cd;
  dynamic sno;
  dynamic actvnDt;
  dynamic phne_nu;


   dynamic? trmnd;
   dynamic? trmnd_desc_tx;
   dynamic? isChecked;
   dynamic? srno;

  BoxExchangeModel({
    required this.caf_id, 
    required this.caf_nu, 
    required this.adhr_nu, 
    required this.olt_ip_addr_tx, 
    required this.olt_crd_nu, 
    required this.olt_prt_nm, 
    required this.olt_onu_id, 
    required this.aaa_cd, 
    required this.aghra_cd, 
    required this.mbl_nu, 
    required this.instl_addr1_tx, 
    required this.instl_addr2_tx, 
    required this.instl_lcly_tx, 
    required this.instl_ara_tx, 
    required this.instl_dstrct_id, 
    this.dstrt_nm, 
    required this.instl_mndl_id, 
    this.mndl_nm, 
    required this.instl_vlge_id, 
    this.vlge_nm, 
    required this.mdlwe_sbscr_id, 
    required this.lmo_agnt_id, 
    required this.agnt_cd, 
    required this.iptv_stpbx_id, 
    required this.onu_stpbx_id, 
    required this.iptv_srl_nu, 
    required this.iptv_mac_addr_tx, 
    required this.onu_srl_nu, 
    required this.onu_mac_addr_tx, 
    required this.lagId, 
    required this.accessid, 
    required this.termn_req_sts, 
    required this.frst_nm, 
    required this.lst_nm, 
    required this.cstmr_nm, 
    required this.crnt_pln_id, 
    required this.stpbx_id, 
    required this.accId, 
    required this.caf_type_id, 
    required this.sts_nm, 
    required this.enty_sts_id, 
    this.sts_clr_cd_tx, 
    required this.combobox_flag,
    this.loc_addr1_tx,
    this.loc_addr2_tx,
    this.loc_lcly_tx,
    this.loc_ara_tx,

    this.olt_prt_splt_tx,
    this.cstmr_id,    
    this.splt_id, 
    this.mdl_dtls_tx,

     this.pack_expry,
     this.pack_strt,
     this.frqncy_id,
     this.frqncy_nm,
     this.loc_std_cd,
     this.sno,
     this.actvnDt,
     this.phne_nu,

    this.trmnd,
    this.trmnd_desc_tx,

    this.isChecked,
    this.srno,


    });
 

 factory BoxExchangeModel.fromJson(Map<String,dynamic> json){
  return BoxExchangeModel(
    caf_id: json['caf_id'], 
    caf_nu: json['caf_nu'], 
    adhr_nu: json['adhr_nu'], 
    olt_ip_addr_tx: json['olt_ip_addr_tx'], 
    olt_crd_nu: json['olt_crd_nu'],
    olt_prt_nm: json['olt_prt_nm'], 
    olt_onu_id: json['olt_onu_id'], 
    aaa_cd: json['aaa_cd'], 
    aghra_cd: json['aghra_cd'], 
    mbl_nu: json['mbl_nu'], 
    instl_addr1_tx: json['instl_addr1_tx'], 
    instl_addr2_tx: json['instl_addr2_tx'], 
    instl_lcly_tx: json['instl_lcly_tx'], 
    instl_ara_tx: json['instl_ara_tx'], 
    instl_dstrct_id: json['instl_dstrct_id'], 
    dstrt_nm: json['dstrt_nm'],
    mndl_nm: json['mndl_nm'],
    vlge_nm: json['vlge_nm'],
    instl_mndl_id: json['instl_mndl_id'], 
    instl_vlge_id: json['instl_vlge_id'], 
    mdlwe_sbscr_id: json['mdlwe_sbscr_id'], 
    lmo_agnt_id: json['lmo_agnt_id'], 
    agnt_cd: json['agnt_cd'], 
    iptv_stpbx_id: json['iptv_stpbx_id'], 
    onu_stpbx_id: json['onu_stpbx_id'], 
    iptv_srl_nu: json['iptv_srl_nu'], 
    iptv_mac_addr_tx: json['iptv_mac_addr_tx'], 
    onu_srl_nu: json['onu_srl_nu'], 
    onu_mac_addr_tx: json['onu_mac_addr_tx'], 
    lagId: json['lagId'], 
    accessid: json['accessid'], 
    termn_req_sts: json['termn_req_sts'], 
    frst_nm: json['frst_nm'], 
    lst_nm: json['lst_nm'], 
    cstmr_nm: json['cstmr_nm'], 
    crnt_pln_id: json['crnt_pln_id'], 
    stpbx_id: json['stpbx_id'], 
    accId: json['accId'], 
    caf_type_id: json['caf_type_id'], 
    sts_nm: json['sts_nm'], 
    enty_sts_id: json['enty_sts_id'], 
    sts_clr_cd_tx: json['sts_clr_cd_tx'], 
    combobox_flag: json['combobox_flag'],
    loc_addr1_tx: json['loc_addr1_tx'], 
    loc_addr2_tx: json['loc_addr2_tx'], 
    loc_lcly_tx: json['loc_lcly_tx'], 
    loc_ara_tx: json['loc_ara_tx'], 

    olt_prt_splt_tx: json['olt_prt_splt_tx'],
    cstmr_id: json['cstmr_id'],
    splt_id: json['splt_id'],

    mdl_dtls_tx: json['mdl_dtls_tx'],
    
    pack_expry: json['pack_expry'],
    pack_strt: json['pack_strt'],
    frqncy_id: json['frqncy_id'],
    frqncy_nm: json['frqncy_nm'],
    loc_std_cd: json['loc_std_cd'],
    sno: json['sno'],
    actvnDt: json['actvnDt'],
    phne_nu: json['phne_nu'],

     trmnd: json['trmnd'],
     trmnd_desc_tx: json['trmnd_desc_tx'],
     isChecked: json['isChecked'],
     srno: json['srno'],

    );
 }
 
 


Map<String, dynamic> toJson() {
    return {
     actvnDt: actvnDt,
     adhr_nu:adhr_nu,
     caf_id: caf_id,
     caf_nu: caf_nu,
     caf_type_id: caf_type_id,
     cstmr_id: cstmr_id,
     cstmr_nm: cstmr_nm,
     frqncy_id: frqncy_id,
     frqncy_nm:frqncy_nm,
     frst_nm: frst_nm,
     iptv_srl_nu: iptv_srl_nu,
     isChecked: true,
     loc_std_cd: loc_std_cd,
     lst_nm: lst_nm,
     mbl_nu: mbl_nu,
     mdlwe_sbscr_id: mdlwe_sbscr_id,
     onu_srl_nu: onu_srl_nu,
     phne_nu: phne_nu,
     sno: sno,
     srno: 1.toString(),
     sts_clr_cd_tx: sts_clr_cd_tx,
     sts_nm: sts_nm,
     termn_req_sts: termn_req_sts,
     trmnd: "trmnd_rqst_in",
     trmnd_desc_tx: "fgvh",
    
};

}


 
 
 
}