

class SubmitTerminationModel{

   dynamic? actvnDt;
   dynamic? adhr_nu;
   dynamic? caf_id;
   dynamic? caf_nu;
   dynamic? caf_type_id;
   dynamic? cstmr_id;
   dynamic? cstmr_nm;
   dynamic? frqncy_id;
   dynamic? frqncy_nm;
   dynamic? frst_nm;
   dynamic? iptv_srl_nu;
   dynamic? isChecked;
   dynamic? loc_std_cd;
   dynamic? lst_nm;
   dynamic? mbl_nu;
   dynamic? mdlwe_sbscr_id;
   dynamic? onu_srl_nu;
   dynamic? phne_nu;
   dynamic? sno;
   dynamic? srno;
   dynamic? sts_clr_cd_tx;
   dynamic? sts_nm;
   dynamic? termn_req_sts;
   dynamic? trmnd;
   dynamic? trmnd_desc_tx;
  

  SubmitTerminationModel( {
    this.actvnDt,
    this.adhr_nu,
    this.caf_id,
    this.caf_nu,
    this.caf_type_id,
    this.cstmr_id,
    this.cstmr_nm,
    this.frqncy_id,
    this.frqncy_nm,
    this.frst_nm,
    this.iptv_srl_nu,
    this.isChecked,
    this.loc_std_cd,
    this.lst_nm,
    this.mbl_nu,
    this.mdlwe_sbscr_id,
    this.onu_srl_nu,
    this.phne_nu,
    this.sno,
    this.srno,
    this.sts_clr_cd_tx,
    this.sts_nm,
    this.termn_req_sts,
    this.trmnd,
    this.trmnd_desc_tx,
  });


SubmitTerminationModel fromJson(Map<String,dynamic> json){
  return SubmitTerminationModel(
     actvnDt: json['actvnDt'],
     adhr_nu: json['adhr_nu'],
     caf_id: json['caf_id'],
     caf_nu: json['caf_nu'],
     caf_type_id: json['caf_type_id'],
     cstmr_id: json['cstmr_id'],
     cstmr_nm: json['cstmr_nm'],
     frqncy_id: json['frqncy_id'],
     frqncy_nm: json['frqncy_nm'],
     frst_nm: json['frst_nm'],
     iptv_srl_nu: json['iptv_srl_nu'],
     isChecked: true,
     loc_std_cd: json['loc_std_cd'],
     lst_nm: json['lst_nm'],
     mbl_nu: json['mbl_nu'],
     mdlwe_sbscr_id: json['mdlwe_sbscr_id'],
     onu_srl_nu: json['onu_srl_nu'],
     phne_nu: json['phne_nu'],
     sno: json['sno'],
     srno: 1,
     sts_clr_cd_tx: json['sts_clr_cd_tx'],
     sts_nm: json['sts_nm'],
     termn_req_sts: json['termn_req_sts'],
     trmnd: "trmnd_rqst_in",
     trmnd_desc_tx: "fgvh",
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
     srno: 1,
     sts_clr_cd_tx: sts_clr_cd_tx,
     sts_nm: sts_nm,
     termn_req_sts: termn_req_sts,
     trmnd: "trmnd_rqst_in",
     trmnd_desc_tx: "fgvh",
    
};

}


}