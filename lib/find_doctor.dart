import 'package:flutter/material.dart';
import 'package:my_app/utils/get_clinics.dart';
import 'package:my_app/data/constants.dart';

class FindDoctorPage extends StatefulWidget {
  const FindDoctorPage({super.key});

  @override
  State<FindDoctorPage> createState() => _FindDoctorPageState();
}

class _FindDoctorPageState extends State<FindDoctorPage> {
  String? selectedState;
  String? selectedCity;
  String? selectedSpecialty;
  String? selectedtype;
  bool isLoading = false;
  bool isStatesLoading = true;
  String? errorMessage;

  List<dynamic> states = [];

  @override
  void initState() {
    super.initState();
    _fetchStates();
  }

  Future<void> _fetchStates() async {
    try {
      final fetchedStates = await ClinicService.getStatesWithCities();
      setState(() {
        states = fetchedStates;
        isStatesLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "فشل تحميل الولايات. حاول مرة أخرى.";
        isStatesLoading = false;
      });
    }
  }

  Future<void> _fetchClinics() async {
    if (selectedState == null || selectedCity == null) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final clinics = await ClinicService.getClinics(
        state: selectedState!,
        city: selectedCity!,
        specialty: selectedSpecialty,
        type: selectedtype,
      );

      if (!mounted) return;
      Navigator.pushNamed(
        context,
        '/doctors_list',
        arguments: {'clinics': clinics},
      );
    } catch (e) {
      setState(() {
        errorMessage = "حدث خطأ أثناء تحميل العيادات. حاول مرة أخرى.";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final type = args['type'];
    selectedtype = type;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final selectedStateObj = states.firstWhere(
      (s) => s['en'] == selectedState,
      orElse: () => null,
    );

    final cityList = selectedStateObj != null ? selectedStateObj['cities'] : [];

    return Scaffold(
      appBar: AppBar(title: const Text("ابحث عن طبيب او خدمة طبية")),
      body: isStatesLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.fromLTRB(16, screenHeight * 0.1, 16, 16),
              child: Column(
                children: [
                  /// STATE DROPDOWN
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'اختر الولاية',
                      border: OutlineInputBorder(),
                    ),
                    items: states
                        .map<DropdownMenuItem<String>>((state) =>
                            DropdownMenuItem<String>(
                              value: state['en'], // English backend value
                              child: Text(
                                state['ar'] ?? state['en'],
                                textDirection: TextDirection.rtl,
                              ),
                            ))
                        .toList(),
                    initialValue: selectedState,
                    onChanged: (value) {
                      setState(() {
                        selectedState = value;
                        selectedCity = null;
                      });
                    },
                  ),

                  const SizedBox(height: 40),

                  /// CITY DROPDOWN
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'اختر المدينة',
                      border: OutlineInputBorder(),
                    ),
                    items: selectedState == null
                        ? <DropdownMenuItem<String>>[]
                        : cityList
                            .map<DropdownMenuItem<String>>((city) {
                              final Map<String, dynamic> cityMap =
                                  Map<String, dynamic>.from(city);
                              return DropdownMenuItem<String>(
                                value: cityMap['en'],
                                child: Text(
                                  cityMap['ar'] ?? cityMap['en'],
                                  textDirection: TextDirection.rtl,
                                ),
                              );
                            })
                            .toList(),
                    initialValue: selectedCity,
                    onChanged: (value) {
                      setState(() => selectedCity = value);
                    },
                    disabledHint: const Text(
                      'اختر الولاية أولاً',
                      textDirection: TextDirection.rtl,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// SPECIALTY DROPDOWN
                  if (type == "clinic")
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'اختر التخصص او الخدمة الطبية',
                        border: OutlineInputBorder(),
                      ),
                      items: specialties
                          .map<DropdownMenuItem<String>>(
                            (spec) => DropdownMenuItem(
                              value: spec['en'],
                              child: Text(
                                spec['ar']!,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          )
                          .toList(),
                      initialValue: selectedSpecialty,
                      onChanged: (value) {
                        setState(() => selectedSpecialty = value);
                      },
                    ),

                  const SizedBox(height: 40),

                  if (errorMessage != null)
                    Text(errorMessage!,
                        style: const TextStyle(color: Colors.red)),

                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: selectedState != null && selectedCity != null
                              ? _fetchClinics
                              : null,
                          child: const Text('ابحث',
                              textDirection: TextDirection.rtl),
                        ),
                  SizedBox(height: screenHeight * 0.15),
                  Divider(thickness: 2),
                  SizedBox(height: screenHeight * 0.05),
                  Row(
                    children: [
                      for (int i = 0; i < 4; i++)
                        Padding(
                          padding:
                              EdgeInsets.only(right: screenWidth * 0.02),
                          child: Image.asset(
                            'assets/clinic_placeholder.jpg',
                            width: screenWidth * 0.2,
                            height: screenHeight * 0.1,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
