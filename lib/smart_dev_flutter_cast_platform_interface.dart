import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'smart_dev_flutter_cast_method_channel.dart';

abstract class SmartDevFlutterCastPlatform extends PlatformInterface {
  /// Constructs a SmartDevFlutterCastPlatform.
  SmartDevFlutterCastPlatform() : super(token: _token);

  static final Object _token = Object();

  static SmartDevFlutterCastPlatform _instance = MethodChannelSmartDevFlutterCast();

  /// The default instance of [SmartDevFlutterCastPlatform] to use.
  ///
  /// Defaults to [MethodChannelSmartDevFlutterCast].
  static SmartDevFlutterCastPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SmartDevFlutterCastPlatform] when
  /// they register themselves.
  static set instance(SmartDevFlutterCastPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
