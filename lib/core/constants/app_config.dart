class AppConfig {
  static const String appName = "Work Order Company App";
  static const String appVersion = "1.0.0";
  static const String appFlavor = "development"; // development, staging, production

  // network
  static const Map<String, String> baseApiUrls = {
    'development': 'http://10.0.2.2:3000',
    'staging': 'https://staging.api.example.com/v1',
    'production': 'https://api.example.com/v1',
  };

  static String get baseApiUrl => baseApiUrls[appFlavor]!;
  static const int receivedTimeout = 10;
  static const int connectTimeout = 10;
  
  
}