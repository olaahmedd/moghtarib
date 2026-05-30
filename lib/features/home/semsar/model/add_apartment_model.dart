class AddApartmentModel {
  final String city;
  final String village;
  final String location;
  final double price;
  final int numOfRooms;
  final int type;
  final double addressLat;
  final double addressLon;
  final bool isRent;

  AddApartmentModel({
    required this.city,
    required this.village,
    required this.location,
    required this.price,
    required this.numOfRooms,
    required this.type,
    required this.addressLat,
    required this.addressLon,
    required this.isRent,
  });

  // 👇 أضف هذا الجزء لحل المشكلة واختفاء الخطأ
  factory AddApartmentModel.fromJson(Map<String, dynamic> json) {
    return AddApartmentModel(
      city: json['City'] ?? '',
      village: json['Village'] ?? '',
      location: json['Location'] ?? '',
      // تحويل آمن للـ double لتجنب أي مشاكل إذا أرسل السيرفر رقم صحيح
      price: (json['Price'] as num?)?.toDouble() ?? 0.0,
      numOfRooms: json['NumOfRooms'] ?? 0,
      type: json['Type'] ?? 0,
      addressLat: (json['address_Lat'] as num?)?.toDouble() ?? 0.0,
      addressLon: (json['address_Lon'] as num?)?.toDouble() ?? 0.0,
      isRent: json['IsRent'] ?? false,
    );
  }

  // تحويل البيانات لـ Map عشان تتبعت كـ Query Parameters بسهولة
  Map<String, dynamic> toQueryParameters() {
    return {
      'City': city,
      'Village': village,
      'Location': location,
      'Price': price,
      'NumOfRooms': numOfRooms,
      'Type': type,
      'address_Lat': addressLat,
      'address_Lon': addressLon,
      'IsRent': isRent,
    };
  }
}