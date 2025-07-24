

class Employee {
  final String id;
  final String name;
  final String role;
  final String email;
  final String? photoPath;
  final String? tenant; 

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    this.photoPath,
    this.tenant,
  });

  factory Employee.fromFirestore(Map<String, dynamic> data, String id) { //Convertit les données venant de Firestore en objet Employee
    return Employee(
        id: id,
        name: data['name'] ?? '',
        role: data['role'] ?? '',
        email: data['email'] ?? '',
        photoPath: data['photoPath'],
        tenant: data['tenant'],
      );
  }

  Map<String, dynamic> toFirestore() { //enregistrer dans Firestore
    return {
      'name': name,
      'role': role,
      'email': email,
      'photoPath': photoPath,
      'tenant': tenant,
    };
  }
}