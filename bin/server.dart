import 'dart:io';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

var _webSocketHandler = webSocketHandler(
  (WebSocketChannel webSocket) {
    print("webSocket connect $webSocket");
    webSocket.stream.listen(
      (message) async {
        if (message == "1") {
          webSocket.sink.add("hello");
        }
      },
      onError: (error) {},
      onDone: () {},
    );
  },
  pingInterval: Duration(seconds: 30),
);

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final serverWebSocket = await shelf_io.serve(_webSocketHandler, ip, 8081);
  print(
      'Serving at ws://${serverWebSocket.address.host}:${serverWebSocket.port}');
}
