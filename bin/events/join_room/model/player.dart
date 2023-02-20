class PlayerInRoom {
  final String playerId;
  final String socketId;
  final bool isAdmin;
  final int index;

  PlayerInRoom({
    required this.playerId,
    required this.socketId,
    required this.index,
    this.isAdmin = false,
  });

  factory PlayerInRoom.fromJson(Map<String, dynamic> json) {
    return PlayerInRoom(
      playerId: json['playerId'],
      socketId: json["socketId"],
      isAdmin: json["isAdmin"],
      index: json["index"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "playerId": playerId,
      "socketId": socketId,
      "isAdmin": isAdmin,
      "index": index,
    };
  }

  Map<String, dynamic> toJsonAdmin() {
    return {
      "playerId": playerId,
      "socketId": socketId,
      "isAdmin": isAdmin,
      "index": index,
    };
  }
}
