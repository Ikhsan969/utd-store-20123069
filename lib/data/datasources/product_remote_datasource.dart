// lib/data/datasources/product_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  late final Dio _dio;

  ProductRemoteDataSource() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://fakestoreapi.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    // ⭐ Interceptor dengan logger - sesuai soal
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
      ),
    );

    // Interceptor custom tambahan untuk logging NIM
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('📡 [NIM:20123069] Request → ${options.uri}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ [NIM:20123069] Response ${response.statusCode} ← ${response.requestOptions.uri}');
          handler.next(response);
        },
        onError: (error, handler) {
          print('❌ [NIM:20123069] Error: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  Future<List<ProductModel>> fetchProducts() async {
    final response = await _dio.get('/products');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
