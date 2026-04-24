import 'dart:ui';

import 'package:flutter/cupertino.dart';

class WideScoopClipper extends CustomClipper<Path> {
  final double scoopDepth; // how deep the dip is
  final double scoopWidth; // how wide (use a large oval)

  WideScoopClipper({this.scoopDepth = 80, this.scoopWidth = 600});

  @override
  Path getClip(Size size) {
    // Base: the full white panel
    final base = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Cutout: a wide flat oval sitting on top, dipping into the panel
    final scoop = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(size.width / 2, 0), // centered on top edge
          width: scoopWidth, // wider than panel = gentle curve
          height: scoopDepth * 2, // doubled because half is above
        ),
      );

    return Path.combine(PathOperation.difference, base, scoop);
  }

  @override
  bool shouldReclip(covariant WideScoopClipper old) =>
      old.scoopDepth != scoopDepth || old.scoopWidth != scoopWidth;
}
