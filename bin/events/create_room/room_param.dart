import 'package:equatable/equatable.dart';

import '../../common/object_parse_ext.dart';

class RoomParam extends Equatable {
    final String? roomName;

    RoomParam({this.roomName,});

    factory RoomParam.fromJson(Map<String, dynamic> json) {
        return RoomParam(
            roomName: json.parseString('roomName'),
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = {};
        data['roomName'] = roomName;
        return data;
    }

    @override
    List<Object?> get props => [roomName,];
}