

class SubscriberOtpVerificationModel{
  final dynamic? updt_id;
  final dynamic? cstmr_id;
  final dynamic? caf_id;
  final dynamic? mdlwe_sbscr_id;
  final dynamic? mbl_nu;
  final dynamic? loc_eml1_tx;
  final dynamic? instl_addr1_tx;
  final dynamic? instl_addr2_tx;
  final dynamic? instl_lcly_tx;
  final dynamic? instl_ara_tx;
  final dynamic? instl_ste_id;
  final dynamic? instl_dstrct_id;
  final dynamic? instl_mndl_id;
  final dynamic? instl_vlge_id;
  final dynamic? instl_std_cd;
  final dynamic? mbl_nu_updtd;
  final dynamic? loc_eml1_tx_updtd;
  final dynamic? cntct_mble2_nu_updtd;
  final dynamic? instl_addr1_tx_updtd;
  final dynamic? instl_addr2_tx_updtd;
  final dynamic? instl_lcly_tx_updtd;
  final dynamic? instl_ara_tx_updtd;
  final dynamic? instl_ste_id_updtd;

  final dynamic? instl_dstrct_id_updtd;
  final dynamic? instl_mndl_id_updtd;
  final dynamic? instl_vlge_id_updtd;
  final dynamic? instl_std_cd_updtd;
  final dynamic? otp_id;
  final dynamic? otp_vrfd_in;
  final dynamic? agnt_id;
  final dynamic? crte_usr_id;
  final dynamic? updte_usr_id;
  final dynamic? a_in;
  final dynamic? d_ts;
  final dynamic? u_ts;
  final dynamic? i_ts;
  final dynamic? adhr_nu;
  final dynamic? frst_nm;
  final dynamic? lst_nm;
  final dynamic? updt_ts;
  

  SubscriberOtpVerificationModel({
       this.updt_id,
       this.cstmr_id,
       this.caf_id,
       this.mdlwe_sbscr_id,
       this.mbl_nu,
       this.loc_eml1_tx,
       this.instl_addr1_tx,
       this.instl_addr2_tx,
       this.instl_lcly_tx,
       this.instl_ara_tx,
       this.instl_ste_id,
       this.instl_dstrct_id,
       this.instl_mndl_id,
       this.instl_vlge_id,
       this.instl_std_cd,
       this.mbl_nu_updtd,
       this.loc_eml1_tx_updtd,
       this.cntct_mble2_nu_updtd,
       this.instl_addr1_tx_updtd,
       this.instl_addr2_tx_updtd,
       this.instl_lcly_tx_updtd,
       this.instl_ara_tx_updtd,
       this.instl_ste_id_updtd,

       this.instl_dstrct_id_updtd,
       this.instl_mndl_id_updtd,
       this.instl_vlge_id_updtd,
       this.instl_std_cd_updtd,
       this.otp_id,
       this.otp_vrfd_in,
       this.agnt_id,
       this.crte_usr_id,
       this.updte_usr_id,
       this.a_in,
       this.d_ts,
       this.u_ts,
       this.i_ts,
       this.adhr_nu,
       this.frst_nm,
       this.lst_nm,
       this.updt_ts,
  });

  
 factory SubscriberOtpVerificationModel.fromJson(Map<String,dynamic> json){
   return SubscriberOtpVerificationModel(
    updt_id:json['updt_id'],
    cstmr_id:json['cstmr_id'],
    caf_id:json['caf_id'],
    mdlwe_sbscr_id:json['mdlwe_sbscr_id'],
    mbl_nu:json['mbl_nu'],
    loc_eml1_tx:json['loc_eml1_tx'],
    instl_addr1_tx:json['instl_addr1_tx'],
    instl_addr2_tx:json['instl_addr2_tx'],
    instl_lcly_tx:json['instl_lcly_tx'],
    instl_ara_tx:json['instl_ara_tx'],
    instl_ste_id:json['instl_ste_id'],
    instl_dstrct_id:json['instl_dstrct_id'],
    instl_mndl_id:json['instl_mndl_id'],
    instl_vlge_id:json['instl_vlge_id'],
    instl_std_cd:json['instl_std_cd'],
    mbl_nu_updtd:json['mbl_nu_updtd'],
    loc_eml1_tx_updtd:json['loc_eml1_tx_updtd'],
    cntct_mble2_nu_updtd:json['cntct_mble2_nu_updtd'],
    instl_addr1_tx_updtd:json['instl_addr1_tx_updtd'],
    instl_addr2_tx_updtd:json['instl_addr2_tx_updtd'],
    instl_lcly_tx_updtd:json['instl_lcly_tx_updtd'],
    instl_ara_tx_updtd:json['instl_ara_tx_updtd'],
    instl_ste_id_updtd:json['instl_ste_id_updtd'],

    instl_dstrct_id_updtd:json['instl_dstrct_id_updtd'],
    instl_mndl_id_updtd:json['instl_mndl_id_updtd'],
    instl_vlge_id_updtd:json['instl_vlge_id_updtd'],
    instl_std_cd_updtd:json['instl_std_cd_updtd'],
    otp_id:json['otp_id'],
    otp_vrfd_in:json['otp_vrfd_in'],
    agnt_id:json['agnt_id'],
    crte_usr_id:json['crte_usr_id'],
    updte_usr_id:json['updte_usr_id'],
    a_in:json['a_in'],
    d_ts:json['d_ts'],
    u_ts:json['u_ts'],
    i_ts:json['i_ts'],
    adhr_nu:json['adhr_nu'],
    frst_nm:json['frst_nm'],
    lst_nm:json['lst_nm'],
    updt_ts:json['updt_ts'],

   );
 }



}
