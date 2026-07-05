import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/patient_model.dart';
import '../../providers/patient_provider.dart';

class PatientFormScreen extends StatefulWidget {
  final PatientModel? patient;

  const PatientFormScreen({super.key, this.patient});

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  String _gender = 'Male';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient?.fullName);
    _phoneController = TextEditingController(text: widget.patient?.phone);
    _emailController = TextEditingController(text: widget.patient?.email);
    _addressController = TextEditingController(text: widget.patient?.address);
    _gender = widget.patient?.gender ?? 'Male';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.patient != null;
    final provider = context.watch<PatientProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Patient' : 'Add Patient')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                validator: (v) => v!.trim().isEmpty ? 'Full name is required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Gender: ', style: TextStyle(fontSize: 16)),
                  Radio<String>(
                    value: 'Male',
                    groupValue: _gender,
                    onChanged: (val) => setState(() => _gender = val!),
                  ),
                  const Text('Male'),
                  Radio<String>(
                    value: 'Female',
                    groupValue: _gender,
                    onChanged: (val) => setState(() => _gender = val!),
                  ),
                  const Text('Female'),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.trim().isEmpty ? 'Phone is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.trim().isEmpty ? 'Email is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                maxLines: 3,
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
                            final patient = PatientModel(
                              patientID: widget.patient?.patientID,
                              fullName: _nameController.text.trim(),
                              gender: _gender,
                              phone: _phoneController.text.trim(),
                              email: _emailController.text.trim(),
                              address: _addressController.text.trim(),
                            );

                            String? error;
                            if (isEditing) {
                              error = await context.read<PatientProvider>().updatePatient(patient);
                            } else {
                              error = await context.read<PatientProvider>().addPatient(patient);
                            }

                            if (error == null && mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isEditing ? 'Patient updated successfully' : 'Patient added successfully'),
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
                  child: Text(isEditing ? 'Update Patient' : 'Add Patient'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}