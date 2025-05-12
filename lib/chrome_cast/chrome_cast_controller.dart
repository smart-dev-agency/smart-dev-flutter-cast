import 'package:smart_dev_flutter_cast/chrome_cast/chrome_cast_platform.dart';

final ChromeCastPlatform chromeCastPlatform = ChromeCastPlatform.instance;

/// Controller for a single ChromeCastButton instance running on the host platform.
class ChromeCastController {
  /// The id for this controller
  final int id;

  ChromeCastController._({required this.id});

  /// Initialize control of a [ChromeCastButton] with [id].
  static Future<ChromeCastController> init(int id) async {
    await chromeCastPlatform.init(id);
    return ChromeCastController._(id: id);
  }

  /// Add listener for receive callbacks.
  Future<void> addSessionListener() {
    return chromeCastPlatform.addSessionListener(id: id);
  }

  /// Remove listener for receive callbacks.
  Future<void> removeSessionListener() {
    return chromeCastPlatform.removeSessionListener(id: id);
  }

  /// Load a new media by providing an [url].
  Future<void> loadMedia(
    String url, {
    String title = '',
    String subtitle = '',
    String image = '',
    bool? live,
  }) {
    return chromeCastPlatform.loadMedia(
      url,
      title,
      subtitle,
      image,
      id: id,
      live: live,
    );
  }

  /// Plays the video playback.
  Future<void> play() {
    return chromeCastPlatform.play(id: id);
  }

  /// Pauses the video playback.
  Future<void> pause() {
    return chromeCastPlatform.pause(id: id);
  }

  /// If [relative] is set to false sets the video position to an [interval] from the start.
  ///
  /// If [relative] is set to true sets the video position to an [interval] from the current position.
  Future<void> seek({bool relative = false, double interval = 10.0}) {
    return chromeCastPlatform.seek(relative, interval, id: id);
  }

  /// Set volume 0-1
  Future<void> setVolume({double volume = 0}) {
    return chromeCastPlatform.setVolume(volume, id: id);
  }

  /// Get current volume
  Future<Map<dynamic, dynamic>?> getMediaInfo() {
    return chromeCastPlatform.getMediaInfo(id: id);
  }

  /// Get current volume
  Future<double> getVolume() {
    return chromeCastPlatform.getVolume(id: id);
  }

  /// Stop the current video.
  Future<void> stop() {
    return chromeCastPlatform.stop(id: id);
  }

  /// Returns `true` when a cast session is connected, `false` otherwise.
  Future<bool?> isConnected() {
    return chromeCastPlatform.isConnected(id: id);
  }

  /// End current session
  Future<void> endSession() {
    return chromeCastPlatform.endSession(id: id);
  }

  /// Returns `true` when a cast session is playing, `false` otherwise.
  Future<bool?> isPlaying() {
    return chromeCastPlatform.isPlaying(id: id);
  }

  /// Returns current position.
  Future<Duration> position() {
    return chromeCastPlatform.position(id: id);
  }

  /// Returns video duration.
  Future<Duration> duration() {
    return chromeCastPlatform.duration(id: id);
  }
}
