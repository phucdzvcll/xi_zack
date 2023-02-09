import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:socket_io/socket_io.dart';
import 'package:uuid/uuid.dart';

import 'common/poker_card.dart';
import 'di.dart';
import 'events.dart';
import 'events/create_room/di.dart';
import 'events/join_to_lobby/di.dart';
import 'models/client.dart';
import 'services/socket_service.dart';

List<PokerCard> listCard = [];
final List<Player> players = [];
final _uuid = Uuid();
Player? adminer;
bool isMatching = false;

void _shufflingPoker() {
  listCard.clear();
  listCard.addAll([
    PokerCard.clubA,
    PokerCard.diamondA,
    PokerCard.spaceA,
    PokerCard.heartA,
    PokerCard.space10,
    PokerCard.space10,
  ]);
  listCard.shuffle();
}

void main(List<String> args) async {
  GetIt getIt = GetIt.instance;
  await _systemInit(getIt);
  SocketService service = SocketService(
    server: getIt.get(),
    joinToLobbyHandler: getIt.get(),
    createRoomHandler: getIt.get(),
  );

  service.init();

  // io.on('connection', (client) {
  // _joinEventHandler(client, io);
  // _disconnectHandler(client, io);
  // _beginHandler(client, io);
  // _handleNextTurn(client, io);
  // _handlePlayerPull(client, io);
  // _handlePlayerPet(client, io);
  // (client as Socket).on("changeAdmin", (data) {
  //   var player = _findPlayerById(data["id"]);
  //   if (player != null) {
  //     adminer = player;
  //   }
  // });
  // });
}

