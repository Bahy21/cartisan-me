import 'dart:convert';

import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:dio/dio.dart' as dioClient;
import 'package:get/get.dart';

class APIService {
  final dio = dioClient.Dio(
    dioClient.BaseOptions(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': Get.find<AuthService>().userToken,
      },
    ),
  );

  Future<dioClient.Response<T>> get<T>(
    String url,
  ) {
    return dio.get<T>(url);
  }

  Future<dioClient.Response<T>> getPaginate<T>(
    String url,
    dynamic data,
  ) {
    return dio.get<T>(url, data: jsonEncode(data));
  }

  Future<dioClient.Response<T>> post<T>(String url, dynamic data) {
    return dio.post<T>(url, data: data);
  }

  Future<dioClient.Response<T>> put<T>(String url, dynamic data) {
    return dio.put<T>(url, data: data);
  }

  Future<dioClient.Response<T>> delete<T>(String url) {
    return dio.delete<T>(url);
  }
}
