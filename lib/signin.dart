import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/auth.dart';
import 'widgets/wave_appbar.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  bool isLoading = false;
  bool isLoadingGuest = false;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      final status = await AuthService.loginUser(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final prefs = await SharedPreferences.getInstance();
      if (status == 200) {
        await prefs.setBool('isLoggedIn', true);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } else if (status == 401) {
        setState(() {
          _errorMessage = 'Invalid username or password';
          isLoading = false;
        });
      } else {
        _errorMessage = 'Network Error';
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signInGuest() async {
    final status = await AuthService.loginUser(
        email: "guest@eiadtek.com",
        password: "12345",
    );
    final prefs = await SharedPreferences.getInstance();
    if (status == 200) {
      await prefs.setBool('isLoggedIn', true);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else if (status == 2) {
      setState(() {
        _errorMessage = 'Network error, check your internet connection';
        isLoadingGuest = false;
      });
    } else {
      _errorMessage = 'Server Error';
      setState(() {
        isLoadingGuest = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: WaveAppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🖤 Faded overlay (darken the image)
          Container(
            color: Colors.white.withValues(
              alpha: 0.1,
            ), // adjust 0.3–0.7 for intensity
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.15),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.black), // white text
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ), // softer white
                        filled: true,
                        fillColor: Colors.white, // light translucent box
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(
                                1,
                                85,
                                96,
                                1,
                              ), // 🖤 black button
                              foregroundColor: Colors.white, // 🤍 white text
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              _signIn();
                            },
                            child: const Text("تسجيل الدخول"),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(' ليس لديك حساب؟'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text("قم بالتسجيل"),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    isLoadingGuest
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(
                                1,
                                85,
                                96,
                                1,
                              ), // 🖤 black button
                              foregroundColor: Colors.white, // 🤍 white text
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isLoadingGuest = true;
                              });
                              _signInGuest();
                            },
                            child: const Text("الدخول كضيف"),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
