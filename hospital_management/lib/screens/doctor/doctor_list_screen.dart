import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/doctor_provider.dart';
import '../../models/doctor_model.dart';
import 'doctor_form_screen.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DoctorProvider>().fetchDoctors());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DoctorProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Doctor List')),
      body: Column(
        children: [
          // ==================== Search Bar ====================
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<DoctorProvider>().setSearch(value);
              },
              decoration: InputDecoration(
                hintText: 'Search by name, specialty, email or phone...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<DoctorProvider>().setSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              keyboardType: TextInputType.text,
            ),
          ),

          // ==================== Doctor List ====================
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                    ? Center(child: Text('Error: ${provider.error}'))
                    : RefreshIndicator(
                        onRefresh: () => provider.fetchDoctors(),
                        child: provider.doctors.isEmpty
                            ? const Center(
                                child: Text('No doctors found'),
                              )
                            : ListView.builder(
                                itemCount: provider.doctors.length,
                                itemBuilder: (context, index) {
                                  final doctor = provider.doctors[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    child: ListTile(
                                      title: Text(
                                        doctor.fullName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        '${doctor.specialty}\n${doctor.phone}\n${doctor.email}',
                                      ),
                                      isThreeLine: true,
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.blue),
                                            onPressed: () =>
                                                _navigateToForm(context, doctor),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () =>
                                                _deleteDoctor(context, doctor),
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

  void _navigateToForm(BuildContext context, [DoctorModel? doctor]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DoctorFormScreen(doctor: doctor)),
    ).then((_) => context.read<DoctorProvider>().fetchDoctors());
  }

  void _deleteDoctor(BuildContext context, DoctorModel doctor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Delete ${doctor.fullName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<DoctorProvider>().deleteDoctor(doctor.doctorID!);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}