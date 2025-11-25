class Car {
  final int id;
  final String model;
  final int year;
  final double price;
  final String vin;
  final DateTime dateAdded;
  final bool isAvailable;

  Car({
    required this.id,
    required this.model,
    required this.year,
    required this.price,
    this.vin = '',
    required this.dateAdded,
    this.isAvailable = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'year': year,
      'price': price,
      'vin': vin,
      'dateAdded': dateAdded.toIso8601String(),
      'isAvailable': isAvailable,
    };
  }

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      model: json['model'],
      year: json['year'],
      price: json['price'].toDouble(),
      vin: json['vin'] ?? '',
      dateAdded: DateTime.parse(json['dateAdded']),
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}