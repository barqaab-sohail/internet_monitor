class GatewayReport {
  String gatewayName;
  String gatewayIp;

  int downCount;
  int totalDowntime;

  GatewayReport({
    required this.gatewayName,
    required this.gatewayIp,
    required this.downCount,
    required this.totalDowntime,
  });
}
