import 'package:canarslan_website/models/pointer_event_details.dart';
import 'package:canarslan_website/services/iframe_service.dart';
import 'package:canarslan_website/services/js_bridge_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AsciiController {
  late final JsBridgeService _jsBridgeService;
  late final IframeService _iframeService;
  final FocusNode focusNode = FocusNode();
  bool isCtrlPressed = false;
  bool isMetaPressed = false;
  bool isPointerDown = false;

  AsciiController() {
    _jsBridgeService = JsBridgeService();
    _iframeService = IframeService(_jsBridgeService);
  }

  void handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      _handleKeyDown(event);
    } else if (event is KeyUpEvent) {
      _handleKeyUp(event);
    }
  }

  void _handleKeyDown(KeyDownEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.controlLeft) {
      isCtrlPressed = true;
    }
    if (event.logicalKey == LogicalKeyboardKey.metaLeft) {
      isMetaPressed = true;
    }

    if ((isCtrlPressed || isMetaPressed) &&
        event.logicalKey == LogicalKeyboardKey.keyC) {
      _jsBridgeService.handleCopy();
    }
  }

  void _handleKeyUp(KeyUpEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.controlLeft) {
      isCtrlPressed = false;
    }
    if (event.logicalKey == LogicalKeyboardKey.metaLeft) {
      isMetaPressed = false;
    }
  }

  void handlePointerEvent(PointerEvent event, RenderBox htmlElementBox) {
    final eventDetails = _createPointerEventDetails(event, htmlElementBox);
    _jsBridgeService.dispatchPointerEvent(eventDetails);
  }

  PointerEventDetails _createPointerEventDetails(
      PointerEvent event, RenderBox htmlElementBox) {
    final localPosition =
        event.position - htmlElementBox.localToGlobal(Offset.zero);

    String eventType;
    if (event is PointerDownEvent) {
      eventType = 'mousedown';
      isPointerDown = true;
      focusNode.requestFocus();
    } else if (event is PointerUpEvent) {
      eventType = 'mouseup';
      isPointerDown = false;
    } else if (event is PointerMoveEvent) {
      eventType = isPointerDown ? 'mousemove' : 'mouseover';
    } else if (event is PointerHoverEvent) {
      eventType = 'mouseover';
    } else {
      throw UnsupportedError('Unsupported pointer event type');
    }

    return PointerEventDetails(
      eventType: eventType,
      position: event.position,
      localPosition: localPosition,
      buttons: event.buttons,
      isPointerDown: isPointerDown,
    );
  }

  void dispose() {
    focusNode.dispose();
  }
}
