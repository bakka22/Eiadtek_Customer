import 'package:flutter/material.dart';

class ClinicImage extends StatelessWidget {
  final String imageUrl;

  const ClinicImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,              // Full width of the screen
      height: screenHeight * 0.25,     // One quarter of the screen height
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12), // optional rounded corners
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover, // Fills width nicely without looking stretched
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return  Center(
              child: Image.asset('assets/clinic_placeholder.jpg'),
            );
          },
        ),
      ),
    );
  }
}
