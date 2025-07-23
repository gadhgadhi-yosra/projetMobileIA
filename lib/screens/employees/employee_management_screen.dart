import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supermarket_app_03072025/models/employee.dart';
import 'package:supermarket_app_03072025/utils/app_colors.dart';
import 'package:supermarket_app_03072025/widgets/custom_curved_navigation_bar.dart';

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  State<EmployeeManagementScreen> createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen>
    with SingleTickerProviderStateMixin {
  // User Firebase Auth pour identifier l'utilisateur connecté
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;

  String _selectedTenant = '';
  final _formKeyEmployee = GlobalKey<FormState>();
  final _formKeyTenant = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _emailController = TextEditingController();
  final _newTenantController = TextEditingController();
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;
  final _emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  String? _selectedImagePath;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    currentUser = _auth.currentUser; // Récupère utilisateur connecté

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

    _loadDefaultTenant();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    _newTenantController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  // Charge le premier magasin du user connecté comme sélection par défaut
  Future<void> _loadDefaultTenant() async {
    if (currentUser == null) return;
    final snapshot = await _firestore
        .collection('tenants')
        .where('ownerId', isEqualTo: currentUser!.uid)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        _selectedTenant = snapshot.docs.first.id;
      });
    }
  }

  // Récupère les magasins liés à l'utilisateur connecté
  Stream<List<String>> _getTenantsStream() {
    if (currentUser == null) return Stream.value([]);
    return _firestore
        .collection('tenants')
        .where('ownerId', isEqualTo: currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  // Récupère les employés du magasin sélectionné
  Stream<List<Employee>> _getEmployeesStream(String tenant) {
    if (tenant.isEmpty) return Stream.value([]);
    return _firestore
        .collection('tenants')
        .doc(tenant)
        .collection('employees')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Employee.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Vérifie si un email existe déjà dans un magasin, utilisé pour éviter les doublons
  Future<bool> _isEmailTaken(String email, {String? excludeId}) async {
    if (_selectedTenant.isEmpty) return false;
    final query = await _firestore
        .collection('tenants')
        .doc(_selectedTenant)
        .collection('employees')
        .where('email', isEqualTo: email)
        .get();
    if (excludeId != null) {
      return query.docs.any((doc) => doc.id != excludeId);
    }
    return query.docs.isNotEmpty;
  }

  // Upload d'une image dans Firebase Storage
  Future<String?> _uploadImage(XFile image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('employee_photos')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(File(image.path));
      return await ref.getDownloadURL();
    } catch (e) {
      _showSnackBar(context, 'Erreur lors de l\'upload : $e', Theme.of(context).colorScheme.error);
      return null;
    }
  }

  // Création d'un magasin avec association à l'utilisateur connecté (ownerId)
  Future<void> _createNewTenant(String tenantName) async {
    if (tenantName.isNotEmpty && currentUser != null) {
      final tenantDoc = _firestore.collection('tenants').doc(tenantName);
      final docSnapshot = await tenantDoc.get();
      if (!docSnapshot.exists) {
        await tenantDoc.set({
          'ownerId': currentUser!.uid, // Liaison avec utilisateur
        });
      }
      setState(() {
        _selectedTenant = tenantName;
        _newTenantController.clear();
      });
      _showSnackBar(context, 'Magasin "$tenantName" créé avec succès !', Theme.of(context).colorScheme.primary);
      Navigator.pop(context);
    }
  }

  // Ajout/modification d'employé
  Future<void> _saveEmployee({Employee? employee, String? id}) async {
    if (_formKeyEmployee.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();

      if (_selectedTenant.isEmpty) {
        _showSnackBar(context, 'Veuillez sélectionner ou créer un magasin', Theme.of(context).colorScheme.error);
        return;
      }

      final isEmailTaken = await _isEmailTaken(email, excludeId: id);
      if (isEmailTaken) {
        _showSnackBar(
          context,
          'Cet email est déjà utilisé',
          Theme.of(context).colorScheme.error,
        );
        return;
      }

      final newEmployee = Employee(
        id: id ?? _firestore.collection('tenants').doc(_selectedTenant).collection('employees').doc().id,
        name: _nameController.text.trim(),
        role: _roleController.text.trim(),
        email: email,
        photoPath: _selectedImagePath,
        tenant: _selectedTenant, // Assignation du magasin
      );

      try {
        await _firestore
            .collection('tenants')
            .doc(_selectedTenant)
            .collection('employees')
            .doc(newEmployee.id)
            .set(newEmployee.toFirestore());
        _showSnackBar(
          context,
          id != null ? 'Employé modifié avec succès !' : 'Employé ajouté avec succès !',
          Theme.of(context).colorScheme.primary,
        );
        _animationController?.reverse().then((_) => Navigator.pop(context));
        setState(() {
          _selectedImagePath = null;
        });
      } catch (e) {
        _showSnackBar(
          context,
          'Erreur : $e',
          Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  // Suppression d’un employé
  Future<void> _deleteEmployee(String id) async {
    try {
      await _firestore
          .collection('tenants')
          .doc(_selectedTenant)
          .collection('employees')
          .doc(id)
          .delete();
      _showSnackBar(
        context,
        'Employé supprimé.',
        Theme.of(context).colorScheme.error,
      );
    } catch (e) {
      _showSnackBar(
        context,
        'Erreur : $e',
        Theme.of(context).colorScheme.error,
      );
    }
  }

  // Affiche un SnackBar avec message
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
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Affiche le modal d'ajout/modification d’employé
  void _showEmployeeDialog({Employee? employee, String? id}) {
    final isEditing = employee != null && id != null;
    if (isEditing) {
      _nameController.text = employee!.name;
      _roleController.text = employee.role;
      _emailController.text = employee.email;
      _selectedImagePath = employee.photoPath;
      _selectedTenant = employee.tenant ?? _selectedTenant;
    } else {
      _nameController.clear();
      _roleController.clear();
      _emailController.clear();
      _selectedImagePath = null;
    }

    _animationController?.forward();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SlideTransition(
          position: _slideAnimation!,
          child: FadeTransition(
            opacity: _fadeAnimation!,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 16, right: 16, top: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16),
                child: Form(
                  key: _formKeyEmployee,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEditing ? 'Modifier Employé' : 'Ajouter Employé',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                            onPressed: () =>
                                _animationController?.reverse().then((_) => Navigator.pop(context)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                          _nameController, 'Nom Complet', Icons.person_outline, (value) =>
                              (value?.isEmpty ?? true) ? 'Entrez le nom' : null),
                      const SizedBox(height: 16),
                      _buildTextField(
                          _roleController, 'Rôle', Icons.work_outline, (value) =>
                              (value?.isEmpty ?? true) ? 'Entrez le rôle' : null),
                      const SizedBox(height: 16),
                      _buildTextField(
                          _emailController, 'Email', Icons.email_outlined, (value) {
                        if (value?.isEmpty ?? true) return 'Entrez l\'email';
                        if (!_emailRegExp.hasMatch(value!)) return 'Email invalide';
                        return null;
                      }, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 16),
                      StreamBuilder<List<String>>(
                        stream: _getTenantsStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          final tenants = snapshot.data ?? [];
                          return DropdownButtonFormField<String>(
                            value: _selectedTenant.isNotEmpty ? _selectedTenant : null,
                            decoration: InputDecoration(
                              labelText: 'Magasin',
                              prefixIcon: Icon(Icons.store,
                                  color: Theme.of(context).colorScheme.primary),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1),
                            ),
                            items: tenants
                                .map((tenant) => DropdownMenuItem(
                                      value: tenant,
                                      child: Text(tenant),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) setState(() => _selectedTenant = value);
                            },
                            hint: const Text('Sélectionnez un magasin'),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final image = await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            final url = await _uploadImage(image);
                            if (url != null) setState(() => _selectedImagePath = url);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                          foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child:
                            Text(_selectedImagePath == null ? 'Choisir une photo' : 'Photo sélectionnée'),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () =>
                                _animationController?.reverse().then((_) => Navigator.pop(context)),
                            child: Text('Annuler',
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _saveEmployee(employee: employee, id: id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            child: Text(isEditing ? 'Modifier' : 'Ajouter'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Affiche modal pour ajouter un nouveau magasin
  void _showAddTenantDialog() {
    _newTenantController.clear();
    _animationController?.forward();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SlideTransition(
          position: _slideAnimation!,
          child: FadeTransition(
            opacity: _fadeAnimation!,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 16, right: 16, top: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16),
                child: Form(
                  key: _formKeyTenant,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ajouter un Magasin',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                            onPressed: () =>
                                _animationController?.reverse().then((_) => Navigator.pop(context)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(_newTenantController, 'Nom du Magasin', Icons.add_business,
                          (value) => (value?.isEmpty ?? true) ? 'Entrez le nom du magasin' : null),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () =>
                                _animationController?.reverse().then((_) => Navigator.pop(context)),
                            child: Text('Annuler',
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _createNewTenant(_newTenantController.text),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            child: const Text('Ajouter'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      String? Function(String?) validator,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text('Gestion des Employés',
            style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary)),
        backgroundColor: colorScheme.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Gérer les membres de l\'équipe',
              style: textTheme.titleMedium?.copyWith(color: colorScheme.onBackground),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: StreamBuilder<List<String>>(
              stream: _getTenantsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Erreur : ${snapshot.error}');
                }
                final tenants = snapshot.data ?? [];
                if (tenants.isEmpty) {
                  return Center(
                    child: Text(
                      'Vous n\'avez pas encore de magasin. Veuillez en créer un.',
                      style: textTheme.bodyLarge?.copyWith(color: colorScheme.onBackground),
                    ),
                  );
                }
                if (_selectedTenant.isEmpty && tenants.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _selectedTenant = tenants[0];
                    });
                  });
                }
                return DropdownButtonFormField<String>(
                  value: _selectedTenant.isNotEmpty ? _selectedTenant : null,
                  decoration: InputDecoration(
                    labelText: 'Sélectionner un Magasin',
                    prefixIcon: Icon(Icons.store, color: colorScheme.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: colorScheme.surfaceVariant.withOpacity(0.1),
                  ),
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                  items: tenants
                      .map((tenant) => DropdownMenuItem(
                            value: tenant,
                            child: Text(tenant),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedTenant = value);
                  },
                  dropdownColor: colorScheme.surface,
                  icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
                  hint: const Text('Sélectionnez un magasin'),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Employee>>(
              stream: _getEmployeesStream(_selectedTenant),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erreur : ${snapshot.error}',
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                    ),
                  );
                }
                final currentEmployees = snapshot.data ?? [];
                if (currentEmployees.isEmpty && _selectedTenant.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_outline, size: 80, color: colorScheme.onBackground.withOpacity(0.6)),
                        const SizedBox(height: 20),
                        Text(
                          'Aucun employé pour ce magasin.',
                          style: textTheme.titleMedium?.copyWith(color: colorScheme.onBackground.withOpacity(0.8)),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Ajoutez-en un pour commencer !',
                          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onBackground.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: currentEmployees.length,
                  itemBuilder: (context, index) {
                    final employee = currentEmployees[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: colorScheme.primary.withOpacity(0.1),
                          child: employee.photoPath != null
                              ? ClipOval(
                                  child: Image.network(
                                    employee.photoPath!,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(
                                      Icons.person_outline,
                                      color: colorScheme.primary,
                                      size: 24,
                                    ),
                                  ),
                                )
                              : Icon(Icons.person_outline, color: colorScheme.primary, size: 24),
                        ),
                        title: Text(
                          employee.name,
                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${employee.role} | ${employee.email}',
                          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: colorScheme.secondary),
                              onPressed: () => _showEmployeeDialog(employee: employee, id: employee.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.primary),
                              onPressed: () => _deleteEmployee(employee.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: FloatingActionButton(
              heroTag: 'tenant_fab',
              onPressed: _showAddTenantDialog,
              backgroundColor: colorScheme.tertiary,
              foregroundColor: colorScheme.onTertiary,
              elevation: 6,
              shape: const CircleBorder(),
              child: const Icon(Icons.store),
              tooltip: 'Ajouter un magasin',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: FloatingActionButton(
              heroTag: 'employee_fab',
              onPressed: () => _showEmployeeDialog(),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 6,
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
              tooltip: 'Ajouter un employé',
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const CustomCurvedNavigationBar(),
    );
  }
}
