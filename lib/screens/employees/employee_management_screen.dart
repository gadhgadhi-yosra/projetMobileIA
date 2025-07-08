
import 'package:flutter/material.dart';
import 'package:supermarket_app_03072025/utils/app_styles.dart';

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  State<EmployeeManagementScreen> createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  String _selectedTenant = 'Carrefour';
  final List<String> _tenants = ['Carrefour', 'Géant', 'Aziza'];
  final Map<String, List<Map<String, dynamic>>> _employeesByTenant = {
    'Carrefour': [
      {'name': 'Alice Dupont', 'role': 'Manager', 'email': 'alice.d@carrefour.com'},
      {'name': 'Bob Martin', 'role': 'Vendeur', 'email': 'bob.m@carrefour.com'},
      {'name': 'Charlie Leblanc', 'role': 'Caissier', 'email': 'charlie.l@carrefour.com'},
    ],
    'Géant': [
      {'name': 'David Bernard', 'role': 'Manager', 'email': 'david.b@geant.com'},
      {'name': 'Eve Dubois', 'role': 'Vendeur', 'email': 'eve.d@geant.com'},
    ],
    'Aziza': [
      {'name': 'Frank Garcia', 'role': 'Manager', 'email': 'frank.g@aziza.com'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    List<Map<String, dynamic>> currentEmployees = _employeesByTenant[_selectedTenant] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Employés'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // رجوع طبيعي للشاشة السابقة
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Gestion des Employés',
              style: AppStyles.headline2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedTenant,
              decoration: InputDecoration(
                labelText: 'Sélectionner un Magasin',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
              items: _tenants.map((String tenant) {
                return DropdownMenuItem<String>(
                  value: tenant,
                  child: Text(tenant),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTenant = newValue!;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currentEmployees.length,
              itemBuilder: (context, index) {
                final employee = currentEmployees[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: colorScheme.primary,
                          child: Icon(Icons.person, color: colorScheme.onPrimary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employee['name'],
                                style: AppStyles.headline3,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                employee['role'],
                                style: AppStyles.bodyText1.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                              ),
                              Text(
                                employee['email'],
                                style: AppStyles.bodyText2,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: colorScheme.primary),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Modifier ${employee['name']}')),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: colorScheme.error),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Supprimer ${employee['name']}')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ajouter un nouvel employé')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
