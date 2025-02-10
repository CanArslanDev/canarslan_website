import 'package:canarslan_website/services/js_bridge_service.dart';

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

class IframeService {
  static const String viewID = 'ascii-video-player';
  late html.IFrameElement iframeElement;
  final JsBridgeService _jsBridgeService;

  IframeService(this._jsBridgeService) {
    _registerIframeView();
  }

  void _registerIframeView() {
    ui_web.platformViewRegistry.registerViewFactory(viewID, (int viewId) {
      iframeElement = html.IFrameElement()
        ..src = 'assets/web/index.html'
        ..style.border = 'none'
        ..style.height = '100%'
        ..style.width = '100%';

      // JsBridgeService'e iframeElement'i set et
      _jsBridgeService.setIframeElement(iframeElement);

      return iframeElement;
    });
  }
}
