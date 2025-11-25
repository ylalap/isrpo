import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/car.dart';
import '../models/buyer.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = ApiConfig.apiBaseUrl});

  // Для обработки SSL сертификатов в development
  static http.Client get httpClient {
    return http.Client();
  }

  // Проверка подключения к API
  Future<bool> checkConnection() async {
    try {
      final response = await httpClient.get(
        Uri.parse(ApiConfig.baseUrl),
        headers: ApiConfig.headers,
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Работа с автомобилями через API
  Future<List<Car>> getCars() async {
    try {
      final response = await httpClient.get(
        Uri.parse(ApiConfig.carsEndpoint),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Car.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cars: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load cars: $e');
    }
  }

  Future<Car> addCar(Car car) async {
    try {
      final response = await httpClient.post(
        Uri.parse(ApiConfig.carsEndpoint),
        headers: ApiConfig.headers,
        body: json.encode(car.toJson()),
      );

      if (response.statusCode == 201) {
        return Car.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add car: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add car: $e');
    }
  }

  Future<void> deleteCar(int carId) async {
    try {
      final response = await httpClient.delete(
        Uri.parse('${ApiConfig.carsEndpoint}/$carId'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete car: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete car: $e');
    }
  }

  // Работа с покупателями через API
  Future<List<Buyer>> getBuyers() async {
    try {
      final response = await httpClient.get(
        Uri.parse(ApiConfig.buyersEndpoint),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Buyer.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load buyers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load buyers: $e');
    }
  }

  Future<Buyer> addBuyer(Buyer buyer) async {
    try {
      final response = await httpClient.post(
        Uri.parse(ApiConfig.buyersEndpoint),
        headers: ApiConfig.headers,
        body: json.encode(buyer.toJson()),
      );

      if (response.statusCode == 201) {
        return Buyer.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add buyer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add buyer: $e');
    }
  }

  Future<void> deleteBuyer(int buyerId) async {
    try {
      final response = await httpClient.delete(
        Uri.parse('${ApiConfig.buyersEndpoint}/$buyerId'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete buyer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete buyer: $e');
    }
  }
}