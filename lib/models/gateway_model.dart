class GatewayModel {
  String name;
  String ip;
  bool isOnline;
  int ping;

  DateTime? downSince;

  GatewayModel({
    required this.name,
    required this.ip,
    this.isOnline = false,
    this.ping = 0,
    this.downSince,
  });
}