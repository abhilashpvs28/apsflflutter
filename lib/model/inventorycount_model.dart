
class InventoryCountModel{

  //    final String Total;
  //    final String Allocated;
  //    final String Available;

  //   InventoryCountModel({
  //   required this.Total,
  //   required this.Allocated,
  //   required this.Available,
  // });

  // factory InventoryCountModel.fromJson(Map<String, dynamic> json) {
  //   return InventoryCountModel(
  //     Total: json['Total'],
  //     Allocated: json['Allocated'],
  //     Available: json['Available'],
    
  //   );
  // }



  final int total;
  final int DASAN;
  final int ZTE;
  final int PT;
  final int RGW;
  final int YAGA;
  final int IPTV;
  final int DSNCOMBO;
  final String label;

    InventoryCountModel({
    required this.total,
    required this.DASAN,
    required this.ZTE,
    required this.PT,
    required this.RGW,
    required this.YAGA,
    required this.IPTV,
    required this.DSNCOMBO,
    required this.label,
  });

  factory InventoryCountModel.fromJson(Map<String,dynamic> json){
    return InventoryCountModel(
      total: json['total'],
       DASAN: json['DASAN'],
       ZTE: json['ZTE'],
       PT: json['PT'],
       RGW: json['RGW'], 
       YAGA: json['YAGA'], 
       IPTV: json['IPTV'], 
       DSNCOMBO: json['DSNCOMBO'], 
       label: json['label']
       );
  }

}