import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/car.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final DataService _dataService = DataService();
  List<Car> _cars = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final cars = await _dataService.getCars();
    setState(() {
      _cars = cars;
    });
  }

  Map<String, int> get _brandDistribution {
    final distribution = <String, int>{};
    for (final car in _cars) {
      final brand = car.model.split(' ').first;
      distribution[brand] = (distribution[brand] ?? 0) + 1;
    }
    return distribution;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Статистика по брендам
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Распределение по маркам',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBrandDistribution(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Общая статистика
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Общая статистика',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildOverallStats(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Информация о системе
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Информация о системе',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSystemInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandDistribution() {
    final distribution = _brandDistribution;
    
    if (distribution.isEmpty) {
      return const Center(
        child: Text(
          'Нет данных для анализа',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      children: distribution.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(entry.key),
              ),
              Expanded(
                flex: 5,
                child: LinearProgressIndicator(
                  value: entry.value / _cars.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getColorForBrand(entry.key),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '${((entry.value / _cars.length) * 100).toStringAsFixed(1)}%',
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOverallStats() {
    final totalCars = _cars.length;
    final totalValue = _cars.fold(0.0, (sum, car) => sum + car.price);
    final averagePrice = totalCars > 0 ? totalValue / totalCars : 0;

    return Column(
      children: [
        _buildStatRow('Всего автомобилей', totalCars.toString()),
        _buildStatRow('Общая стоимость', '${totalValue.toStringAsFixed(0)}₽'),
        _buildStatRow('Средняя цена', '${averagePrice.toStringAsFixed(0)}₽'),
        _buildStatRow('Самый дорогой', _getMostExpensiveCar()),
        _buildStatRow('Самый старый', _getOldestCar()),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSystemInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Бэкенд API:', 'https://localhost:7281/swagger/index.html'),
        _buildInfoRow('Статус:', 'Фронтенд готов к работе'),
        _buildInfoRow('Версия:', '1.0.0'),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: () {
              _dataService.clearAllData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Все данные очищены')),
              );
              _loadData();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Очистить все данные'),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Color _getColorForBrand(String brand) {
    final colors = {
      'Toyota': Colors.blue,
      'Honda': Colors.green,
      'Ford': Colors.red,
      'BMW': Colors.orange,
      'Audi': Colors.purple,
      'Mercedes': Colors.black,
    };
    return colors[brand] ?? Colors.grey;
  }

  String _getMostExpensiveCar() {
    if (_cars.isEmpty) return 'Нет данных';
    final mostExpensive = _cars.reduce(
      (a, b) => a.price > b.price ? a : b,
    );
    return '${mostExpensive.model} (${mostExpensive.price.toStringAsFixed(0)}₽)';
  }

  String _getOldestCar() {
    if (_cars.isEmpty) return 'Нет данных';
    final oldest = _cars.reduce(
      (a, b) => a.year < b.year ? a : b,
    );
    return '${oldest.model} (${oldest.year}г.)';
  }
}