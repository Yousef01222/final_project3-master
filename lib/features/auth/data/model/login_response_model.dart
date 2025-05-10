// class LoginResponse {
//   final String message;
//   final String? token;

//   LoginResponse({required this.message, this.token});

//   factory LoginResponse.fromJson(Map<String, dynamic> json) {
//     return LoginResponse(
//       message: json['message'],
//       token: json['token'] is String
//           ? json['token']
//           : json['token']?['accessToken'], // لو كان token = Map
//     );
//   }
// }

class LoginResponse {
  final String message;
  final String? token;
  final String? userId; // ← أضف دي

  LoginResponse({required this.message, this.token, this.userId});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      token: json['token'] is String
          ? json['token']
          : json['token']?['accessToken'],
      userId: json['user']
          ?['_id'], // ← أو حسب اسم المفتاح الحقيقي في الـ response
    );
  }
}
