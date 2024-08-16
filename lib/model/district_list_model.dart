class DistrictListModel{
   final dynamic dstrt_nm;
   final dynamic dstrt_id;

   dynamic? mndl_nu;
   dynamic? mndl_id;
   dynamic? mndl_nm;

   dynamic? vlge_nu;
   dynamic? vlge_id;
   dynamic? vlge_nm;


  DistrictListModel({
  required this.dstrt_nm,
  required this.dstrt_id,

  this.mndl_nu,
  this.mndl_id,
  this.mndl_nm,  

  this.vlge_id,
  this.vlge_nm,
  this.vlge_nu,
  
  
    
});


factory DistrictListModel.fromJson(Map<String,dynamic> json){
  return DistrictListModel(
    dstrt_nm: json['dstrt_nm'], 
    dstrt_id: json['dstrt_id'],

    mndl_nu: json['mndl_nu'],
    mndl_id: json['mndl_id'],
    mndl_nm: json['mndl_nm'],

    vlge_id: json['vlge_id'],
    vlge_nm: json['vlge_nm'],
    vlge_nu: json['vlge_nu'],
    

  );
}

}


