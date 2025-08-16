import 'package:flutter/material.dart';

/// A simple widget that displays a loading indicator over its child.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          // A translucent black overlay
          const Opacity(
            opacity: 0.7,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (isLoading)
          // The centered loading spinner
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}