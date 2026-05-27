import 'package:dart_ping/dart_ping.dart';

class PingService {
  static Future<Map<String, dynamic>> pingHost(String host) async {
    try {
      final ping = Ping(host, count: 1);

      await for (final event in ping.stream) {
        if (event.response != null) {
          return {
            "success": true,
            "ping": event.response!.time?.inMilliseconds ?? 0
          };
        }
      }

      return {
        "success": false,
        "ping": 0
      };
    } catch (e) {
      return {
        "success": false,
        "ping": 0
      };
    }
  }
}