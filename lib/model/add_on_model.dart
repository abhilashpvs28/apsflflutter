class AddOnModel{
  final dynamic? pckge_nm;
  final dynamic? pkge_prche_id;
  final dynamic? caf_id;
  final dynamic? pckge_id;
  final dynamic? srvcpk_id;
  final dynamic? efcte_dt;
  final dynamic? expry_dt;
  final dynamic? chrge_at;
  final dynamic? gst_at;
  final dynamic? srvc_at;
  final dynamic? swtch_at;
  final dynamic? ksn_at;
  final dynamic? entrn_at;
  final dynamic? crnt_sts_in;
  final dynamic? prpd_in;
  final dynamic? rnble_in;
  final dynamic? cycle_strt_dt;
  final dynamic? cycle_end_dt;
  final dynamic? advance_recharge;
  final dynamic? caf_date;
  final dynamic? cycle_at;

  final dynamic? lst_pymnt_ts;
  final dynamic? lst_pymnt_at;
  final dynamic? ato_rnw_in;
  final dynamic? updte_usr_id;
  final dynamic? sbscrptn_req_in;
  final dynamic? sbscrptn_req_ts;
  final dynamic? aprvl_usr_id;
  final dynamic? aprvl_in;
  final dynamic? aprvl_ts;
  final dynamic? cmnt_txt;
  final dynamic? dscnt_in;
  final dynamic? dscnt_ts;
  final dynamic? dscnt_srce_id;
  final dynamic? src_id;
  final dynamic? crte_usr_id;
  final dynamic? rjct_in;
  final dynamic? rjct_ts;
  final dynamic? rjct_usr_id;
  final dynamic? fst_prpd_dne_in;
  final dynamic? fst_prpd_invce_id;
  final dynamic? spnd_in;
  final dynamic? spnd_ts;
  final dynamic? a_in;
  final dynamic? d_ts;
  final dynamic? u_ts;
  final dynamic? i_ts;



  AddOnModel({
    this.pckge_nm,
    this.pkge_prche_id,
    this.caf_id,
    this.pckge_id,
    this.srvcpk_id,
    this.efcte_dt,
    this.expry_dt,
    this.chrge_at,
    this.gst_at,
    this.srvc_at,
    this.swtch_at,
    this.ksn_at,
    this.entrn_at,
    this.crnt_sts_in,
    this.prpd_in,
    this.rnble_in,
    this.cycle_strt_dt,
    this.cycle_end_dt,
    this.advance_recharge,
    this.caf_date,
    this.cycle_at,
    this.lst_pymnt_ts,
    this.lst_pymnt_at,
    this.ato_rnw_in,
    this.updte_usr_id,
    this.sbscrptn_req_in,
    this.sbscrptn_req_ts,
    this.aprvl_usr_id,
    this.aprvl_in,
    this.aprvl_ts,
    this.cmnt_txt,
    this.dscnt_in,
    this.dscnt_ts,
    this.dscnt_srce_id,
    this.src_id,
    this.crte_usr_id,
    this.rjct_in,
    this.rjct_ts,
    this.rjct_usr_id,
    this.fst_prpd_dne_in,
    this.fst_prpd_invce_id,
    this.spnd_in,
    this.spnd_ts,
    this.a_in,
    this.d_ts,
    this.u_ts,
    this.i_ts,
  });


  factory AddOnModel.fromJson(Map<String, dynamic> json) {
    return AddOnModel(
      pckge_nm: json['pckge_nm'],
      pkge_prche_id: json['pkge_prche_id'],
      caf_id: json['caf_id'],
      pckge_id: json['pckge_id'],
      srvcpk_id: json['srvcpk_id'],
      efcte_dt: json['efcte_dt'],
      expry_dt: json['expry_dt'],
      chrge_at: json['chrge_at'],
      gst_at: json['gst_at'],
      srvc_at: json['srvc_at'],
      swtch_at: json['swtch_at'],
      ksn_at: json['ksn_at'],
      entrn_at: json['entrn_at'],
      crnt_sts_in: json['crnt_sts_in'],
      prpd_in: json['prpd_in'],
      rnble_in: json['rnble_in'],
      cycle_strt_dt: json['cycle_strt_dt'],
      cycle_end_dt: json['cycle_end_dt'],
      advance_recharge: json['advance_recharge'],
      caf_date: json['caf_date'],
      cycle_at: json['cycle_at'],
      lst_pymnt_ts: json['lst_pymnt_ts'],
      lst_pymnt_at: json['lst_pymnt_at'],
      ato_rnw_in: json['ato_rnw_in'],
      updte_usr_id: json['updte_usr_id'],
      sbscrptn_req_in: json['sbscrptn_req_in'],
      sbscrptn_req_ts: json['sbscrptn_req_ts'],
      aprvl_usr_id: json['aprvl_usr_id'],
      aprvl_in: json['aprvl_in'],
      aprvl_ts: json['aprvl_ts'],
      cmnt_txt: json['cmnt_txt'],
      dscnt_in: json['dscnt_in'],
      dscnt_ts: json['dscnt_ts'],
      dscnt_srce_id: json['dscnt_srce_id'],
      src_id: json['src_id'],
      crte_usr_id: json['crte_usr_id'],
      rjct_in: json['rjct_in'],
      rjct_ts: json['rjct_ts'],
      rjct_usr_id: json['rjct_usr_id'],
      fst_prpd_dne_in: json['fst_prpd_dne_in'],
      fst_prpd_invce_id: json['fst_prpd_invce_id'],
      spnd_in: json['spnd_in'],
      spnd_ts: json['spnd_ts'],
      a_in: json['a_in'],
      d_ts: json['d_ts'],
      u_ts: json['u_ts'],
      i_ts: json['i_ts'],
    );
  }

}