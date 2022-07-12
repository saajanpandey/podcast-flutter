import 'package:dio/dio.dart';
import 'package:podcast/modal/AuthUserModal.dart';
import 'package:podcast/modal/FeedbackModal.dart';
import 'package:podcast/modal/LoginModal.dart';
import 'package:podcast/modal/LogoutModal.dart';
import 'package:podcast/modal/PodcastModal.dart';
import 'package:podcast/modal/ProfileImageModal.dart';
import 'package:podcast/modal/RegisterModal.dart';
import 'package:podcast/modal/UserProfileModal.dart';
import 'package:podcast/services/StorageService.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class ApiService {
  final optionsdata = CacheOptions(
    // A default store is required for interceptor.
    store: MemCacheStore(),

    // All subsequent fields are optional.

    // Default.
    policy: CachePolicy.request,
    // Returns a cached response on error but for statuses 401 & 403.
    // Also allows to return a cached response on network errors (e.g. offline usage).
    // Defaults to [null].
    hitCacheOnErrorExcept: [401, 403],
    // Overrides any HTTP directive to delete entry past this duration.
    // Useful only when origin server has no cache config or custom behaviour is desired.
    // Defaults to [null].
    maxStale: const Duration(days: 7),
    // Default. Allows 3 cache sets and ease cleanup.
    priority: CachePriority.normal,
    // Default. Body and headers encryption with your own algorithm.
    cipher: null,
    // Default. Key builder to retrieve requests.
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    // Default. Allows to cache POST requests.
    // Overriding [keyBuilder] is strongly recommended when [true].
    allowPostMethod: false,
  );

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
    } on DioError catch (e) {
      return AuthUserModal.fromJson(e.response?.data);
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

  Future<UserProfileModal?> authUserUpdate(
      fullname, dateofbirth, gender) async {
    var token = await StorageService().getLoginToken();

    FormData formdata = FormData.fromMap({
      "_method": 'PUT',
      "name": fullname,
      "date_of_birth": dateofbirth,
      "gender": gender,
    });
    try {
      var response = await Dio().post(
        'http://10.0.2.2:8000/api/v1/update/profile',
        data: formdata,
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );
      var responseData = UserProfileModal.fromJson(response.data);
      return responseData;
    } on DioError catch (e) {
      return UserProfileModal.fromJson(e.response?.data);
    }
  }

  Future<ProfileImageModal> imageUpload(image) async {
    var token = await StorageService().getLoginToken();

    var imagefile = MultipartFile.fromFileSync(
      image,
      filename: image.split("/")[image.split("/").length - 1],
    );

    FormData formData = FormData.fromMap({
      "_method": 'PUT',
      "avatar": imagefile,
    });

    try {
      var response = await Dio().post('http://10.0.2.2:8000/api/v1/user-image',
          data: formData,
          options: Options(headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      return ProfileImageModal.fromJson(response.data);
    } on DioError catch (e) {
      return ProfileImageModal.fromJson(e.response?.data);
    }
  }

  Future<List<PodcastModal>?> podcastApi() async {
    var token = await StorageService().getLoginToken();

    try {
      final dio = Dio()
        ..interceptors.add(DioCacheInterceptor(options: optionsdata));
      var response = await dio.get('http://10.0.2.2:8000/api/v1/podcasts',
          options: Options(headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }));

      List<dynamic> list = response.data['data'];
      var returnresponse = list.map((e) => PodcastModal.fromJson(e)).toList();
      return returnresponse;
    } catch (e) {
      return null;
    }
  }

  Future<FeedbackModal?> feedbackregister(email, title, message) async {
    var token = await StorageService().getLoginToken();
    FormData formdata = FormData.fromMap({
      "email": email,
      "title": title,
      "message": message,
    });
    try {
      var response = await Dio().post('http://10.0.2.2:8000/api/v1/feedback',
          data: formdata,
          options: Options(headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      var dataResponse = FeedbackModal.fromJson(response.data);
      return dataResponse;
    } on DioError catch (e) {
      return FeedbackModal.fromJson(e.response?.data);
    }
  }

  Future<List<PodcastModal>?> favouriteApi() async {
    var token = await StorageService().getLoginToken();

    try {
      final dio = Dio()
        ..interceptors.add(DioCacheInterceptor(options: optionsdata));
      var response = await dio.get('http://10.0.2.2:8000/api/v1/user-favourite',
          options: Options(headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }));

      List<dynamic> list = response.data['data'];
      var returnresponse = list.map((e) => PodcastModal.fromJson(e)).toList();
      return returnresponse;
    } catch (e) {
      return null;
    }
  }
}
