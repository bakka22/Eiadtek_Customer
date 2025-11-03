// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'doctor_details.dart';

class DoctorsListPage extends StatelessWidget {
  const DoctorsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final base_url = "https://nonlacteous-percussively-dylan.ngrok-free.dev/clinics/picture/";
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<dynamic> clinics = args['clinics'];

    return Scaffold(
      appBar: AppBar(title: const Text("Clinics Found")),
      body: clinics.isEmpty
          ? const Center(child: Text("No clinics found in this location"))
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: clinics.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // two cards per row
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3, // controls height ratio
                ),
                itemBuilder: (context, index) {
                  final clinic = clinics[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ClinicDetailsPage(clinic: clinic),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Placeholder image (use NetworkImage when backend supports it)
                          Expanded(
                            child: clinic['picture_url'] != ''?
                            Image.network(
                              '$base_url${clinic['picture_filename']}',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const CircularProgressIndicator();
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.error,
                                  size: 50,
                                  color: Colors.red,
                                );
                              },
                            )
                            : Image.asset('assets/clinic_placeholder.jpg'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              clinic['name'] ?? 'Unnamed Clinic',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
