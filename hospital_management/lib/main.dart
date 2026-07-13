
import 'package:flutter/material.dart';
import 'package:hospital_management/providers/appointment_provider.dart';
import 'package:hospital_management/providers/medicine_provider.dart';
import 'package:provider/provider.dart';
import 'core/storage/shared_pref_helper.dart';
import 'providers/auth_provider.dart';
import 'providers/doctor_provider.dart';
import 'providers/patient_provider.dart';
import 'providers/theme_provider.dart';
import 'app.dart';
import 'package:hospital_management/core/constants/api_constants.dart';

void main() async {
   print("BASE URL = ${AppConstants.baseUrl}");
  WidgetsFlutterBinding.ensureInitialized();
  await PrefHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ],
      child: const App(), 
    );
  }
}