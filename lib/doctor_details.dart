import 'package:flutter/material.dart';
import 'package:my_app/data/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/clinic_photo.dart';

class ClinicDetailsPage extends StatelessWidget {
  final Map<String, dynamic> clinic;

  const ClinicDetailsPage({super.key, required this.clinic});

  // Helper function to open links safely
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final base_url =
        "https://nonlacteous-percussively-dylan.ngrok-free.dev/clinics/picture/";
    return Scaffold(
      appBar: AppBar(title: Text(clinic['name'] ?? 'Clinic Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            clinic['picture_filename'] != ''
                ? ClinicImage(
                    imageUrl: '$base_url${clinic['picture_filename']}',
                  )
                : Image.asset('assets/clinic_placeholder.jpg'),
            SizedBox(height: 10),
            Text(
              "${clinic['name'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 30, color: Colors.black),
              textDirection: TextDirection.ltr,
            ),
            const SizedBox(height: 10),
            if (clinic['specialty'] != null && clinic['specialty'].isNotEmpty)
              Text(
                "التخصص: ${getArabicSpecialty(clinic['specialty']) ?? 'N/A'}",
                style: const TextStyle(fontSize: 16),
                textDirection: TextDirection.rtl,
              ),
            const SizedBox(height: 10),
            //Clickable Location
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "الموقع: ",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                if (clinic['location_link'] != null &&
                    clinic['location_link'].isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      final locationLink = clinic['location_link'];
                      if (locationLink != null && locationLink.isNotEmpty) {
                        _launchUrl(locationLink);
                      }
                    },
                    child: Row(
                      children: [
                        Text(clinic['address']),
                        const Icon(
                          Icons.location_pin, // 📍 pin icon
                          color: Colors.blue,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            if (clinic["working_time"] != null &&
                clinic['working_time'].isNotEmpty)
              Text(
                'مواعيد العمل: ${clinic['working_time']}',
                textDirection: TextDirection.rtl,
              ),
            const SizedBox(height: 10),
            // Clickable Phone
            if (clinic['phone_number'] != null &&
                clinic['phone_number'].isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("الهاتف: "),
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        ...clinic['phone_number']
                            .split('-') // Split by dash
                            .map((number) => number.trim()) // Remove spaces
                            .where(
                              (number) => !number.isEmpty,
                            ) // Filter out empty parts
                            .map(
                              (number) => GestureDetector(
                                onTap: () => _launchUrl("tel:$number"),
                                child: Text(
                                  number,
                                  textDirection: TextDirection.ltr,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 10),
            if (clinic['whatsapp_number'] != null &&
                clinic['whatsapp_number'].isNotEmpty)
              Column(
                children: [
                  Row(
                    children: [
                      Text("واتساب: "),
                      GestureDetector(
                        onTap: () {
                          if (clinic['whatsapp_number'] != null &&
                              clinic['whatsapp_number'].isNotEmpty) {
                            final number = clinic['whatsapp_number'];
                            _launchUrl("https://wa.me/$number");
                          }
                        },
                        child: Text(
                          clinic['whatsapp_number'],
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            if (clinic["additional_info"] != null &&
                clinic['additional_info'].isNotEmpty)
              Text(
                'معلومات اضافية: ${clinic['additional_info']}',
                textDirection: TextDirection.rtl,
              ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (clinic['whatsapp_number'] != null &&
                    clinic['whatsapp_number'].isNotEmpty) {
                  final number = clinic['whatsapp_number'];
                  _launchUrl("https://wa.me/$number");
                } else if (clinic['phone_number'] != null &&
                    clinic['phone_number'].isNotEmpty) {
                  final number = clinic['phone_number']
                      .split('-') // Split by dash
                      .map((number) => number.trim()) // Remove spaces
                      .where((number) => !number.isEmpty)
                      .toList()[0];
                  _launchUrl("tel:$number");
                }
              },
              child: const Text("احجز موعد"),
            ),
          ],
        ),
      ),
    );
  }
}
