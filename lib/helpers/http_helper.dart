import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:job_buddy/models/user_model.dart';
import 'package:job_buddy/pages/splash_page.dart';

class HttpHelper {

   final UserBox _userBox = UserBox();

  

  Future<dynamic> postRequest(
      {required Uri url, required Object payload}) async {
      
    
    try {

         Map<String, String> headers = {
          HttpHeaders.contentTypeHeader: 'application/json',
        };
        
        if (!_userBox.isEmpty) {
          headers.putIfAbsent(HttpHeaders.authorizationHeader,
              () => 'Bearer ${_userBox.data.accesstoken}');
        }

       Map<String, dynamic> jsonMap;
      if (payload is String) {
        jsonMap = jsonDecode(payload);
      } else if (payload is Map<String, dynamic>) {
        jsonMap = payload;
      } else {
        throw ArgumentError('Unsupported payload type');
      }

      print('http post request:$url');
      print('http post payload:$jsonMap');
      Object body = jsonMap;
      Response response =
          await post(url, body: jsonEncode(body), headers: headers);
          
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = response.body;
        var jsonData = jsonDecode(data);
        return jsonData;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      print('http catch error:$e');
    }
  }

  Future<dynamic> httpGetRequest({required Uri url,Map<String, String> queryParameters = const {}}) async {
    try {

      print('http get request:$url');
      final updatedParams = Map<String, String>.from(queryParameters);

       Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: 'application/json'
      };

      if (!_userBox.isEmpty) {
        headers[HttpHeaders.authorizationHeader] =
          'Bearer ${_userBox.data.accesstoken}';
      }
    

      print('queryParameters2:$queryParameters');
      print('headers:$headers');

      Uri updatedUri = url.replace(queryParameters: updatedParams);


      print('http get updatedUri:$updatedUri');
      Response response = await get(updatedUri, headers: headers);
       print('actual response :${response.body}');
       print('actual response statusCode :${response.statusCode}');
      if (response.statusCode == 200) {
        var data = response.body;
        var jsonData = jsonDecode(data);
        return jsonData;
      }else if (response.statusCode == 401) {
        var data = response.body;
        var jsonData = jsonDecode(data);
        return jsonData;
      } else {
        print(response.body);
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print('http catch error:$e');
       return 'http catch error:$e';
    }
  }

  Future<String> convertImageUrlToBase64(Uri url) async {
    Response response = await get(url);

    return base64Encode(response.bodyBytes);
  }
}