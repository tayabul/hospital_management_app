import 'package:flutter/material.dart';
import 'package:hospital_management/screens/appointment/appointmentListScreen.dart';
import 'package:hospital_management/screens/doctor/doctor_list_screen.dart';
import 'package:hospital_management/screens/medicine/MedicineListScreen.dart';
import 'package:hospital_management/screens/patient/patient_list_screen.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/theme_provider.dart';
import '../auth/login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    final role = auth.role?.toLowerCase() ?? '';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E2937) : const Color(0xFF4F46E5),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Dashboard",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Notifications - Coming Soon")),
              );
            },
          ),
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: Colors.white,
            ),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Text(
                auth.name?.isNotEmpty == true ? auth.name![0].toUpperCase() : "A",
                style: TextStyle(
                  color: isDark ? const Color(0xFF1E2937) : const Color(0xFF4F46E5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      // ==================== Clean & Role Based Drawer ====================
      drawer: Drawer(
        backgroundColor: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(auth.name ?? "User"),
              accountEmail: Text("${auth.userName ?? ''} • ${auth.role ?? 'User'}"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.admin_panel_settings, size: 40, color: Colors.deepPurple),
              ),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2937) : const Color(0xFF4F46E5),
              ),
            ),

            _drawerItem(Icons.people_outline, "Doctors", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorListScreen()));
            }),

            _drawerItem(Icons.person_outline, "Patients", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientListScreen()));
            }),

            // Medicine - Admin & Doctor দেখবে
            if (role == 'admin' || role == 'doctor')
              _drawerItem(Icons.medication_outlined, "Medicine", () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicineListScreen()));
              }),

            // Appointments - সব রোলই দেখবে
            _drawerItem(Icons.calendar_today_outlined, "Appointments", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AppointmentListScreen()));
            }),

            // Inventory - শুধু Admin
            if (role == 'admin')
              _drawerItem(Icons.inventory_2_outlined, "Inventory", () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Inventory - Coming Soon")),
                );
              }),

            const Divider(),

            _drawerItem(Icons.settings_outlined, "Settings", () {
              Navigator.pop(context);
              // Settings screen পরে যোগ করবে
            }),

            const Spacer(),

            // Logout
            _drawerItem(Icons.logout, "Logout", () async {
              Navigator.pop(context);

              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Logout", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true && context.mounted) {
                await context.read<AuthProvider>().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              }
            }),
          ],
        ),
      ),

      // Body remains same...
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back, ${auth.name ?? 'Admin'} 👋",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            Text(
              "Here's what's happening today",
              style: TextStyle(
                fontSize: 15,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(child: _statCard(context, "Total Doctors", "124", Icons.medical_services, Colors.teal)),
                const SizedBox(width: 16),
                Expanded(child: _statCard(context, "Total Patients", "842", Icons.people, Colors.indigo)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _statCard(context, "Appointments", "38", Icons.calendar_today, Colors.orange)),
                const SizedBox(width: 16),
                Expanded(child: _statCard(context, "Available Today", "17", Icons.check_circle, Colors.green)),
              ],
            ),

            const SizedBox(height: 32),

            Text(
              "Recent Doctors",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _doctorCard(context, "Dr. Dianne Russell", "General Practitioner", "9AM - 2PM", Colors.teal),
                  _doctorCard(context, "Dr. Jacob Jones", "Cardiology", "10AM - 3PM", Colors.blue),
                  _doctorCard(context, "Dr. Mona Flores", "Dermatology", "11AM - 4PM", Colors.purple),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Drawer Item Helper
  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  // Stat Card & Doctor Card (আগের মতোই)
  Widget _statCard(BuildContext context, String title, String value, IconData icon, Color accentColor) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 28),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color)),
          Text(title, style: TextStyle(fontSize: 14, color: theme.textTheme.bodyMedium?.color)),
        ],
      ),
    );
  }

  Widget _doctorCard(BuildContext context, String name, String specialty, String time, Color accentColor) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: accentColor.withOpacity(0.15),
            child: Icon(Icons.person, color: accentColor),
          ),
          const Spacer(),
          Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color)),
          Text(specialty, style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color)),
          const SizedBox(height: 6),
          Text(time, style: TextStyle(fontSize: 13, color: theme.textTheme.bodyMedium?.color)),
        ],
      ),
    );
  }
}