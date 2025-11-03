final Map<String, Map<String, dynamic>> sudanStateCities = {
  'Khartoum': {
    'ar': 'الخرطوم',
    'cities': [
      {'en': 'Khartoum', 'ar': 'الخرطوم'},
      {'en': 'Omdurman', 'ar': 'أمدرمان'},
      {'en': 'Bahri', 'ar': 'بحري'},
    ],
  },
  'Gezira': {
    'ar': 'الجزيرة',
    'cities': [
      {'en': 'Wad Madani', 'ar': 'ود مدني'},
    ],
  },
  'Kassala': {
    'ar': 'كسلا',
    'cities': [
      {'en': 'Kassala', 'ar': 'كسلا'},
      {'en': 'Aroma', 'ar': 'أروما'},
    ],
  },
  'Red Sea': {
    'ar': 'البحر الأحمر',
    'cities': [
      {'en': 'Port Sudan', 'ar': 'بورتسودان'},
    ],
  },
  'White Nile': {
    'ar': 'النيل الأبيض',
    'cities': [
      {'en': 'Kosti', 'ar': 'كوستي'},
    ],
  },
  'Sennar': {
    'ar': 'سنار',
    'cities': [
      {'en': 'Sennar', 'ar': 'سنار'},
      {'en': 'Singa', 'ar': 'سنجة'},
    ],
  },
  'North Kordofan': {
    'ar': 'شمال كردفان',
    'cities': [
      {'en': 'El Obeid', 'ar': 'الأبيض'},
    ],
  },
  'Northern': {
    'ar': 'الولاية الشمالية',
    'cities': [
      {'en': 'Dongola', 'ar': 'دنقلا'},
    ],
  },
};

/// Medical specialties in Arabic (display) with English backend values
final List<Map<String, String>> specialties = [
  {'en': 'Medicine', 'ar': 'اختصاصي الباطنية'},
  {'en': 'Pediatrics', 'ar': 'أمراض الأطفال و حديثي الولادة'},
  {'en': 'Surgery', 'ar': 'الجراحة العامة'},
  {'en': 'Obs', 'ar': 'النساء و التوليد'},
  {'en': 'Ortho Surgery', 'ar': 'جراحة العظام و الاصابات'},
  {'en': 'Uro Surgery', 'ar': 'جراحة الكلى و المسالك البولية'},
  {'en': 'ENT', 'ar': 'امراض الانف و الاذن و الحنجرة'},
  {'en': 'Ophthalma', 'ar': 'طب و جراحة العيون'},
  {'en': 'Derma', 'ar': 'الامراض الجلدية و التناسلية'},
  {'en': 'Chest', 'ar': 'الامراض الصدرية'},
  {'en': 'Enodcrine', 'ar': 'امراض الغدد الصماء و السكري'},
  {'en': 'Neuro', 'ar': 'امراض المخ و الاعصاب'},
  {'en': 'Neuro Surgery', 'ar': 'جراحة المخ و الاعصاب'},
  {'en': 'Pschology', 'ar': 'اختصاصي الامراض النفسية'},
  {'en': 'Dentistry', 'ar': 'طب الاسنان'},
  {'en': 'Pedo Surgery', 'ar': 'جراحة الاطفال العامة'},
  {'en': 'Pedo Ortho Surgery', 'ar': 'جراحة عظام الاطفال'},
  {'en': 'Pedo Uro Surgery', 'ar': 'جراحة الكلى و المسالك البولية للاطفال'},
  {'en': 'CVS Surgery', 'ar': 'امراض القلب و الاوعية الدموية و القسطرة'},
  {'en': 'Chest Surgery', 'ar': 'جراحة القلب و الصدر'},
  {'en': 'Oncology', 'ar': 'تخصص الاورام'},
];

 // 🧩 Helper method
   String? getArabicSpecialty(String englishName) {
    final match = specialties.firstWhere(
      (item) => item['en']?.toLowerCase() == englishName.toLowerCase(),
      orElse: () => {'ar': 'N/A'},
    );
    return match['ar'];
  }