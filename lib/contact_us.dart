import 'package:flutter/material.dart';
import 'package:my_app/utils/get_clinics.dart'; // adjust path if needed
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  bool _loading = true;
  bool _sending = false;
  Map<String, dynamic>? _contactInfo;

  @override
  void initState() {
    super.initState();
    _fetchContactInfo();
  }

  Future<void> _fetchContactInfo() async {
    try {
      final data = await ClinicService.getContactInfo();
      setState(() {
        _contactInfo = data;
        _loading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل تحميل معلومات التواصل: $e')),
      );
      setState(() => _loading = false);
    }
  }

  Future<void> _sendRecommendation() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    try {
      await ClinicService.sendRecommendation(_messageController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال اقتراحك بنجاح!')),
      );
      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل إرسال الاقتراح: $e')),
      );
    } finally {
      setState(() => _sending = false);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر فتح الرابط: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تواصل معنا")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 📨 Contact Info Card
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "معلومات التواصل",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 12),
                          if (_contactInfo != null) ...[
                            // Email
                            Row(
                              children: [
                                const Icon(Icons.email, color: Colors.blue),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => _launchUrl(
                                      "mailto:${_contactInfo!['email']}"),
                                  child: Text(
                                    _contactInfo!['email'] ?? "N/A",
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Phone
                            Row(
                              children: [
                                const Icon(Icons.phone, color: Colors.green),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => _launchUrl(
                                      "tel:${_contactInfo!['phone_number']}"),
                                  child: Text(
                                    _contactInfo!['phone_number'] ?? "N/A",
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 💬 Recommendation Form
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "أرسل اقتراحك أو ملاحظتك",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _messageController,
                              maxLines: 5,
                              textDirection: TextDirection.rtl,
                              decoration: InputDecoration(
                                hintText: "اكتب اقتراحك هنا...",
                                hintTextDirection: TextDirection.rtl,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "يرجى إدخال نص الاقتراح";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: _sending ? null : _sendRecommendation,
                              icon: _sending
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white),
                                    )
                                  : const Icon(Icons.send),
                              label: Text(_sending
                                  ? "جارٍ الإرسال..."
                                  : "إرسال الاقتراح"),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
