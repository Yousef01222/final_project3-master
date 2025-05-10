class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final String provider;
  final String gender;
  final String dob;
  final String mobileNumber;
  final String role;
  final bool isTranslator;
  final bool isVerified;
  final String mediaCloudFolder;
  final int age;
  final String? profileImageUrl;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.provider,
    required this.gender,
    required this.dob,
    required this.mobileNumber,
    required this.role,
    required this.isTranslator,
    required this.isVerified,
    required this.mediaCloudFolder,
    required this.age,
    this.profileImageUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      provider: json['provider'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['DOB'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      role: json['role'] ?? '',
      isTranslator: json['isTranslator'] ?? false,
      isVerified: json['isVerified'] ?? false,
      mediaCloudFolder: json['mediaCloudFolder'] ?? '',
      age: json['age'] ?? 0,
      profileImageUrl: json['profileImageUrl'] ?? json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'provider': provider,
      'gender': gender,
      'DOB': dob,
      'mobileNumber': mobileNumber,
      'role': role,
      'isTranslator': isTranslator,
      'isVerified': isVerified,
      'mediaCloudFolder': mediaCloudFolder,
      'age': age,
      'profileImageUrl': profileImageUrl,
    };
  }
}
