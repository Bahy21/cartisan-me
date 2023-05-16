import 'dart:convert';
import 'dart:developer';

import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:dio/dio.dart' as dioClient;
import 'package:get/get.dart';

const BASE_URL =
    'https://us-central1-cloud-function-practice-f911f.cloudfunctions.net/app/v1/api';

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
    String url, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.get<T>(url, queryParameters: queryParameters);
  }

  Future<dioClient.Response<T>> getPaginate<T>(
    String url,
    Map<String, dynamic> queryParameters,
  ) {
    return dio.get<T>(url, queryParameters: queryParameters);
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
