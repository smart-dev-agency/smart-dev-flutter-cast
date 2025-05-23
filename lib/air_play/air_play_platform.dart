import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_dev_flutter_cast/air_play/air_play_event.dart';
import 'package:smart_dev_flutter_cast/air_play/method_channel_air_play.dart';

/// The interface that platform-specific implementations of `flutter_cast_video` must extend.
abstract class AirPlayPlatform {
  static final MethodChannelAirPlay _instance = MethodChannelAirPlay();

  /// The default instance of [AirPlayPlatform] to use.
  ///
  /// Defaults to [MethodChannelAirPlay].
  static get instance => _instance;

  /// Initializes the platform interface with [id].
  ///
  /// This method is called when the plugin is first initialized.
  Future<void> init(int id) {
    throw UnimplementedError('init() has not been implemented.');
  }

  /// The route is opening.
  Stream<RoutesOpeningEvent> onRoutesOpening({required int id}) {
    throw UnimplementedError('onRoutesOpening() has not been implemented.');
  }

  /// The route has closed.
  Stream<RoutesClosedEvent> onRoutesClosed({required int id}) {
    throw UnimplementedError('onRoutesClosed() has not been implemented.');
  }

  /// Returns a widget displaying the button.
  Widget buildView(
    Map<String, dynamic> arguments,
    PlatformViewCreatedCallback onPlatformViewCreated,
  ) {
    throw UnimplementedError('buildView() has not been implemented.');
  }

  Stream<AirplayStateChangedEvent> isAirplayConnected({required int id}) {
    throw UnimplementedError("isAirplayConnect() has not been implemented");
  }
}
