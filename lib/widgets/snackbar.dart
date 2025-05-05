import 'package:flutter/material.dart';

class MySnackbar extends StatefulWidget {
  final String message;
  final Duration duration;

  const MySnackbar({
    super.key,
    required this.message,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<MySnackbar> createState() => _MySnackbarState();
}

class _MySnackbarState extends State<MySnackbar> {
  bool _isHovered = false;
  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    _showOverlay();
  }

  void _showOverlay() {
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry);

    Future.delayed(widget.duration, () {
      if (!_isHovered) {
        _overlayEntry.remove();
      }
    });
  }

  OverlayEntry _buildOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50,
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) {
            setState(() => _isHovered = false);
            _overlayEntry.remove();
          },
          child: Material(
            elevation: 6.0,
            borderRadius: BorderRadius.circular(8),
            color: Colors.black87,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // placeholder
  }
}
