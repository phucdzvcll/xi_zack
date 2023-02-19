import 'package:socket_io/socket_io.dart';

extension SocketError on Socket {
  void emitError(String mess) {
    emit("SocketError", {"mess": mess});
  }
}
