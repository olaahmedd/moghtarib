class AllApartmentModel {
  int? id;
  String? city;
  String? village;
  String? location;
  double? addressLat; // تم تغييرها إلى double لأن الإحداثيات دائماً عشرية
  double? addressLon; // تم تغييرها إلى double لأن الإحداثيات دائماً عشرية
  int? price;
  int? numOfRooms;
  String? baseImageURL;
  int? type;
  int? distanceByMeters;
  bool? isRent;
  String? dateOfCreation;
  String? userId;
  String? userName;
  String? userPhone;
  String? userWhatsapp;
  List<String>? imagesURL;

  AllApartmentModel({
    this.id,
    this.city,
    this.village,
    this.location,
    this.addressLat,
    this.addressLon,
    this.price,
    this.numOfRooms,
    this.baseImageURL,
    this.type,
    this.distanceByMeters,
    this.isRent,
    this.dateOfCreation,
    this.userId,
    this.userName,
    this.userPhone,
    this.userWhatsapp,
    this.imagesURL,
  });

  AllApartmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString());
    city = json['city'];
    village = json['village'];
    location = json['location'];
    
   
    addressLat = (json['address_Lat'] as num?)?.toDouble();
    addressLon = (json['address_Lon'] as num?)?.toDouble();
    
    
    price = (json['price'] as num?)?.toInt();
    numOfRooms = (json['numOfRooms'] as num?)?.toInt();
    type = (json['type'] as num?)?.toInt();
    distanceByMeters = (json['distanceByMeters'] as num?)?.toInt();
    
    baseImageURL = json['baseImageURL'];
    isRent = json['isRent'];
    dateOfCreation = json['dateOfCreation'];
    userId = json['userId']?.toString(); 
    userName = json['userName'];
    userPhone = json['userPhone'];
    userWhatsapp = json['userWhatsapp'];
    
    
    if (json['imagesURL'] != null) {
      imagesURL = List<String>.from(json['imagesURL'].map((x) => x.toString()));
    } else {
      imagesURL = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['city'] = city;
    data['village'] = village;
    data['location'] = location;
    data['address_Lat'] = addressLat;
    data['address_Lon'] = addressLon;
    data['price'] = price;
    data['numOfRooms'] = numOfRooms;
    data['baseImageURL'] = baseImageURL;
    data['type'] = type;
    data['distanceByMeters'] = distanceByMeters;
    data['isRent'] = isRent;
    data['dateOfCreation'] = dateOfCreation;
    data['userId'] = userId;
    data['userName'] = userName;
    data['userPhone'] = userPhone;
    data['userWhatsapp'] = userWhatsapp;
    data['imagesURL'] = imagesURL;
    return data;
  }
}