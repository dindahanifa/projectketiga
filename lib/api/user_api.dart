import 'package:http/http.dart' as http;
import 'package:projectketiga/model/profile_model.dart';
import 'package:projectketiga/model/register_error.dart';
import 'package:projectketiga/utils/shared_preferences.dart';
import 'package:projectketiga/utils/endpoint.dart';
import 'package:projectketiga/model/user_model.dart';


class UserService {
  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String name,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.register),
      headers: {"Accept": "application/json"},
      body: {"name": name, "email": email, "password": password},
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(UserResponseFromJson(response.body).toJson());
      return UserResponseFromJson(response.body).toJson();
    } else if (response.statusCode == 422) {
      return UserResponseFromJson(response.body).toJson();
    } else {
      print("Failed to register user: ${response.statusCode}");
      throw Exception("Failed to register user: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.login),
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );
    print(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      print(UserResponseFromJson(response.body).toJson());
      return UserResponseFromJson(response.body).toJson();
    } else if (response.statusCode == 422) {
      return UserResponseFromJson(response.body).toJson();
    } else {
      print("Failed to register user: ${response.statusCode}");
      throw Exception("Failed to register user: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    String? token = await PreferenceHandler.getToken();
    final response = await http.get(
      Uri.parse(Endpoint.profile),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      print(profileResponseFromJson(response.body).toJson());
      return profileResponseFromJson(response.body).toJson();
    } else if (response.statusCode == 422) {
      return registerErrorResponseFromJson(response.body).toJson();
    } else {
      print("Failed to register user: ${response.statusCode}");
      throw Exception("Failed to register user: ${response.statusCode}");
    }
  }

    Future<Map<String, dynamic>> updateProfile(String name) async {
    String? token = await PreferenceHandler.getToken();
    if (token == null){
      throw  Exception('Token tidak ditemukan, silahkan login ulang');
    }
    final response = await http.put(
      Uri.parse(Endpoint.profile),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        
      },
       body: {
        'name': name,
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      return profileResponseFromJson(response.body).toJson();
    } else if (response.statusCode == 422) {
      return registerErrorResponseFromJson(response.body).toJson();
    } else {
      print("Gagal memuat profil: ${response.statusCode}");
      throw Exception("Gagal memuat profil: ${response.statusCode}");
    }
  }
}