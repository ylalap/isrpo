class Buyer {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final DateTime registrationDate;
  final bool isActive;

  Buyer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address = '',
    required this.registrationDate,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'registrationDate': registrationDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'] ?? '',
      registrationDate: DateTime.parse(json['registrationDate']),
      isActive: json['isActive'] ?? true,
    );
  }
}