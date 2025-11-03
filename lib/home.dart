import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('access_token');
    await prefs.remove('token_type');

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("اختر الخدمة")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromRGBO(1, 85, 96, 1)),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),

      // -------------------- BODY --------------------
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 1, // 2 cards per row
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 4, // ✅ keep your original ratio
          children: [
            _buildCard(
              context,
              title: "العيادات الخاصة",
              icon: Icons.local_hospital,
              imagePath: 'assets/specialist_clinic.png',
              onTap: () {
                Navigator.pushNamed(context, '/find_doctor', arguments: {'type': 'clinic'});
              },
            ),
            _buildCard(
              context,
              title: "المستشفيات الحكومية و الخاصة",
              icon: Icons.apartment,
              imagePath: 'assets/hospital.png',
              onTap: () {
                Navigator.pushNamed(context, '/find_doctor', arguments: {'type': 'hospital'});
              },
            ),
            _buildCard(
              context,
              title: "الصيدليات",
              icon: Icons.local_pharmacy,
              imagePath: 'assets/pharmacy.png',
              onTap: () {
                Navigator.pushNamed(context, '/find_doctor', arguments: {'type': 'pharmacy'});
              },
            ),
            _buildCard(
              context,
              title: "المعامل التخصصية",
              icon: Icons.biotech,
              imagePath: 'assets/lab.png',
              onTap: () {
                Navigator.pushNamed(context, '/find_doctor', arguments: {'type': 'lab'});
              },
            ),
            _buildCard(
              context,
              title: "مراكز العلاج الطبيعي",
              icon: Icons.spa,
              imagePath: 'assets/spa.png',
              onTap: () {
                Navigator.pushNamed(context, '/find_doctor', arguments: {'type': 'physiotherapy center'});
              },
            ),
            _buildCard(
              context,
              title: "خدمات الاسعاف",
              icon: Icons.local_shipping,
              imagePath: 'assets/ambulance.png',
              onTap: () {
                Navigator.pushNamed(context, '/find_doctor', arguments: {'type': 'ambulance'});
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper method to build each card
  Widget _buildCard(
  BuildContext context, {
  required String title,
  required IconData icon,
  required String imagePath, // 👈 use image instead of color
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge, // 👈 ensures rounded corners apply to the image
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath), // 👈 your image file from assets
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.5), // 👈 optional overlay for contrast
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 46),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
