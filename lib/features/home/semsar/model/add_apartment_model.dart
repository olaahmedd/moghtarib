class AddApartmentModel {
  int? id;
  final String city;
  final String village;
  final String location;
  final double price;
  final int numOfRooms;
  final int type;
  final double addressLat;
  final double addressLon;
  final bool isRent;
  final String? baseImageURL;

  AddApartmentModel({
    this.id,
    required this.city,
    required this.village,
    required this.location,
    required this.price,
    required this.numOfRooms,
    required this.type,
    required this.addressLat,
    required this.addressLon,
    required this.isRent,
    this.baseImageURL,
  });

  factory AddApartmentModel.fromJson(Map<String, dynamic> json) {
    return AddApartmentModel(
      id: json['Id'] != null ? int.tryParse(json['Id'].toString()) : null,
      city: json['City'] ?? '',
      village: json['Village'] ?? '',
      location: json['Location'] ?? '',
      price: (json['Price'] as num?)?.toDouble() ?? 0.0,
      // 🎯 وضع قيمة افتراضية عشان الـ tryParse بيرجع int? والموديل طالبه int مؤكد
      numOfRooms: int.tryParse(json['NumOfRooms']?.toString() ?? '') ?? 0,
      type: int.tryParse(json['Type']?.toString() ?? '') ?? 1,
      addressLat: (json['address_Lat'] as num?)?.toDouble() ?? 0.0,
      addressLon: (json['address_Lon'] as num?)?.toDouble() ?? 0.0,
      isRent: json['IsRent'] ?? false,
      baseImageURL: json['BaseImageURL'] ?? json['baseImageURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'City': city,
      'Village': village,
      'Location': location,
      'Price': price,
      'NumOfRooms': numOfRooms,
      'Type': type,
      'address_Lat': addressLat,
      'address_Lon': addressLon,
      'IsRent': isRent,
      'BaseImageURL': baseImageURL,
    };
  }
}