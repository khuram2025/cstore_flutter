import 'dart:io';
import 'dart:convert';


class CompanyProfile {
  final String name;
  final String about;
  final String phone;
  final String address;
  final List<String> categories;
  final String cityId;
  File? logo;
  File? coverPic;

  CompanyProfile({
    required this.name,
    required this.about,
    required this.phone,
    required this.address,
    required this.categories,
    required this.cityId,
    this.logo,
    this.coverPic,
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'about': about,
      'phone': phone,
      'address': address,
      'categories': jsonEncode(categories), // Convert list to JSON string
      'cityId': cityId,
    };
  }

}
