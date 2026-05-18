class AppConfig {
  static const String appName = "Work Order Company App";
  static const String appVersion = "1.0.0";
  static const String appFlavor = "production";

  // network
  static const Map<String, String> baseApiUrls = {
    'development': 'http://10.0.2.2:3000',
    'development.device': 'http://127.0.0.1:3000',
    'development.linx': 'http://192.168.1.14:3000',
    'development.rama': 'http://192.168.1.11:3000',
    'development.dede': 'http://192.168.1.193:3000',
    'development.ngrok': 'http://172.16.153.108:3000',
    'staging': 'https://workorder-team.vercel.app/',
    'production': 'https://workorder-portal-production-4d0a.up.railway.app',
  };

  static String get baseApiUrl => baseApiUrls[appFlavor]!;
  static const int receivedTimeout = 10;
  static const int connectTimeout = 10;

  static const websiteUrl = 'https://work-order-service.vercel.app/';
}
