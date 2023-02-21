class PlayerInRoom {
  final String playerId;
  final String socketId;
  final bool isAdmin;
  final int index;
  final int pet;

  PlayerInRoom({
    required this.playerId,
    required this.socketId,
    required this.index,
    required this.pet,
    this.isAdmin = false,
  });

  factory PlayerInRoom.fromJson(Map<String, dynamic> json) {
    return PlayerInRoom(
      playerId: json['playerId'],
      socketId: json["socketId"],
      isAdmin: json["isAdmin"],
      index: json["index"],
      pet: json["pet"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "playerId": playerId,
      "socketId": socketId,
      "isAdmin": isAdmin,
      "index": index,
      "pet": pet,
    };
  }
}
