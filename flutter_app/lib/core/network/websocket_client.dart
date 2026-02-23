import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zippy_ride/core/config/app_config.dart';

final webSocketProvider = Provider<WebSocketClient>((ref) => WebSocketClient());

class WebSocketClient {
  WebSocketChannel? _channel;
  final _eventController = StreamController<Map<String, dynamic>>.broadcast();
  bool _isConnected = false;

  Stream<Map<String, dynamic>> get events => _eventController.stream;
  bool get isConnected => _isConnected;

  Future<void> connect(String token) async {
    final uri = Uri.parse('${AppConfig.wsBaseUrl}?token=$token');
    _channel = WebSocketChannel.connect(uri);

    _channel!.stream.listen(
      (data) {
        final decoded = jsonDecode(data as String) as Map<String, dynamic>;
        _eventController.add(decoded);
      },
      onDone: () {
        _isConnected = false;
        // Auto-reconnect after 3 seconds
        Future.delayed(const Duration(seconds: 3), () => connect(token));
      },
      onError: (error) {
        _isConnected = false;
      },
    );

    _isConnected = true;
  }

  void send(String event, Map<String, dynamic> data) {
    if (_channel != null && _isConnected) {
      _channel!.sink.add(jsonEncode({'event': event, 'data': data}));
    }
  }

  Stream<Map<String, dynamic>> on(String event) {
    return events.where((e) => e['event'] == event);
  }

  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
  }

  void dispose() {
    disconnect();
    _eventController.close();
  }
}
