import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';

// TODO [FUTURE IMPROVEMENT] : Handle background process after retrive notif here
// Current behavior is, the whole process will begin after user click the notif even if the notif is from background or terminated

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  appLogger.i("BG message: ${message.data}");
}
