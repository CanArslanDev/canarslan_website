import 'package:canarslan_website/constants/int_constants.dart';
import 'package:get/get.dart';

class FeatureService {
  final playbackRate = IntConstants.animationPlaybackRate;
  Future<void> duration(Duration duration) async {
    if (playbackRate <= 0) {
      throw ArgumentError('playbackRate must be greater than 0');
    }
    await Future<void>.delayed(
        (duration.inMilliseconds ~/ playbackRate).milliseconds);
  }
}
