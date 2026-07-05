import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/doctor_model.dart';
import '../../providers/doctor_provider.dart';

class DoctorFormScreen extends StatefulWidget {
  final DoctorModel? doctor;

  const DoctorFormScreen({super.key, this.doctor});

  @override
  State<DoctorFormScreen> createState() => _DoctorFormScreenState();
}

class _DoctorFormScreenState extends State<DoctorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _specialtyController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.doctor?.fullName);
    _specialtyController = TextEditingController(text: widget.doctor?.specialty);
    _phoneController = TextEditingController(text: widget.doctor?.phone);
    _emailController = TextEditingController(text: widget.doctor?.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.doctor != null;
    final provider = context.watch<DoctorProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Doctor' : 'Add Doctor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                validator: (value) => value!.trim().isEmpty ? 'Full name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specialtyController,
                decoration: const InputDecoration(labelText: 'Specialty', border: OutlineInputBorder()),
                validator: (value) => value!.trim().isEmpty ? 'Specialty is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.trim().isEmpty ? 'Phone is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.trim().isEmpty ? 'Email is required' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final doctor = DoctorModel(
                              doctorID: widget.doctor?.doctorID,
                              fullName: _nameController.text.trim(),
                              specialty: _specialtyController.text.trim(),
                              phone: _phoneController.text.trim(),
                              email: _emailController.text.trim(),
                            );

                            String? error;
                            if (isEditing) {
                              error = await context.read<DoctorProvider>().updateDoctor(doctor);
                            } else {
                              error = await context.read<DoctorProvider>().addDoctor(doctor);
                            }

                            if (error == null && mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isEditing ? 'Doctor updated successfully' : 'Doctor added successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else if (error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error), backgroundColor: Colors.red),
                              );
                            }
                          }
                        },
                  child: Text(isEditing ? 'Update Doctor' : 'Add Doctor'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}