import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/car.dart';
import '../models/buyer.dart';
import 'api_service.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final ApiService _apiService = ApiService();
  static const String _carsKey = 'cars';
  static const String _buyersKey = 'buyers';

  // Проверка подключения к API
  Future<bool> isApiConnected() async {
    return await _apiService.checkConnection();
  }

  // Автомобили - сначала пробуем API, потом локальное хранилище
  Future<List<Car>> getCars() async {
    try {
      if (await isApiConnected()) {
        return await _apiService.getCars();
      }
    } catch (e) {
      print('API недоступно, используем локальные данные: $e');
    }
    
    // Fallback на локальное хранилище
    final prefs = await SharedPreferences.getInstance();
    final carsJson = prefs.getStringList(_carsKey) ?? [];
    return carsJson.map((json) => Car.fromJson(jsonDecode(json))).toList();
  }

  Future<void> saveCar(Car car) async {
    try {
      if (await isApiConnected()) {
        await _apiService.addCar(car);
        return;
      }
    } catch (e) {
      print('API недоступно, сохраняем локально: $e');
    }
    
    // Fallback на локальное хранилище
    final prefs = await SharedPreferences.getInstance();
    final cars = await getCars();
    cars.add(car);
    await prefs.setStringList(
      _carsKey,
      cars.map((car) => jsonEncode(car.toJson())).toList(),
    );
  }

  Future<void> deleteCar(int carId) async {
    try {
      if (await isApiConnected()) {
        await _apiService.deleteCar(carId);
        return;
      }
    } catch (e) {
      print('API недоступно, удаляем локально: $e');
    }
    
    // Fallback на локальное хранилище
    final prefs = await SharedPreferences.getInstance();
    final cars = await getCars();
    cars.removeWhere((car) => car.id == carId);
    await prefs.setStringList(
      _carsKey,
      cars.map((car) => jsonEncode(car.toJson())).toList(),
    );
  }

  // Покупатели - аналогичная логика
  Future<List<Buyer>> getBuyers() async {
    try {
      if (await isApiConnected()) {
        return await _apiService.getBuyers();
      }
    } catch (e) {
      print('API недоступно, используем локальные данные: $e');
    }
    
    final prefs = await SharedPreferences.getInstance();
    final buyersJson = prefs.getStringList(_buyersKey) ?? [];
    return buyersJson.map((json) => Buyer.fromJson(jsonDecode(json))).toList();
  }

  Future<void> saveBuyer(Buyer buyer) async {
    try {
      if (await isApiConnected()) {
        await _apiService.addBuyer(buyer);
        return;
      }
    } catch (e) {
      print('API недоступно, сохраняем локально: $e');
    }
    
    final prefs = await SharedPreferences.getInstance();
    final buyers = await getBuyers();
    buyers.add(buyer);
    await prefs.setStringList(
      _buyersKey,
      buyers.map((buyer) => jsonEncode(buyer.toJson())).toList(),
    );
  }

  Future<void> deleteBuyer(int buyerId) async {
    try {
      if (await isApiConnected()) {
        await _apiService.deleteBuyer(buyerId);
        return;
      }
    } catch (e) {
      print('API недоступно, удаляем локально: $e');
    }
    
    final prefs = await SharedPreferences.getInstance();
    final buyers = await getBuyers();
    buyers.removeWhere((buyer) => buyer.id == buyerId);
    await prefs.setStringList(
      _buyersKey,
      buyers.map((buyer) => jsonEncode(buyer.toJson())).toList(),
    );
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_carsKey);
    await prefs.remove(_buyersKey);
  }
}