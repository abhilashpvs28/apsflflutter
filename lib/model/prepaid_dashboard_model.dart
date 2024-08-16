class PrepaidDashboardModel{
   dynamic month;
   dynamic ttl_apsfl_mnth_rvnue;
   dynamic mnth;
   dynamic ttl_apsfl_mnth_clctn;

   dynamic Status_name;
   dynamic CAF_COUNT;

   dynamic tdy;
   dynamic tdyamt;

   dynamic tdy_renwd_caf;

   dynamic sum;
   dynamic expired_caf;
  
  PrepaidDashboardModel({
    this.month,
    this.ttl_apsfl_mnth_rvnue,
    this.mnth,
    this.ttl_apsfl_mnth_clctn,

    this.Status_name,
    this.CAF_COUNT,

    this.tdy,
    this.tdyamt,

    this.tdy_renwd_caf,

    this.sum,
    this.expired_caf,
  });

  factory PrepaidDashboardModel.fromJson(Map<String,dynamic> json){
    return PrepaidDashboardModel(
      
      month:json['month'],
      ttl_apsfl_mnth_rvnue:json['ttl_apsfl_mnth_rvnue'],
      mnth:json['mnth'],
      ttl_apsfl_mnth_clctn:json['ttl_apsfl_mnth_clctn'],
      Status_name:json['Status_name'],
      CAF_COUNT:json['CAF_COUNT'],
      tdy:json['tdy'],
      tdyamt:json['tdyamt'],
      tdy_renwd_caf:json['tdy_renwd_caf'],
      sum:json['sum'],
      expired_caf:json['expired_caf'],
     
    );
  }

}