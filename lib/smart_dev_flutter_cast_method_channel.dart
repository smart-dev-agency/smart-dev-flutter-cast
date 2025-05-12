import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'smart_dev_flutter_cast_platform_interface.dart';

/// An implementation of [SmartDevFlutterCastPlatform] that uses method channels.
class MethodChannelSmartDevFlutterCast extends SmartDevFlutterCastPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('smart_dev_flutter_cast');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
