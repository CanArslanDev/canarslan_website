import 'dart:ui_web' as ui_web;

import 'package:canarslan_website/services/asset_service.dart';
import 'package:canarslan_website/services/js_bridge_service.dart';
import 'package:web/web.dart' as web;

class IframeService {
  IframeService(this._jsBridgeService) {
    _registerIframeView();
  }
  static const String viewID = 'ascii-video-player';
  late web.HTMLIFrameElement iframeElement;
  final JsBridgeService _jsBridgeService;

  void _registerIframeView() {
    ui_web.platformViewRegistry.registerViewFactory(viewID, (int viewId) {
      iframeElement = web.HTMLIFrameElement()
        ..src = '${AssetService.assetPath}/web/index.html'
        ..allow = 'autoplay; fullscreen';
      iframeElement.style
        ..border = 'none'
        ..height = '100%'
        ..width = '100%';

      _jsBridgeService.setIframeElement(iframeElement);

      return iframeElement;
    });
  }
}
