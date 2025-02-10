import 'package:canarslan_website/services/iframe_service.dart';
import 'package:flutter/material.dart';

class IframeView extends StatelessWidget {
  const IframeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HtmlElementView(
      viewType: IframeService.viewID,
    );
  }
}
