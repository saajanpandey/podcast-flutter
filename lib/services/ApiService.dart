import 'package:dio/dio.dart';
import 'package:podcast/modal/AuthUserModal.dart';
import 'package:podcast/modal/LoginModal.dart';
import 'package:podcast/modal/LogoutModal.dart';
import 'package:podcast/modal/RegisterModal.dart';
import 'package:podcast/services/StorageService.dart';

class ApiService {
  Future<LoginModal?> login(email, password) async {
    try {
      var response = await Dio().post('http://10.0.2.2:8000/api/v1/login',
          data: {"email": email, "password": password});
      var dataResponse = LoginModal.fromJson(response.data);
      return dataResponse;
    } catch (e) {
      return LoginModal.withError(e.toString());
    }
  }

  Future<RegisterModal?> register(
      fullname, dateOfBirth, gender, email, password) async {
    try {
      var response = await Dio().post('http://10.0.2.2:8000/api/v1/register',
          data: {
            "name": fullname,
            "date_of_birth": dateOfBirth,
            "gender": gender,
            "email": email,
            "password": password
          },
          options: Options(headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          }));
      var dataResponse = RegisterModal.fromJson(response.data);
      return dataResponse;
    } on DioError catch (e) {
      return RegisterModal.fromJson(e.response?.data);
    }
  }

  Future<AuthUserModal?> authUserdata() async {
    var token = await StorageService().getLoginToken();
    try {
      var response = await Dio().get('http://10.0.2.2:8000/api/v1/users',
          options: Options(headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      var returnresponse = AuthUserModal.fromJson(response.data);
      return returnresponse;
    } catch (e) {
      // return AuthUserModal.withError(e.toString());
    }
  }

  Future<LogoutModal?> logout() async {
    var token = await StorageService().getLoginToken();
    try {
      var response = await Dio().get(
        'http://10.0.2.2:8000/api/v1/logout',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );
      var data = LogoutModal.fromJson(response.data);
      return data;
    } catch (e) {
      print(e);
    }
  }
}
