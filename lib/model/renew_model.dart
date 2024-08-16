class RenewModel {
  final dynamic caf_id;
  final dynamic pckge_nm;
  final dynamic cycle_end_dt;
  final dynamic caf_nu;
  final dynamic cstmr_id;
  final dynamic adhr_nu;
  final dynamic Renewed_On;
  final dynamic mbl_nu;
  final dynamic instl_addr1_tx;
  final dynamic instl_addr2_tx;
  final dynamic instl_lcly_tx;
  final dynamic instl_ara_tx;
  final dynamic instl_dstrct_id;
  final dynamic instl_mndl_id;
  final dynamic instl_vlge_id;
  final dynamic mdlwe_sbscr_id;
  final dynamic lmo_agnt_id;
  final dynamic agnt_cd;
  final dynamic spnd_dt;
  final dynamic termn_req_sts;
  final dynamic spnd_count;
  final dynamic crnt_pln_id;
  final dynamic caf_mac_addr_tx;
  final dynamic aaa_cd;
  final dynamic frst_nm;
  final dynamic lst_nm;
  final dynamic cstmr_nm;
  final dynamic aghra_cd;
  final dynamic phne_nu;
  final dynamic caf_type_id;
  final dynamic olt_prt_nm;
  final dynamic olt_onu_id;
  final dynamic olt_ip_addr_tx;
  final dynamic olt_crd_nu;
  final dynamic sts_nm;
  final dynamic enty_sts_id;
  final dynamic sts_clr_cd_tx;
  final dynamic stpbx_id;
  final dynamic mac_addr_cd;
  final dynamic onu_srl_nu;
  final dynamic iptv_srl_nu;
  final dynamic actvnDt;

  dynamic pack_expry;
  dynamic pack_strt;
  dynamic frqncy_id;
  dynamic frqncy_nm;
  dynamic loc_std_cd;
  dynamic sno;
  


  RenewModel({
    required this.caf_id,
    required this.pckge_nm,
    required this.cycle_end_dt,
    required this.caf_nu,
    required this.cstmr_id,
    required this.adhr_nu,
    required this.Renewed_On,
    required this.mbl_nu,
     this.instl_addr1_tx,
     this.instl_addr2_tx,
     this.instl_lcly_tx,
     this.instl_ara_tx,
     this.instl_dstrct_id,
     this.instl_mndl_id,
     this.instl_vlge_id,
    required this.mdlwe_sbscr_id,
     this.lmo_agnt_id,
     this.agnt_cd,
     this.spnd_dt,
     this.termn_req_sts,
     this.spnd_count,
     this.crnt_pln_id,
     this.caf_mac_addr_tx,
     this.aaa_cd,
     this.frst_nm,
     this.lst_nm,
     this.cstmr_nm,
     this.aghra_cd,
     this.phne_nu,
     this.caf_type_id,
     this.olt_prt_nm,
     this.olt_onu_id,
     this.olt_ip_addr_tx,
     this.olt_crd_nu,
     this.sts_nm,
     this.enty_sts_id,
     this.sts_clr_cd_tx,
     this.stpbx_id,
     this.mac_addr_cd,
     this.onu_srl_nu,
     this.iptv_srl_nu,
     this.actvnDt,

     this.pack_expry,
     this.pack_strt,
     this.frqncy_id,
     this.frqncy_nm,
     this.loc_std_cd,
     this.sno,


  });

  factory RenewModel.fromJson(Map<String, dynamic> json) {
    return RenewModel(
      caf_id: json['caf_id'],
      pckge_nm: json['pckge_nm'] ?? '',
      cycle_end_dt: json['cycle_end_dt'] ?? '',
      caf_nu: json['caf_nu'],
      cstmr_id: json['cstmr_id'],
      adhr_nu: json['adhr_nu'] ?? '',
      Renewed_On: json['Renewed_On'] ?? '',
      mbl_nu: json['mbl_nu'].toString(), // convert number to string
      instl_addr1_tx: json['instl_addr1_tx'] ?? '',
      instl_addr2_tx: json['instl_addr2_tx'] ?? '',
      instl_lcly_tx: json['instl_lcly_tx'] ?? '',
      instl_ara_tx: json['instl_ara_tx'] ?? '',
      instl_dstrct_id: json['instl_dstrct_id'],
      instl_mndl_id: json['instl_mndl_id'],
      instl_vlge_id: json['instl_vlge_id'],
      mdlwe_sbscr_id: json['mdlwe_sbscr_id'] ?? '',
      lmo_agnt_id: json['lmo_agnt_id'],
      agnt_cd: json['agnt_cd'] ?? '',
      spnd_dt: json['spnd_dt'] ?? '',
      termn_req_sts: json['termn_req_sts'],
      spnd_count: json['spnd_count'],
      crnt_pln_id: json['crnt_pln_id'],
      caf_mac_addr_tx: json['caf_mac_addr_tx'] ?? '',
      aaa_cd: json['aaa_cd'] ?? '',
      frst_nm: json['frst_nm'] ?? '',
      lst_nm: json['lst_nm'] ?? '',
      cstmr_nm: json['cstmr_nm'] ?? '',
      aghra_cd: json['aghra_cd'] ?? '',
      phne_nu: json['phne_nu'] ?? '',
      caf_type_id: json['caf_type_id'],
      olt_prt_nm: json['olt_prt_nm'],
      olt_onu_id: json['olt_onu_id'],
      olt_ip_addr_tx: json['olt_ip_addr_tx'] ?? '',
      olt_crd_nu: json['olt_crd_nu'],
      sts_nm: json['sts_nm'] ?? '',
      enty_sts_id: json['enty_sts_id'],
      sts_clr_cd_tx: json['sts_clr_cd_tx'] ?? '',
      stpbx_id: json['stpbx_id'],
      mac_addr_cd: json['mac_addr_cd'] ?? '',
      onu_srl_nu: json['onu_srl_nu'] ?? '',
      iptv_srl_nu: json['iptv_srl_nu'] ?? '',
      actvnDt: json['actvnDt'] ?? '',

      pack_expry: json['pack_expry'],
      pack_strt: json['pack_strt'],
      frqncy_id: json['frqncy_id'],
      frqncy_nm: json['frqncy_nm'],
      loc_std_cd: json['loc_std_cd'],
      sno: json['sno'],

    );
  }

  // @override
  // String toString() {
  //   return 'RenewModel(
  //   cstmr_nm: $cstmr_nm, 
  //   caf_id: $caf_id, 
  //   pckge_nm: $pckge_nm, 
  //   cycle_end_dt: $cycle_end_dt, 
  //   caf_nu: $caf_nu, 
  //   cstmr_id: $cstmr_id, 
  //   adhr_nu: $adhr_nu, 
  //   Renewed_On: $Renewed_On, 
  //   mbl_nu: $mbl_nu, 
  //   instl_addr1_tx: $instl_addr1_tx, 
  //   instl_addr2_tx: $instl_addr2_tx, 
  //   instl_lcly_tx: $instl_lcly_tx, 
  //   instl_ara_tx: $instl_ara_tx, 
  //   instl_dstrct_id: $instl_dstrct_id, 
  //   instl_mndl_id: $instl_mndl_id, 
  //   instl_vlge_id: $instl_vlge_id, 
  //   mdlwe_sbscr_id: $mdlwe_sbscr_id, 
  //   lmo_agnt_id: $lmo_agnt_id, 
  //   agnt_cd: $agnt_cd, 
  //   spnd_dt: $spnd_dt, 
  //   termn_req_sts: $termn_req_sts, 
  //   spnd_count: $spnd_count, 
  //   crnt_pln_id: $crnt_pln_id, 
  //   caf_mac_addr_tx: $caf_mac_addr_tx, 
  //   aaa_cd: $aaa_cd, frst_nm: $frst_nm, 
  //   lst_nm: $lst_nm, aghra_cd: $aghra_cd, 
  //   phne_nu: $phne_nu, 
  //   caf_type_id: $caf_type_id, 
  //   olt_prt_nm: $olt_prt_nm, 
  //   olt_onu_id: $olt_onu_id, 
  //   olt_ip_addr_tx: $olt_ip_addr_tx, 
  //   olt_crd_nu: $olt_crd_nu, 
  //   sts_nm: $sts_nm, 
  //   enty_sts_id: $enty_sts_id, 
  //   sts_clr_cd_tx: $sts_clr_cd_tx, 
  //   stpbx_id: $stpbx_id, 
  //   mac_addr_cd: $mac_addr_cd, 
  //   onu_srl_nu: $onu_srl_nu, 
  //   iptv_srl_nu: $iptv_srl_nu, 
  //   actvnDt: $actvnDt)';

 // }
}
