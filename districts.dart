/// مديريات أمانة العاصمة صنعاء (10 مديريات)
class Districts {
  static const List<Map<String, dynamic>> districts = [
    {'id': 'azal', 'name': 'آزال', 'nameEn': 'Azal', 'neighborhoods': []},
    {'id': 'tahrir', 'name': 'التحرير', 'nameEn': 'Tahrir', 'neighborhoods': []},
    {'id': 'thawra', 'name': 'الثورة', 'nameEn': 'Thawra', 'neighborhoods': []},
    {'id': 'sabaeen', 'name': 'السبعين', 'nameEn': 'Sabaeen', 'neighborhoods': []},
    {'id': 'safiya', 'name': 'الصافية', 'nameEn': 'Safiya', 'neighborhoods': []},
    {'id': 'wahda', 'name': 'الوحدة', 'nameEn': 'Wahda', 'neighborhoods': []},
    {'id': 'boni_hareth', 'name': 'بني الحارث', 'nameEn': 'Boni Hareth', 'neighborhoods': []},
    {'id': 'shoob', 'name': 'شعوب', 'nameEn': 'Shoob', 'neighborhoods': []},
    {'id': 'old_sanaa', 'name': 'صنعاء القديمة', 'nameEn': 'Old Sana\'a', 'neighborhoods': []},
    {'id': 'maeen', 'name': 'معين', 'nameEn': 'Maeen', 'neighborhoods': []},
  ];

  static String getDistrictName(String id) {
    final district = districts.firstWhere(
      (d) => d['id'] == id,
      orElse: () => {'name': 'غير محدد'},
    );
    return district['name'];
  }
}

/// أنواع الإيجارات المتاحة
class RentalTypes {
  static const List<Map<String, dynamic>> types = [
    {'id': 'apartment', 'name': 'شقة', 'icon': '🏠', 'nameEn': 'Apartment'},
    {'id': 'villa', 'name': 'فيلا', 'icon': '🏡', 'nameEn': 'Villa'},
    {'id': 'building', 'name': 'عمارة', 'icon': '🏢', 'nameEn': 'Building'},
    {'id': 'shop', 'name': 'محل', 'icon': '🏪', 'nameEn': 'Shop'},
    {'id': 'basement', 'name': 'بدروم', 'icon': '⬇️', 'nameEn': 'Basement'},
    {'id': 'wedding_hall', 'name': 'صالون أعراس', 'icon': '🎉', 'nameEn': 'Wedding Hall'},
    {'id': 'land', 'name': 'قطعة أرض / حوش', 'icon': '📐', 'nameEn': 'Land / Yard'},
    {'id': 'car', 'name': 'سيارة', 'icon': '🚗', 'nameEn': 'Car'},
    {'id': 'motorcycle', 'name': 'دراجة نارية', 'icon': '🏍️', 'nameEn': 'Motorcycle'},
    {'id': 'stall', 'name': 'بسطة', 'icon': '🛒', 'nameEn': 'Stall'},
    {'id': 'other', 'name': 'أخرى', 'icon': '📋', 'nameEn': 'Other'},
  ];

  static String getTypeName(String id) {
    final type = types.firstWhere(
      (t) => t['id'] == id,
      orElse: () => {'name': 'أخرى'},
    );
    return type['name'];
  }
}

class WaterSources {
  static const String government = 'government';
  static const String tank = 'tank';
  static const String waterTruck = 'water_truck';
  
  static String getName(String source) {
    switch (source) {
      case government: return 'حكومي';
      case tank: return 'خزان';
      case waterTruck: return 'وايتات';
      default: return 'غير محدد';
    }
  }
}

class ElectricityTypes {
  static const String government = 'government';
  static const String commercial = 'commercial';
  static const String solar = 'solar';
  
  static String getName(String type) {
    switch (type) {
      case government: return 'حكومي';
      case commercial: return 'تجاري (مولدات)';
      case solar: return 'شمسي';
      default: return 'غير محدد';
    }
  }
}

class SunlightDirections {
  static const String south = 'south';
  static const String east = 'east';
  static const String west = 'west';
  static const String north = 'north';
  
  static String getName(String direction) {
    switch (direction) {
      case south: return 'جنوبي (مشمس جداً) 🌞';
      case east: return 'شرقي (مشمس صباحاً) 🌅';
      case west: return 'غربي (مشمس مساءً) 🌇';
      case north: return 'شمالي (ظليل) ☁️';
      default: return 'غير محدد';
    }
  }
}

class Floors {
  static const String ground = 'ground';
  static const String first = 'first';
  static const String second = 'second';
  static const String third = 'third';
  static const String fourth = 'fourth';
  
  static String getName(String floor) {
    switch (floor) {
      case ground: return 'أرضي';
      case first: return 'أول';
      case second: return 'ثاني';
      case third: return 'ثالث';
      case fourth: return 'رابع';
      default: return 'غير محدد';
    }
  }
}

class SellerTypes {
  static const String owner = 'owner';
  static const String agent = 'agent';
  static const String broker = 'broker';
  
  static String getName(String type) {
    switch (type) {
      case owner: return 'مالك';
      case agent: return 'وكيل';
      case broker: return 'دلال';
      default: return 'غير محدد';
    }
  }
}
