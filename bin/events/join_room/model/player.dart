class PlayerInRoom {
  final String playerId;
  final String socketId;
  final bool isAdmin;

  PlayerInRoom({
    required this.playerId,
    required this.socketId,
    this.isAdmin = false,
  });

  factory PlayerInRoom.fromJson(Map<String, dynamic> json) {
    return PlayerInRoom(
      playerId: json['playerId'],
      socketId: json["socketId"],
      isAdmin: json["isAdmin"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "playerId": playerId,
      "socketId": socketId,
      "isAdmin": isAdmin,
    };
  }

  Map<String, dynamic> toJsonAdmin() {
    return {
      "playerId": playerId,
      "socketId": socketId,
      "isAdmin": isAdmin,
    };
  }
}
