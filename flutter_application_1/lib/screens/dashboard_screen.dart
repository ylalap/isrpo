import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/car.dart';
import '../models/buyer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DataService _dataService = DataService();
  List<Car> _cars = [];
  List<Buyer> _buyers = [];
  bool _isApiConnected = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _checkApiConnection();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    final cars = await _dataService.getCars();
    final buyers = await _dataService.getBuyers();
    
    setState(() {
      _cars = cars;
      _buyers = buyers;
      _isLoading = false;
    });
  }

  Future<void> _checkApiConnection() async {
    final isConnected = await _dataService.isApiConnected();
    setState(() {
      _isApiConnected = isConnected;
    });
  }

  double get _totalRevenue {
    return _cars.fold(0, (sum, car) => sum + car.price);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Статус API
          Card(
            color: _isApiConnected ? Colors.green[50] : Colors.orange[50],
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    _isApiConnected ? Icons.cloud_done : Icons.cloud_off,
                    color: _isApiConnected ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isApiConnected 
                        ? '✅ Подключено к бэкенд API (localhost:7281)' 
                        : '❌ Бэкенд API недоступен. Используются локальные данные.',
                      style: TextStyle(
                        color: _isApiConnected ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _checkApiConnection,
                    iconSize: 20,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else ...[
            // Статистика
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard(
                  'Всего автомобилей',
                  _cars.length.toString(),
                  Colors.blue,
                  Icons.directions_car,
                ),
                _buildStatCard(
                  'Активные покупатели',
                  _buyers.length.toString(),
                  Colors.green,
                  Icons.people,
                ),
                _buildStatCard(
                  'Продажи за месяц',
                  '0',
                  Colors.orange,
                  Icons.trending_up,
                ),
                _buildStatCard(
                  'Общая выручка',
                  '${_totalRevenue.toStringAsFixed(0)}₽',
                  Colors.red,
                  Icons.attach_money,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Быстрые действия
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Быстрые действия',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildActionButton(
                          'Добавить автомобиль',
                          Icons.add,
                          Colors.blue,
                          () {
                            Navigator.pushNamed(context, '/cars');
                          },
                        ),
                        _buildActionButton(
                          'Добавить покупателя',
                          Icons.person_add,
                          Colors.green,
                          () {
                            Navigator.pushNamed(context, '/buyers');
                          },
                        ),
                        _buildActionButton(
                          'Создать отчет',
                          Icons.description,
                          Colors.orange,
                          () {
                            _showSnackBar('Функция создания отчета');
                          },
                        ),
                        _buildActionButton(
                          'Проверить API',
                          Icons.api,
                          Colors.purple,
                          _checkApiConnection,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Последние действия
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Последние действия',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRecentActivity(),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildRecentActivity() {
    if (_cars.isEmpty && _buyers.isEmpty) {
      return const Center(
        child: Text(
          'Данных пока нет. Добавьте первый автомобиль или покупателя.',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    final activities = <Widget>[];

    // Добавляем последние автомобили
    for (final car in _cars.take(3)) {
      activities.add(
        ListTile(
          leading: const Icon(Icons.directions_car, color: Colors.blue),
          title: Text('Добавлен автомобиль: ${car.model}'),
          subtitle: Text('Дата: ${_formatDate(car.dateAdded)}'),
        ),
      );
    }

    // Добавляем последних покупателей
    for (final buyer in _buyers.take(3)) {
      activities.add(
        ListTile(
          leading: const Icon(Icons.person, color: Colors.green),
          title: Text('Новый покупатель: ${buyer.name}'),
          subtitle: Text('Дата: ${_formatDate(buyer.registrationDate)}'),
        ),
      );
    }

    return Column(children: activities);
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}