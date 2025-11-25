class ApiConfig {
  static const String baseUrl = 'https://localhost:5186';
  static const String apiBaseUrl = '$baseUrl/api';
  
  // Endpoints
  static const String carsEndpoint = '$apiBaseUrl/cars';
  static const String buyersEndpoint = '$apiBaseUrl/buyers';
  static const String salesEndpoint = '$apiBaseUrl/sales';
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}