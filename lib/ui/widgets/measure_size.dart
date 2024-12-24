import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Typedef for the callback function to notify when the widget's size changes.
typedef OnWidgetSizeChange = void Function(Size size);

// Custom RenderObject that measures the size of the widget's child
//and calls a callback when the size changes.
class MeasureSizeRenderObject extends RenderProxyBox {
  // Constructor that takes a callback function to notify when the size changes.
  MeasureSizeRenderObject(this.onChange);

  // Holds the previous size of the widget.
  Size? oldSize;

  // The callback function to notify when the size changes.
  OnWidgetSizeChange onChange;

  // Overridden method to perform layout and check for size changes.
  @override
  void performLayout() {
    // Calls the superclass's layout method to perform basic layout behavior.
    super.performLayout();

    // Get the current size of the child widget.
    final newSize = child!.size;

    // If the size hasn't changed, no further action is needed.
    if (oldSize == newSize) return;

    // Update the oldSize to the new size.
    oldSize = newSize;

    // Add a post-frame callback to notify the size
    //change after the current frame is drawn.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize); // Call the callback with the new size.
    });
  }
}

// A widget that wraps a child widget and measures its size.
class MeasureSize extends SingleChildRenderObjectWidget {
  // Constructor for the MeasureSize widget, requires
  //the onChange callback and a child widget.
  const MeasureSize({
    required this.onChange, // Callback function that receives the new size
    required Widget super.child, // The child widget whose size will be measured
    super.key, // The key used to uniquely identify this widget
  });

  // The callback function to notify when the size changes.
  final OnWidgetSizeChange onChange;

  // Creates the associated render object to measure the child's size.
  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }

  // Updates the render object if necessary, specifically the callback function.
  @override
  void updateRenderObject(
    BuildContext context,
    covariant MeasureSizeRenderObject renderObject,
  ) {
    renderObject.onChange =
        onChange; // Update the onChange callback of the render object.
  }
}
