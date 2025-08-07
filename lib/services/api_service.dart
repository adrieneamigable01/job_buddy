import '../../helpers/http_helper.dart';

abstract class APIService {
  Future<dynamic> get(Uri url);
  Future<dynamic> post(Uri url, Object payload);
}

class APIServiceRepo implements APIService {
  final HttpHelper _httpHelper = HttpHelper();

  @override
  Future<dynamic> get(Uri url) async {
    return await _httpHelper.httpGetRequest(url: url);
  }

  @override
  Future<dynamic> post(Uri url, Object payload) async {
    return await _httpHelper.postRequest(url: url, payload: payload);
  }
}