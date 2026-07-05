import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Hospital Management',
      debugShowCheckedModeBanner: false,

      // Global Light Theme (Default)
      theme: themeProvider.lightTheme,

      // Global Dark Theme
      darkTheme: themeProvider.darkTheme,

      
      themeMode: ThemeMode.light, 

      home: const SplashScreen(),
      
      
      builder: (context, child) {
        if (child is LoginScreen || child is SplashScreen) {
          return Theme(
            data: themeProvider.lightTheme,
            child: child!,
          );
        }        
        return Theme(
          data: themeProvider.isDarkMode 
              ? themeProvider.darkTheme 
              : themeProvider.lightTheme,
          child: child!,
        );
      },
    );
  }
}