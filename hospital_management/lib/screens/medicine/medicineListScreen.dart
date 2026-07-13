import 'package:flutter/material.dart';
import 'package:hospital_management/models/medicine_model.dart';
import 'package:provider/provider.dart';
import '../../providers/medicine_provider.dart';

class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({super.key});

  @override
  State<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicineProvider>().fetchMedicines();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicineProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicines"),
        elevation: 0,
        backgroundColor: theme.primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Add New Medicine - Coming Soon")),
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
                hintText: "Search medicine...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: theme.cardColor,
              ),
            ),
          ),
          Expanded(
            child: provider.state == MedicineState.loading
                ? const Center(child: CircularProgressIndicator())
                : provider.state == MedicineState.error
                    ? Center(child: Text("Error: ${provider.errorMessage}"))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.medicines.length,
                        itemBuilder: (context, index) {
                          final medicine = provider.medicines[index];
                          return _medicineCard(medicine, theme);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _medicineCard(MedicineModel medicine, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.medication, size: 32, color: Colors.teal),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (medicine.description != null)
                    Text(
                      medicine.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text("৳${medicine.price}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      const Spacer(),
                      Chip(
                        label: Text("Stock: ${medicine.stock}"),
                        backgroundColor: medicine.stock > 10 ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}