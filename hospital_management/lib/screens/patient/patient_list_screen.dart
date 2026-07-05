import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/patient_provider.dart';
import '../../models/patient_model.dart';
import 'patient_form_screen.dart'; 

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PatientProvider>().fetchPatients());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PatientProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Patient List')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<PatientProvider>().setSearch(value);
              },
              decoration: InputDecoration(
                hintText: 'Search by name, phone, email or address...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<PatientProvider>().setSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),

          // Patient List
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.errorMessage != null
                    ? Center(child: Text('Error: ${provider.errorMessage}'))
                    : RefreshIndicator(
                        onRefresh: () => provider.fetchPatients(),
                        child: provider.patients.isEmpty
                            ? const Center(child: Text('No patients found'))
                            : ListView.builder(
                                itemCount: provider.patients.length,
                                itemBuilder: (context, index) {
                                  final patient = provider.patients[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    child: ListTile(
                                      title: Text(patient.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      subtitle: Text(
                                        '${patient.gender}\n${patient.phone}\n${patient.email}\n${patient.address}',
                                      ),
                                      isThreeLine: true,
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.blue),
                                            onPressed: () => _navigateToForm(context, patient),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => _deletePatient(context, patient),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Add & Edit Navigation
  void _navigateToForm(BuildContext context, [PatientModel? patient]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PatientFormScreen(patient: patient)),
    ).then((_) {
      context.read<PatientProvider>().fetchPatients();
    });
  }

  // Delete with confirmation
  void _deletePatient(BuildContext context, PatientModel patient) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Delete ${patient.fullName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<PatientProvider>().deletePatient(patient.patientID!);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}