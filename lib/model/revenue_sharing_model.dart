class RevenueSharingModel{
  final dynamic? agnt_cd;
  final dynamic? cafcount;
  final dynamic? pro_rted_caf_cnt;
  final dynamic? apsflshare;
  final dynamic? msoshare;
  final dynamic? lmoshare;
  final dynamic? total;
  final dynamic? year;
  final dynamic? monthid;
  final dynamic? ofce_dstrt_id;
  final dynamic? voip_chrge_at;
  final dynamic? paid;
  final dynamic? NotPaid;
  final dynamic? pd_sts;
  
  RevenueSharingModel({
    this.agnt_cd,
    this.cafcount,
    this.pro_rted_caf_cnt,
    this.apsflshare,
    this.msoshare,
    this.lmoshare,
    this.total,
    this.year,
    this.monthid,
    this.ofce_dstrt_id,
    this.voip_chrge_at,
    this.paid,
    this.NotPaid,
    this.pd_sts,
    
  });


  factory RevenueSharingModel.fromJson(Map<String,dynamic> json){
    return RevenueSharingModel(
      agnt_cd:json['agnt_cd'],
      cafcount:json['cafcount'],
      pro_rted_caf_cnt:json['pro_rted_caf_cnt'],
      apsflshare:json['apsflshare'],
      msoshare:json['msoshare'],
      lmoshare:json['lmoshare'],
      total:json['total'],
      year:json['year'],
      monthid:json['monthid'],
      ofce_dstrt_id:json['ofce_dstrt_id'],
      voip_chrge_at:json['voip_chrge_at'],
      paid:json['paid'],
      NotPaid:json['NotPaid'],
      pd_sts:json['pd_sts'],
    );
  }


}