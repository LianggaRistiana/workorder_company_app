class AppConfig {
  static const String appName = "Work Order Company App";
  static const String appFlavor = "production.v1";

  // network
  static const Map<String, String> baseApiUrls = {
    'development': 'http://10.0.2.2:3000',
    'production.v1': 'https://workorder-portal-production-4d0a.up.railway.app',
    'production.v2': 'https://workorder-production.up.railway.app',
  };
  static const Map<String, String> serverCodeNames = {
    'development': 'Local',
    'production.v1': 'Primary-Server-v1',
    'production.v2': 'Primary-Server-v2',
  };

  static String get baseApiUrl => baseApiUrls[appFlavor]!;
  static String get serverCodeName => serverCodeNames[appFlavor]!;
  
  static const int receivedTimeout = 10;
  static const int connectTimeout = 10;

  static const websiteUrl = 'https://workorder-service-production.up.railway.app/';
}
