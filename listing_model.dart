class Listing {
  final String id;
  final String type;
  final String title;
  final String description;
  final String district;
  final String? neighborhood;
  final String? street;
  final String? locationDescription;
  final String? buildingType;
  final String? floor;
  final int? roomCount;
  final List<RoomDetail>? rooms;
  final bool hasKitchen;
  final String? kitchenSize;
  final int? bathroomCount;
  final bool hasExternalMajlis;
  final bool externalMajlisHasBathroom;
  final String? waterSource;
  final String? waterIndependence;
  final String? electricityType;
  final String? electricityIndependence;
  final bool hasSolarPanels;
  final String? sunlightDirection;
  final double price;
  final String currency;
  final bool priceIncludesUtilities;
  final double? deposit;
  final double? advance;
  final bool hasBrokerage;
  final bool negotiable;
  final bool requiresGuarantee;
  final String? guaranteeType;
  final bool isCommercial;
  final String contactPhone;
  final String sellerType;
  final String? sellerName;
  final List<String> images;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final bool isFeatured;

  Listing({
    required this.id,
    required this.type,
    required this.title,
    this.description = '',
    required this.district,
    this.neighborhood,
    this.street,
    this.locationDescription,
    this.buildingType,
    this.floor,
    this.roomCount,
    this.rooms,
    this.hasKitchen = false,
    this.kitchenSize,
    this.bathroomCount,
    this.hasExternalMajlis = false,
    this.externalMajlisHasBathroom = false,
    this.waterSource,
    this.waterIndependence,
    this.electricityType,
    this.electricityIndependence,
    this.hasSolarPanels = false,
    this.sunlightDirection,
    required this.price,
    this.currency = 'ريال يمني',
    this.priceIncludesUtilities = false,
    this.deposit,
    this.advance,
    this.hasBrokerage = false,
    this.negotiable = false,
    this.requiresGuarantee = false,
    this.guaranteeType,
    this.isCommercial = false,
    required this.contactPhone,
    required this.sellerType,
    this.sellerName,
    this.images = const [],
    DateTime? createdAt,
    this.updatedAt,
    this.isActive = true,
    this.isFeatured = false,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      district: json['district'] as String,
      neighborhood: json['neighborhood'] as String?,
      street: json['street'] as String?,
      locationDescription: json['locationDescription'] as String?,
      buildingType: json['buildingType'] as String?,
      floor: json['floor'] as String?,
      roomCount: json['roomCount'] as int?,
      rooms: json['rooms'] != null
          ? (json['rooms'] as List).map((r) => RoomDetail.fromJson(r)).toList()
          : null,
      hasKitchen: json['hasKitchen'] as bool? ?? false,
      kitchenSize: json['kitchenSize'] as String?,
      bathroomCount: json['bathroomCount'] as int?,
      hasExternalMajlis: json['hasExternalMajlis'] as bool? ?? false,
      externalMajlisHasBathroom: json['externalMajlisHasBathroom'] as bool? ?? false,
      waterSource: json['waterSource'] as String?,
      waterIndependence: json['waterIndependence'] as String?,
      electricityType: json['electricityType'] as String?,
      electricityIndependence: json['electricityIndependence'] as String?,
      hasSolarPanels: json['hasSolarPanels'] as bool? ?? false,
      sunlightDirection: json['sunlightDirection'] as String?,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'ريال يمني',
      priceIncludesUtilities: json['priceIncludesUtilities'] as bool? ?? false,
      deposit: json['deposit'] != null ? (json['deposit'] as num).toDouble() : null,
      advance: json['advance'] != null ? (json['advance'] as num).toDouble() : null,
      hasBrokerage: json['hasBrokerage'] as bool? ?? false,
      negotiable: json['negotiable'] as bool? ?? false,
      requiresGuarantee: json['requiresGuarantee'] as bool? ?? false,
      guaranteeType: json['guaranteeType'] as String?,
      isCommercial: json['isCommercial'] as bool? ?? false,
      contactPhone: json['contactPhone'] as String,
      sellerType: json['sellerType'] as String,
      sellerName: json['sellerName'] as String?,
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'district': district,
      'neighborhood': neighborhood,
      'street': street,
      'locationDescription': locationDescription,
      'buildingType': buildingType,
      'floor': floor,
      'roomCount': roomCount,
      'rooms': rooms?.map((r) => r.toJson()).toList(),
      'hasKitchen': hasKitchen,
      'kitchenSize': kitchenSize,
      'bathroomCount': bathroomCount,
      'hasExternalMajlis': hasExternalMajlis,
      'externalMajlisHasBathroom': externalMajlisHasBathroom,
      'waterSource': waterSource,
      'waterIndependence': waterIndependence,
      'electricityType': electricityType,
      'electricityIndependence': electricityIndependence,
      'hasSolarPanels': hasSolarPanels,
      'sunlightDirection': sunlightDirection,
      'price': price,
      'currency': currency,
      'priceIncludesUtilities': priceIncludesUtilities,
      'deposit': deposit,
      'advance': advance,
      'hasBrokerage': hasBrokerage,
      'negotiable': negotiable,
      'requiresGuarantee': requiresGuarantee,
      'guaranteeType': guaranteeType,
      'isCommercial': isCommercial,
      'contactPhone': contactPhone,
      'sellerType': sellerType,
      'sellerName': sellerName,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
      'isFeatured': isFeatured,
    };
  }
}

class RoomDetail {
  final String name;
  final double? length;
  final double? width;

  RoomDetail({required this.name, this.length, this.width});

  String getSizeText() {
    if (length != null && width != null) {
      return '${length} × ${width} م';
    }
    return 'غير محدد';
  }

  factory RoomDetail.fromJson(Map<String, dynamic> json) {
    return RoomDetail(
      name: json['name'] as String,
      length: json['length'] != null ? (json['length'] as num).toDouble() : null,
      width: json['width'] != null ? (json['width'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'length': length, 'width': width};
  }
}
