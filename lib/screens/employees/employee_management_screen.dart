
import 'package:flutter/material.dart';


class Employee {
  final String name;
  final String role;
  final String email;
  final String? photoPath; 

  Employee({
    required this.name,
    required this.role,
    required this.email,
    this.photoPath,
  });
}

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  State<EmployeeManagementScreen> createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> with SingleTickerProviderStateMixin {
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
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;
  
  final _emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

 
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

  void _showEmployeeDialog({Employee? employee, int? index, String? imagePath}) {
    final isEditing = employee != null && index != null;
    if (isEditing) {
      _nameController.text = employee!.name;
      _roleController.text = employee.role;
      _emailController.text = employee.email;
   
    } else {
      _nameController.clear();
      _roleController.clear();
      _emailController.clear();
 
    }

    _animationController?.forward();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SlideTransition(
          position: _slideAnimation!,
          child: FadeTransition(
            opacity: _fadeAnimation!,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surface.withOpacity(0.95),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
                  final colorScheme = Theme.of(context).colorScheme;
                  final textTheme = Theme.of(context).textTheme;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                      left: 24,
                      right: 24,
                      top: 32,
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isEditing ? 'Modifier l\'employé' : 'Ajouter un employé',
                                  style: textTheme.headlineSmall?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: colorScheme.onSurface.withOpacity(0.6)),
                                  onPressed: () {
                                    _animationController?.reverse().then((_) => Navigator.pop(context));
                                  },
                                ),
                              ],
                            ),
                          
                            const SizedBox(height: 24),
                            Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceVariant.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.onSurface.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'Nom Complet',
                                  labelStyle: textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF757575), // Grey for label
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintText: 'Ex: Alice Dupont',
                                  prefixIcon: Icon(Icons.person_outline, color: colorScheme.primary),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: colorScheme.primary, width: 2),
                                  ),
                                  errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                ),
                                style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Veuillez entrer le nom complet';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceVariant.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.onSurface.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _roleController,
                                decoration: InputDecoration(
                                  labelText: 'Rôle',
                                  labelStyle: textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF757575), 
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintText: 'Ex: Manager',
                                  prefixIcon: Icon(Icons.work_outline, color: colorScheme.primary),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: colorScheme.primary, width: 2),
                                  ),
                                  errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                ),
                                style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Veuillez entrer le rôle';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceVariant.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.onSurface.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF757575), // Grey for label
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintText: 'Ex: exemple@domaine.com',
                                  prefixIcon: Icon(Icons.email_outlined, color: colorScheme.primary),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: colorScheme.primary, width: 2),
                                  ),
                                  errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                ),
                                style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Veuillez entrer l\'email';
                                  }
                                  if (!_emailRegExp.hasMatch(value)) {
                                    return 'Veuillez entrer un email valide';
                                  }
                                  final employees = _employeesByTenant[_selectedTenant] ?? [];
                                  if (isEditing && index != null && index < employees.length && employees[index].email == value) {
                                    return null; 
                                  }
                                  if (employees.any((e) => e.email == value)) {
                                    return 'Cet email est déjà utilisé';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTapDown: (_) => _animationController?.forward(),
                                  onTapUp: (_) => _animationController?.reverse(),
                                  child: TextButton(
                                    onPressed: () => _animationController?.reverse().then((_) => Navigator.pop(context)),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                      foregroundColor: colorScheme.onSurface.withOpacity(0.7),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: Text(
                                      'Annuler',
                                      style: textTheme.labelLarge?.copyWith(
                                        color: colorScheme.onSurface.withOpacity(0.7),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTapDown: (_) => _animationController?.forward(),
                                  onTapUp: (_) => _animationController?.reverse(),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        setState(() {
                                          final newEmployee = Employee(
                                            name: _nameController.text.trim(),
                                            role: _roleController.text.trim(),
                                            email: _emailController.text.trim(),
                                          
                                          );
                                          final employees = _employeesByTenant[_selectedTenant] ??= [];
                                          if (isEditing && index != null && index >= 0 && index < employees.length) {
                                            employees[index] = newEmployee;
                                          } else {
                                            employees.add(newEmployee);
                                          }
                                        });
                                        _animationController?.reverse().then((_) => Navigator.pop(context));
                                        _showSnackBar(
                                          context,
                                          isEditing ? 'Employé modifié avec succès !' : 'Employé ajouté avec succès !',
                                          colorScheme.primary, 
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                      backgroundColor: colorScheme.primary,
                                      foregroundColor: colorScheme.onPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 4,
                                      shadowColor: colorScheme.primary.withOpacity(0.3),
                                    ),
                                    child: Text(
                                      isEditing ? 'Modifier' : 'Ajouter',
                                      style: textTheme.labelLarge?.copyWith(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // Delete an employee
  void _deleteEmployee(int index) {
    final employees = _employeesByTenant[_selectedTenant];
    if (employees == null || index < 0 || index >= employees.length) return;
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
      backgroundColor: colorScheme.background,
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
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.onSurface.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedTenant,
                decoration: InputDecoration(
                  labelText: 'Sélectionner un Magasin',
                  labelStyle: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF757575), 
                    fontWeight: FontWeight.bold,
                  ),
                  prefixIcon: Icon(Icons.store, color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colorScheme.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                items: _tenants.map((String tenant) {
                  return DropdownMenuItem<String>(
                    value: tenant,
                    child: Text(tenant),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedTenant = newValue;
                    });
                  }
                },
                dropdownColor: colorScheme.surface,
                icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
              ),
            ),
          ),
          Expanded(
            child: currentEmployees.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/employer.png', 
                          width: 80,
                          height: 80,
                          color: colorScheme.onBackground.withOpacity(0.6),
                          colorBlendMode: BlendMode.modulate,
                        ),
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
                            // Optional: Display employee photo
                            /*
                            child: employee.photoPath != null
                                ? ClipOval(
                                    child: Image.file(
                                      File(employee.photoPath!),
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(Icons.person_outline, color: colorScheme.primary, size: 30),
                            */
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