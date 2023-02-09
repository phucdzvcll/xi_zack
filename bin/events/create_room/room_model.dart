import 'package:equatable/equatable.dart';

import '../../common/object_parse_ext.dart';

class Room extends Equatable {
    final String? roomName;

    Room({this.roomName,});

    factory Room.fromJson(Map<String, dynamic> json) {
        return Room(
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