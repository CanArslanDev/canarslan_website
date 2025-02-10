import 'package:flutter/material.dart';

class PointerEventDetails {
  final String eventType;
  final Offset position;
  final Offset localPosition;
  final int buttons;
  final bool isPointerDown;

  PointerEventDetails({
    required this.eventType,
    required this.position,
    required this.localPosition,
    required this.buttons,
    required this.isPointerDown,
  });
}
