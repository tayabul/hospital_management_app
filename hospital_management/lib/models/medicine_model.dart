class MedicineModel {
  final int? medicineID;
  final String name;
  final String? description;
  final double price;
  final int stock;

  MedicineModel({
    this.medicineID,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) => MedicineModel(
        medicineID: json['medicineID'],
        name: json['name'],
        description: json['description'],
        price: (json['price'] ?? 0.0).toDouble(),
        stock: json['stock'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        if (medicineID != null) 'medicineID': medicineID,
        'name': name,
        if (description != null) 'description': description,
        'price': price,
        'stock': stock,
      };
}