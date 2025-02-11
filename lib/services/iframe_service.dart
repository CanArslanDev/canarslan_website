import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:canarslan_website/services/js_bridge_service.dart';

class IframeService {
  IframeService(this._jsBridgeService) {
    _registerIframeView();
  }
  static const String viewID = 'ascii-video-player';
  late html.IFrameElement iframeElement;
  final JsBridgeService _jsBridgeService;

  void _registerIframeView() {
    String iframeSrc = Uri.base.resolve('assets/web/index.html').toString();
    ui_web.platformViewRegistry.registerViewFactory(viewID, (int viewId) {
      iframeElement = html.IFrameElement()
        ..src = iframeSrc
        ..style.border = 'none'
        ..style.height = '100%'
        ..style.width = '100%';

      // JsBridgeService'e iframeElement'i set et
      _jsBridgeService.setIframeElement(iframeElement);

      return iframeElement;
    });
  }
}
