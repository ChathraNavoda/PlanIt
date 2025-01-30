import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:planit/core/constants/constants.dart';
import 'package:planit/core/services/sp_service.dart';
import 'package:planit/models/user_model.dart';

class AuthRemoteRepository {
  final spService = SpService();
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
          Uri.parse(
            '${Constants.backendUri}/auth/signup',
          ),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
          }));

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['msg'];
      }
      return UserModel.fromMap(jsonDecode(res.body));
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
          Uri.parse(
            '${Constants.backendUri}/auth/login',
          ),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'password': password,
          }));

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['msg'];
      }
      return UserModel.fromMap(jsonDecode(res.body));
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final token = await spService.getToken();
      print(token);
      if (token == null) {
        return null;
      }
      final res = await http.post(
        Uri.parse(
          '${Constants.backendUri}/auth/tokenIsValid',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      print(res.body);
      if (res.statusCode != 200) {
        return null;
      }

      final userResponse = await http.get(
        Uri.parse(
          '${Constants.backendUri}/auth',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      print(userResponse);
      if (userResponse.statusCode != 200 || jsonDecode(res.body) == false) {
        throw jsonDecode(userResponse.body)['msg'];
      }

      return UserModel.fromJson(userResponse.body);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