Future<void> _systemInit(GetIt injector) async {
  await appDI(injector);
  joinToLobbyDi(injector);
  createRoomDi(injector);
}
//
// void _handlePlayerPet(client, Server io) {
//   client.on("playerPet", (data) {
//     try {
//       var id = data["id"];
//       int pet = data["pet"];
//       final player = _findPlayerById(id);
//       if (player != null) {
//         player.pet = pet;
//         io.emit("playerPet", {"id": id, "pet": pet});
//       }
//     } catch (e) {
//       (client as Socket).emit("error", "Something went wrong!");
//     }
//   });
// }
//
// Player? _findPlayerById(String id) {
//   return players.firstWhereOrNull((element) => element.id == id);
// }
//
// void _handlePlayerPull(client, Server io) {
//   client.on("pull", (data) {
//     try {
//       var id = data["id"];
//       (client as Socket)
//           .broadcast
//           .emit("userPull", {"id": id, "pullAmount": 1});
//       PokerCard cardId = listCard.removeAt(0);
//       var player = _findPlayerById(id);
//       if (player != null) {
//         player.cardIds.add(cardId);
//         if (player.isAdminer) {
//           int value = 0;
//           List<PokerCard> p = [...player.cardIds];
//           p.sort((a, b) {
//             switch (a) {
//               case PokerCard.spaceA:
//               case PokerCard.diamondA:
//               case PokerCard.clubA:
//               case PokerCard.heartA:
//                 return -1;
//               default:
//                 return 1;
//             }
//           });
//           for (var element in p) {
//             value += getCardValue(
//                 cardId: element,
//                 cardAmount: (player.cardIds).length,
//                 currentValue: value);
//           }
//           client.emit("checking", {
//             "enable": value > 15,
//           });
//         }
//         client.emit("cardPull", {
//           "cardId": cardId.name,
//           "id": id,
//         });
//       }
//     } catch (e) {
//       (client as Socket).emit("error", "Something went wrong!");
//     }
//   });
// }
//
// void _disconnectHandler(client, Server io) {
//   client.on(ReceiveEvent.disconnect.name, (reason) {
//     players.removeWhere((element) {
//       return element.socketId == client.id;
//     });
//     io.emit("leave", {"socketId": client.id.toString()});
//   });
// }
//
// void _handleNextTurn(client, Server io) {
//   client.on("endPull", (data) {
//     if (players.length > 1) {
//       String id = data["id"];
//       if (id != adminer?.id) {
//         int index = players.indexWhere((element) => element.id == id);
//         _nextTurn(id, io, client, index);
//       }
//     }
//   });
// }
//
// void _nextTurn(String id, Server io, client, int index) {
//   try {
//     Player player = players[index + 1];
//     if (player.inMatch) {
//       io.emit("nextTurn", {
//         "id": player.id,
//       });
//
//       if (player.isAdminer) {
//         int value = 0;
//         List<PokerCard> p = [...player.cardIds];
//         p.sort((a, b) {
//           switch (a) {
//             case PokerCard.spaceA:
//             case PokerCard.diamondA:
//             case PokerCard.clubA:
//             case PokerCard.heartA:
//               return -1;
//             default:
//               return 1;
//           }
//         });
//         for (var element in p) {
//           value += getCardValue(
//               cardId: element,
//               cardAmount: player.cardIds.length,
//               currentValue: value);
//         }
//         io.to(player.socketId).emit("checking", {
//           "enable": value > 15,
//         });
//       }
//
//       print(player.id);
//     } else {
//       _nextTurn(id, io, client, index + 1);
//     }
//   } catch (e) {
//     (client as Socket).emit("error", "Something went wrong!");
//   }
// }
//
// void _beginHandler(client, Server io) {
//   client.on("begin", (data) {
//     _shufflingPoker();
//     String matchId = _uuid.v4();
//     isMatching = true;
//     io.emit("start", {
//       "matchId": matchId,
//       "isMatching": isMatching,
//     });
//
//     for (var player in players) {
//       player.inMatch = true;
//       PokerCard cardId = listCard.removeAt(0);
//
//       final Socket? socket = io.sockets.sockets
//           .firstWhereOrNull((element) => element.id == player.socketId);
//
//       if (socket != null) {
//         player.cardIds.add(cardId);
//         io.emit("userPull", {"id": player.id, "pullAmount": 1});
//         socket.emit("cardPull", {
//           "cardId": cardId.name,
//           "id": player.id,
//         });
//         print(cardId);
//       }
//     }
//
//     for (var player in players) {
//       if (player.inMatch) {
//         PokerCard cardId = listCard.removeAt(0);
//
//         final Socket? socket = io.sockets.sockets
//             .firstWhereOrNull((element) => element.id == player.socketId);
//
//         if (socket != null) {
//           player.cardIds.add(cardId);
//           io.emit("userPull", {"id": player.id, "pullAmount": 1});
//           socket.emit("cardPull", {
//             "cardId": cardId.name,
//             "id": player.id,
//           });
//           print(cardId);
//         }
//       }
//     }
//     io.emit("nextTurn", {
//       "id": players.first.id,
//     });
//     print(players.first.id);
//   });
// }
//
// void _joinEventHandler(client, Server io) {
//   client.on(ReceiveEvent.join.name, (data) {
//     try {
//       final JoinLobby signInEvent = JoinLobby.fromJson(data);
//       var socketId = client.id;
//
//       final player = Player(
//         name: signInEvent.userName,
//         id: signInEvent.id,
//         socketId: socketId,
//         timeToJoin:
//             signInEvent.utcTimestamp ?? DateTime.now().millisecondsSinceEpoch,
//       );
//       if (players.isEmpty) {
//         adminer = player;
//         adminer!.isAdminer = true;
//         players.add(adminer!);
//         client.emit(
//           SendEvent.allPlayer.name,
//           players.map((e) => e.toJson()).toList(),
//         );
//       } else {
//         final foundPlayer =
//             players.firstWhereOrNull((element) => element.id == signInEvent.id);
//         if (foundPlayer == null) {
//           players.insert(players.length - 1, player);
//           (client as Socket)
//               .broadcast
//               .emit(SendEvent.newPlayerJoined.name, player.toJson());
//           client.emit(
//             SendEvent.allPlayer.name,
//             players.map((e) => e.toJson()).toList(),
//           );
//         } else {
//           (client as Socket)
//               .emit("error", "Lobby soon exists this foundPlayer");
//         }
//       }
//     } catch (e) {
//       (client as Socket).emit("error", "Something went wrong");
//     }
//   });
// }
