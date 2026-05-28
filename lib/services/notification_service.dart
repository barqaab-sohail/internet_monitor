import 'package:local_notifier/local_notifier.dart';

class NotificationService {
  static Future init() async {
    await localNotifier.setup(
      appName: 'Internet Monitor',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
  }

  static Future showNotification(String title, String body) async {
    final notification = LocalNotification(title: title, body: body);

    await notification.show();
  }
}
