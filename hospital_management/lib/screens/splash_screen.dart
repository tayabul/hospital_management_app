import 'package:flutter/material.dart';
import 'package:hospital_management/core/constants/user_roles.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'admin/admin_dashboard.dart';
import 'doctor/doctor_profile.dart';
import 'patient/patient_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkLoginStatus();

    await Future.delayed(const Duration(milliseconds: 300));
    await authProvider.checkLoginStatus();
    
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      _navigateByRole(authProvider.role);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _navigateByRole(String? role) {
    Widget destination;
    switch (role?.toLowerCase()) {
      case UserRoles.admin:
        destination = const DashboardScreen();
        break;
      case UserRoles.doctor:
        destination = const DoctorProfile();
        break;
      case UserRoles.receptionist:
        destination = const PatientPage();
        break;
      default:
        destination = const LoginScreen();
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.local_hospital, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "Hospital Management",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
