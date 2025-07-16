
import 'package:flutter/material.dart';
import 'package:supermarket_app_03072025/utils/app_colors.dart';
import 'package:supermarket_app_03072025/utils/app_styles.dart';
import 'package:supermarket_app_03072025/widgets/color_scheme_extension.dart';

// Model for an employee
class Employee {
  final String name;
  final String role;
  final String email;

  Employee({required this.name, required this.role, required this.email});
}

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  State<EmployeeManagementScreen> createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  String _selectedTenant = 'Carrefour';
  final List<String> _tenants = ['Carrefour', 'Géant', 'Aziza'];
  final Map<String, List<Employee>> _employeesByTenant = {
    'Carrefour': [
      Employee(name: 'Alice Dupont', role: 'Manager', email: 'alice.d@carrefour.com'),
      Employee(name: 'Bob Martin', role: 'Vendeur', email: 'bob.m@carrefour.com'),
      Employee(name: 'Charlie Leblanc', role: 'Caissier', email: 'charlie.l@carrefour.com'),
    ],
    'Géant': [
      Employee(name: 'David Bernard', role: 'Manager', email: 'david.b@geant.com'),
      Employee(name: 'Eve Dubois', role: 'Vendeur', email: 'eve.d@geant.com'),
    ],
    'Aziza': [
      Employee(name: 'Frank Garcia', role: 'Manager', email: 'frank.g@aziza.com'),
    ],
  };

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Regular expression for email validation
  final _emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  // Show dialog to add or edit an employee
  void _showEmployeeDialog({Employee? employee, int? index}) {
    final isEditing = employee != null;
    if (isEditing) {
      _nameController.text = employee.name;
      _roleController.text = employee.role;
      _emailController.text = employee.email;
    } else {
      _nameController.clear();
      _roleController.clear();
      _emailController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Modifier l\'employé' : 'Ajouter un employé',
                  style: textTheme.headlineSmall?.copyWith(color: colorScheme.onSurface),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom Complet',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer le nom complet';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _roleController,
                  decoration: const InputDecoration(
                    labelText: 'Rôle',
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer le rôle';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer l\'email';
                    }
                    if (!_emailRegExp.hasMatch(value)) {
                      return 'Veuillez entrer un email valide';
                    }
                    // Check for unique email within the selected tenant
                    final employees = _employeesByTenant[_selectedTenant] ?? [];
                    if (isEditing && index != null && employees[index].email == value) {
                      return null; // Allow same email for the employee being edited
                    }
                    if (employees.any((e) => e.email == value)) {
                      return 'Cet email est déjà utilisé';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Annuler',
                        style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            final newEmployee = Employee(
                              name: _nameController.text.trim(),
                              role: _roleController.text.trim(),
                              email: _emailController.text.trim(),
                            );
                            final employees = _employeesByTenant[_selectedTenant] ??= [];
                            if (isEditing && index != null) {
                              employees[index] = newEmployee;
                            } else {
                              employees.add(newEmployee);
                            }
                          });
                          Navigator.pop(context);
                          _showSnackBar(
                            context,
                            isEditing ? 'Employé modifié avec succès !' : 'Employé ajouté avec succès !',
                            colorScheme.success,
                          );
                        }
                      },
                      child: Text(isEditing ? 'Modifier' : 'Ajouter'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show a styled SnackBar
  void _showSnackBar(BuildContext context, String message, Color backgroundColor) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  // Delete an employee
  void _deleteEmployee(int index) {
    final employees = _employeesByTenant[_selectedTenant];
    if (employees == null || index >= employees.length) return;
    final employeeName = employees[index].name;
    setState(() {
      employees.removeAt(index);
    });
    _showSnackBar(
      context,
      'Employé $employeeName supprimé.',
      Theme.of(context).colorScheme.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final currentEmployees = _employeesByTenant[_selectedTenant] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Employés'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Gérer les membres de l\'équipe',
              style: textTheme.headlineSmall?.copyWith(color: colorScheme.onBackground),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedTenant,
              decoration: InputDecoration(
                labelText: 'Sélectionner un Magasin',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: _tenants.map((String tenant) {
                return DropdownMenuItem<String>(
                  value: tenant,
                  child: Text(tenant, style: textTheme.bodyLarge),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedTenant = newValue;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: currentEmployees.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.group_off_outlined, size: 80, color: colorScheme.onBackground.withOpacity(0.6)),
                        const SizedBox(height: 20),
                        Text(
                          'Aucun employé pour ce magasin.',
                          style: textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onBackground.withOpacity(0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Ajoutez-en un pour commencer !',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onBackground.withOpacity(0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: currentEmployees.length,
                    itemBuilder: (context, index) {
                      final employee = currentEmployees[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundColor: colorScheme.primary.withOpacity(0.1),
                            child: Icon(Icons.person_outline, color: colorScheme.primary, size: 30),
                          ),
                          title: Text(
                            employee.name,
                            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employee.role,
                                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                              ),
                              Text(
                                employee.email,
                                style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.5)),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: colorScheme.secondary),
                                tooltip: 'Modifier',
                                onPressed: () => _showEmployeeDialog(employee: employee, index: index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_outline, color: colorScheme.error),
                                tooltip: 'Supprimer',
                                onPressed: () => _deleteEmployee(index),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEmployeeDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter Employé'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}