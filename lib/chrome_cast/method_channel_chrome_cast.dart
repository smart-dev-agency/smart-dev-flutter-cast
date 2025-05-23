import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_dev_flutter_cast/chrome_cast/chrome_cast_event.dart';
import 'package:smart_dev_flutter_cast/chrome_cast/chrome_cast_platform.dart';
import 'package:stream_transform/stream_transform.dart';

/// An implementation of [ChromeCastPlatform] that uses [MethodChannel] to communicate with the native code.
class MethodChannelChromeCast extends ChromeCastPlatform {
  // Keep a collection of id -> channel
  // Every method call passes the int id
  final Map<int, MethodChannel?> _channels = {};

  /// Accesses the MethodChannel associated to the passed id.
  MethodChannel? channel(int? id) {
    return _channels[id!];
  }

  // The controller we need to broadcast the different events coming
  // from handleMethodCall.
  //
  // It is a `broadcast` because multiple controllers will connect to
  // different stream views of this Controller.
  final _eventStreamController = StreamController<ChromeCastEvent>.broadcast();

  // Returns a filtered view of the events in the _controller, by id.
  Stream<ChromeCastEvent> _events(int? id) =>
      _eventStreamController.stream.where((event) => event.id == id);

  @override
  Future<void> init(int id) {
    MethodChannel? channel;
    if (!_channels.containsKey(id)) {
      channel = MethodChannel('smart_dev_flutter_cast/chromeCast_$id');
      channel.setMethodCallHandler((call) => _handleMethodCall(call, id));
      _channels[id] = channel;
    }
    return channel!.invokeMethod<void>('chromeCast#wait');
  }

  @override
  Future<void> addSessionListener({int? id}) {
    return channel(id)!.invokeMethod<void>('chromeCast#addSessionListener');
  }

  @override
  Future<void> removeSessionListener({int? id}) {
    return channel(id)!.invokeMethod<void>('chromeCast#removeSessionListener');
  }

  @override
  Stream<SessionStartedEvent> onSessionStarted({int? id}) {
    return _events(id).whereType<SessionStartedEvent>();
  }

  @override
  Stream<SessionEndedEvent> onSessionEnded({int? id}) {
    return _events(id).whereType<SessionEndedEvent>();
  }

  @override
  Stream<RequestDidCompleteEvent> onRequestCompleted({int? id}) {
    return _events(id).whereType<RequestDidCompleteEvent>();
  }

  @override
  Stream<RequestDidFailEvent> onRequestFailed({int? id}) {
    return _events(id).whereType<RequestDidFailEvent>();
  }

  @override
  Stream<PlayerStatusDidUpdatedEvent> onPlayerStatusUpdated({int? id}) {
    return _events(id).whereType<PlayerStatusDidUpdatedEvent>();
  }

  @override
  Future<void> loadMedia(
    String url,
    String title,
    String subtitle,
    String image, {
    bool? live,
    required int id,
  }) {
    final Map<String, dynamic> args = {
      'url': url,
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'live': live,
    };
    return channel(id)!.invokeMethod<void>('chromeCast#loadMedia', args);
  }

  @override
  Future<void> play({required int id}) {
    return channel(id)!.invokeMethod<void>('chromeCast#play');
  }

  @override
  Future<void> pause({required int id}) {
    return channel(id)!.invokeMethod<void>('chromeCast#pause');
  }

  @override
  Future<void> seek(bool relative, double interval, {required int id}) {
    final Map<String, dynamic> args = {
      'relative': relative,
      'interval': interval,
    };
    return channel(id)!.invokeMethod<void>('chromeCast#seek', args);
  }

  @override
  Future<void> setVolume(double volume, {required int id}) {
    final Map<String, dynamic> args = {'volume': volume};
    return channel(id)!.invokeMethod<void>('chromeCast#setVolume', args);
  }

  @override
  Future<Map<dynamic, dynamic>?> getMediaInfo({required int id}) async {
    return (await channel(
      id,
    )!.invokeMethod<Map<dynamic, dynamic>?>('chromeCast#getMediaInfo'));
  }

  @override
  Future<double> getVolume({required int id}) async {
    return (await channel(id)!.invokeMethod<double>('chromeCast#getVolume')) ??
        0;
  }

  @override
  Future<void> stop({int? id}) {
    return channel(id)!.invokeMethod<void>('chromeCast#stop');
  }

  @override
  Future<bool?> isConnected({required int id}) {
    return channel(id)!.invokeMethod<bool>('chromeCast#isConnected');
  }

  @override
  Future<void> endSession({required int id}) {
    return channel(id)!.invokeMethod<void>('chromeCast#endSession');
  }

  @override
  Future<bool?> isPlaying({required int id}) {
    return channel(id)!.invokeMethod<bool>('chromeCast#isPlaying');
  }

  @override
  Future<Duration> position({required int id}) async {
    return Duration(
      milliseconds:
          (await channel(id)!.invokeMethod<int>('chromeCast#position')) ?? 0,
    );
  }

  @override
  Future<Duration> duration({required int id}) async {
    return Duration(
      milliseconds:
          (await channel(id)!.invokeMethod<int>('chromeCast#duration')) ?? 0,
    );
  }

  Future<dynamic> _handleMethodCall(MethodCall call, int id) async {
    switch (call.method) {
      case 'chromeCast#didStartSession':
        _eventStreamController.add(SessionStartedEvent(id));
        break;
      case 'chromeCast#didEndSession':
        _eventStreamController.add(SessionEndedEvent(id));
        break;
      case 'chromeCast#requestDidComplete':
        _eventStreamController.add(RequestDidCompleteEvent(id));
        break;
      case 'chromeCast#requestDidFail':
        _eventStreamController.add(
          RequestDidFailEvent(id, call.arguments['error']),
        );
        break;
      case 'chromeCast#didPlayerStatusUpdated':
        var arg = 0;
        if (call.arguments is int?) arg = call.arguments ?? 0;

        _eventStreamController.add(PlayerStatusDidUpdatedEvent(id, arg));
        break;
      default:
        throw MissingPluginException();
    }
  }

  @override
  Widget buildView(
    Map<String, dynamic> arguments,
    PlatformViewCreatedCallback onPlatformViewCreated,
  ) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'ChromeCastButton',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: arguments,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'ChromeCastButton',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: arguments,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text('$defaultTargetPlatform is not supported by ChromeCast plugin');
  }
}
