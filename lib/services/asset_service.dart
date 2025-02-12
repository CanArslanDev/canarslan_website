import 'package:flutter/foundation.dart';

class AssetService {
  static String assetPath = '../assets${kReleaseMode ? '/assets' : ''}';
}
