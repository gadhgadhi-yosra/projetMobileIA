// class Employee {
//   final String id;
//   final String name;
//   final String role;
//   final String email;
//   final String? photoPath;

//   Employee({
//     required this.id,
//     required this.name,
//     required this.role,
//     required this.email,
//     this.photoPath,
//   });

 
//   factory Employee.fromFirestore(Map<String, dynamic> data, String id) {
//     return Employee(
//       id: id,
//       name: data['name'] ?? '',
//       role: data['role'] ?? '',
//       email: data['email'] ?? '',
//       photoPath: data['photoPath'],
//     );
//   }


//   Map<String, dynamic> toFirestore() {
//     return {
//       'name': name,
//       'role': role,
//       'email': email,
//       'photoPath': photoPath,
//     };
//   }
// }

class Employee {
  final String id;
  final String name;
  final String role;
  final String email;
  final String? photoPath;
  final String? tenant; // New field

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    this.photoPath,
    this.tenant,
  });

  factory Employee.fromFirestore(Map<String, dynamic> data, String id) {
    return Employee(
        id: id,
        name: data['name'] ?? '',
        role: data['role'] ?? '',
        email: data['email'] ?? '',
        photoPath: data['photoPath'],
        tenant: data['tenant'],
      );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'role': role,
      'email': email,
      'photoPath': photoPath,
      'tenant': tenant,
    };
  }
}