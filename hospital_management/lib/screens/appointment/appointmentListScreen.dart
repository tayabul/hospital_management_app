import 'package:flutter/material.dart';
import 'package:hospital_management/models/appointment_model.dart';
import 'package:provider/provider.dart';
import '../../providers/appointment_provider.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentProvider>().fetchAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments"),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("New Appointment - Coming Soon")),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => provider.setSearch(value),
              decoration: InputDecoration(
                hintText: "Search patient or doctor...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: theme.cardColor,
              ),
            ),
          ),
          Expanded(
            child: provider.state == AppointmentState.loading
                ? const Center(child: CircularProgressIndicator())
                : provider.state == AppointmentState.error
                    ? Center(child: Text("Error: ${provider.errorMessage}"))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = provider.appointments[index];
                          return _appointmentCard(appointment, theme);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _appointmentCard(AppointmentModel appointment, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  appointment.appointmentDate.toString().substring(0, 16),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Chip(
                  label: Text(appointment.status),
                  backgroundColor: appointment.status.toLowerCase() == 'scheduled'
                      ? Colors.blue.withOpacity(0.2)
                      : Colors.green.withOpacity(0.2),
                ),
              ],
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(appointment.patientName ?? "Patient"),
              subtitle: Text("Doctor: ${appointment.doctorName ?? 'N/A'}"),
            ),
          ],
        ),
      ),
    );
  }
}