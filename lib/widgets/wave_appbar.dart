
import 'package:flutter/material.dart';

class WaveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WaveAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: AppBar(
        backgroundColor: Color.fromRGBO(1, 85, 96, 1),
        centerTitle: true,
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
