class LogModel {
  String gatewayName;
  String gatewayIp;
  String status;
  DateTime datetime;
  int durationMinutes;

  LogModel({
    required this.gatewayName,
    required this.gatewayIp,
    required this.status,
    required this.datetime,
    this.durationMinutes = 0,
  });
}