import 'package:equatable/equatable.dart';

import '../../common/object_parse_ext.dart';

class RoomParam extends Equatable {
  final String? roomName;
  final String? playerId;

  RoomParam({this.roomName, this.playerId});

  factory RoomParam.fromJson(Map<String, dynamic> json) {
    return RoomParam(
      roomName: json.parseString('roomName'),
      playerId: json.parseString('playerId'),
    );
  }

  @override
  List<Object?> get props => [
        roomName,
        playerId,
      ];
}
