class PaymentModel{
  final dynamic f_ac_id;
  final dynamic receipt_id;
  final dynamic trns_mrchant_id;
  final dynamic admin_id;
  final dynamic cust_id;
  final dynamic stb_id;
  final dynamic open_bal;
  final dynamic amount;
  final dynamic close_bal;
  final dynamic cpe_chrge;
  final dynamic operation;
  final dynamic remarks;
  final dynamic ac_date;
  final dynamic dateCreated;
  final dynamic created_by;
  final dynamic money_type;
  final dynamic strt_date;
  final dynamic c;
  final dynamic pack_price;
  final dynamic mnths;
  final dynamic old_pack_availed_days;
  final dynamic pack_remaining_days;
  final dynamic old_pack_rem_apsfl_share;
  final dynamic old_pack_rem_lmo_share;
  final dynamic new_pack_apsfl_share;
  final dynamic apsfl_share_prft;
  final dynamic new_pack_lmo_share;
  final dynamic lmo_share_prft;
  final dynamic final_wallet_deduct;
  final dynamic pdf_download;
  final dynamic caf_actvn_dt;
  final dynamic date_created;
  final dynamic startdate;
  final dynamic enddate;
  final dynamic gateway;
  final dynamic mrcht_usr_nm;
  final dynamic cstmr_nm;
  final dynamic pack_amount;
  final dynamic mbl_nu;
  final dynamic pckge_type_id;
  final dynamic sbscr_code;


  PaymentModel({
    this.f_ac_id,
    this.receipt_id,
    this.trns_mrchant_id,
    this.admin_id,
    this.cust_id,
    this.stb_id,
    this.open_bal,
    this.amount,
    this.close_bal,
    this.cpe_chrge,
    this.operation,
    this.remarks,
    this.ac_date,
    this.dateCreated,
    this.created_by,
    this.money_type,
    this.strt_date,
    this.c,
    this.pack_price,
    this.mnths,
    this.old_pack_availed_days,
    this.pack_remaining_days,
    this.old_pack_rem_apsfl_share,
    this.old_pack_rem_lmo_share,
    this.new_pack_apsfl_share,
    this.apsfl_share_prft,
    this.new_pack_lmo_share,
    this.lmo_share_prft,
    this.final_wallet_deduct,
    this.pdf_download,
    this.caf_actvn_dt,
    this.date_created,
    this.startdate,
    this.enddate,
    this.gateway,
    this.mrcht_usr_nm,
    this.cstmr_nm,
    this.pack_amount,
    this.mbl_nu,
    this.pckge_type_id,
    this.sbscr_code,

  });

  factory PaymentModel.fromJson(Map<String,dynamic> json){
    return PaymentModel(
      f_ac_id:json['f_ac_id'],
      receipt_id:json['receipt_id'],
      trns_mrchant_id:json['trns_mrchant_id'],
      admin_id:json['admin_id'],
      cust_id:json['cust_id'],
      stb_id:json['stb_id'],
      open_bal:json['open_bal'],
      amount:json['amount'],
      close_bal:json['close_bal'],
      cpe_chrge:json['cpe_chrge'],
      operation:json['operation'],
      remarks:json['remarks'],
      ac_date:json['ac_date'],
      dateCreated:json['dateCreated'],

      created_by:json['created_by'],
      money_type:json['money_type'],
      strt_date:json['strt_date'],
      c:json['c'],
      pack_price:json['pack_price'],
      mnths:json['mnths'],
      old_pack_availed_days:json['old_pack_availed_days'],
      pack_remaining_days:json['pack_remaining_days'],
      old_pack_rem_apsfl_share:json['old_pack_rem_apsfl_share'],
      new_pack_apsfl_share:json['new_pack_apsfl_share'],
      apsfl_share_prft:json['apsfl_share_prft'],
      new_pack_lmo_share:json['new_pack_lmo_share'],
      lmo_share_prft:json['lmo_share_prft'],
      final_wallet_deduct:json['final_wallet_deduct'],

      pdf_download:json['pdf_download'],
      caf_actvn_dt:json['caf_actvn_dt'],
      date_created:json['date_created'],
      startdate:json['startdate'],
      enddate:json['enddate'],
      gateway:json['gateway'],
      mrcht_usr_nm:json['mrcht_usr_nm'],
      cstmr_nm:json['cstmr_nm'],
      pack_amount:json['pack_amount'],
      mbl_nu:json['mbl_nu'],
      pckge_type_id:json['pckge_type_id'],
      sbscr_code:json['sbscr_code'],
   

    );

  }

}