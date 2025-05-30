import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../db/database_helper.dart';

class PerfilScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const PerfilScreen({super.key, required this.user});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late Map<String, dynamic> editableUser;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    editableUser = Map<String, dynamic>.from(widget.user);
    if (editableUser['profile_image'] != null &&
        (editableUser['profile_image'] as String).isNotEmpty) {
      _profileImage = File(editableUser['profile_image']);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      // Guarda la ruta en la base de datos
      await DatabaseHelper().updateProfileImage(
        editableUser['email'],
        pickedFile.path,
      );
      setState(() {
        editableUser['profile_image'] = pickedFile.path;
      });
    }
  }

  Future<void> _editarPerfil() async {
    final nameController = TextEditingController(text: editableUser['name'] ?? '');
    final emailController = TextEditingController(text: editableUser['email'] ?? '');
    final phoneController = TextEditingController(text: editableUser['phone'] ?? '');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar perfil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (result == true) {
      // Actualiza en la base de datos
      await DatabaseHelper().updateUserData(
        oldEmail: editableUser['email'],
        newName: nameController.text,
        newEmail: emailController.text,
        newPhone: phoneController.text,
      );
      setState(() {
        editableUser['name'] = nameController.text;
        editableUser['email'] = emailController.text;
        editableUser['phone'] = phoneController.text;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.indigo[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage('assets/ejercicios/default_profile.png')
                          as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.camera_alt, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              editableUser['usuario'] ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              editableUser['email'] ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('Nombre: ${editableUser['name'] ?? ''}'),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text('Teléfono: ${editableUser['phone'] ?? ''}'),
            ),
            ListTile(
              leading: const Icon(Icons.cake),
              title: Text('Fecha de nacimiento: ${editableUser['dob'] ?? ''}'),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Editar perfil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[900],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _editarPerfil,
            ),
          ],
        ),
      ),
    );
  }
}