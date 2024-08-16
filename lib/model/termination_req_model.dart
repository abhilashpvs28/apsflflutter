

class TerminationReqModel{
  final dynamic? trmn_rqst_id;
  final dynamic? rqst_agnt_id;
  final dynamic? caf_id;
  final dynamic? cstmr_id;
  final dynamic? trmnd_req_dt;
  final dynamic? rjctd_in;
  final dynamic? lmo_rjctd_in;
  final dynamic? lmo_rjctd_cmnt_tx;
  final dynamic? sts;
  final dynamic? rqst_cmnt_tx;
  final dynamic? aprvd_usr_id;
  final dynamic? aprvd_ts;
  final dynamic? aprvl_cmnt_tx;
  final dynamic? caf_type_nm;
  final dynamic? cstmr_nm;
  final dynamic? frst_nm;
  final dynamic? lst_nm;
  final dynamic? caf_nu;
  final dynamic? instl_eml1_tx;
  final dynamic? mbl_nu;
  final dynamic? adhr_nu;
  final dynamic? instl_addr1_tx;
  final dynamic? actvn_dt;

  TerminationReqModel({
       this.trmn_rqst_id,
       this.rqst_agnt_id,
       this.caf_id,
       this.cstmr_id,
       this.trmnd_req_dt,
       this.rjctd_in,
       this.lmo_rjctd_in,
       this.lmo_rjctd_cmnt_tx,
       this.sts,
       this.rqst_cmnt_tx,
       this.aprvd_usr_id,
       this.aprvd_ts,
       this.aprvl_cmnt_tx,
       this.caf_type_nm,
       this.cstmr_nm,
       this.frst_nm,
       this.lst_nm,
       this.caf_nu,
       this.instl_eml1_tx,
       this.mbl_nu,
       this.adhr_nu,
       this.instl_addr1_tx,
       this.actvn_dt,
  });

  
 factory TerminationReqModel.fromJson(Map<String,dynamic> json){
   return TerminationReqModel(
    trmn_rqst_id:json['trmn_rqst_id'],
    rqst_agnt_id:json['rqst_agnt_id'],
    caf_id:json['caf_id'],
    cstmr_id:json['cstmr_id'],
    trmnd_req_dt:json['trmnd_req_dt'],
    rjctd_in:json['rjctd_in'],
    lmo_rjctd_in:json['lmo_rjctd_in'],
    lmo_rjctd_cmnt_tx:json['lmo_rjctd_cmnt_tx'],
    sts:json['sts'],
    rqst_cmnt_tx:json['rqst_cmnt_tx'],
    aprvd_usr_id:json['aprvd_usr_id'],
    aprvd_ts:json['aprvd_ts'],
    aprvl_cmnt_tx:json['aprvl_cmnt_tx'],
    caf_type_nm:json['caf_type_nm'],
    cstmr_nm:json['cstmr_nm'],
    frst_nm:json['frst_nm'],
    lst_nm:json['lst_nm'],
    caf_nu:json['caf_nu'],
    instl_eml1_tx:json['instl_eml1_tx'],
    mbl_nu:json['mbl_nu'],
    adhr_nu:json['adhr_nu'],
    instl_addr1_tx:json['instl_addr1_tx'],
    actvn_dt:json['instl_eml1_tx'],
    

   );
 }



}
