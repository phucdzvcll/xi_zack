import 'package:equatable/equatable.dart';

import '../../common/object_parse_ext.dart';

class JoinRoomParam extends Equatable {
  final String? roomId;
  final String? socketId;
  final String? playerId;

  JoinRoomParam({
    this.roomId,
    this.socketId,
    this.playerId,
  });

  factory JoinRoomParam.fromJson(Map<String, dynamic> json) {
    return JoinRoomParam(
      roomId: json.parseString('roomId'),
      socketId: json.parseString('socketId'),
      playerId: json.parseString('playerId'),
    );
  }

  @override
  List<Object?> get props => [
        roomId,
        socketId,
        playerId,
      ];
}
