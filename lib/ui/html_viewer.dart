import 'package:canarslan_website/controllers/projects_controller/ascii_controller.dart';
import 'package:canarslan_website/ui/iframe_view.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class HtmlViewer extends StatelessWidget {
  const HtmlViewer({
    required this.controller,
    super.key,
  });
  final AsciiController controller;

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: controller.focusNode,
      onKeyEvent: controller.handleKeyEvent,
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const IframeView(),
          ),
          _buildPointerInterceptor(context),
        ],
      ),
    );
  }

  Widget _buildPointerInterceptor(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: PointerInterceptor(
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (event) => _handlePointerEvent(event, context),
          onPointerMove: (event) => _handlePointerEvent(event, context),
          onPointerUp: (event) => _handlePointerEvent(event, context),
          onPointerHover: (event) => _handlePointerEvent(event, context),
          child: _buildGradientOverlay(context),
        ),
      ),
    );
  }

  Widget _buildGradientOverlay(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [Colors.transparent, Colors.black],
          stops: [0.0, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color(0xFF071235),
      ),
    );
  }

  void _handlePointerEvent(PointerEvent event, BuildContext context) {
    final htmlElementBox = context.findRenderObject() as RenderBox?;
    if (htmlElementBox == null) return;

    controller.handlePointerEvent(event, htmlElementBox);
  }
}
