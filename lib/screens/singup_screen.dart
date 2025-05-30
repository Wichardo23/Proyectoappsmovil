import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'login_screen.dart';
import 'package:intl/intl.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usuarioController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _registerUser() async {
    final usuario = _usuarioController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final name = _nameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();
    final dob = _dobController.text.trim();

    if (usuario.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        name.isEmpty ||
        dob.isEmpty) {
      _showSnackBar('Por favor, completa todos los campos obligatorios.',
          backgroundColor: Colors.red);
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('Las contraseñas no coinciden.',
          backgroundColor: Colors.red);
      return;
    }

    try {
      final usuarioExistente = await _databaseHelper.usuarioExists(usuario);
      if (usuarioExistente) {
        _showSnackBar('Este usuario ya está registrado.',
            backgroundColor: Colors.red);
        return;
      }

      final exists = await _databaseHelper.emailExists(email);
      if (exists) {
        _showSnackBar('Este correo ya está registrado.',
            backgroundColor: Colors.red);
        return;
      }

      await _databaseHelper.insertUser({
        'usuario': usuario,
        'name': name,
        'email': email,
        'password': password,
        'lastName': lastName,
        'phone': phone,
        'dob': dob,
      });

      _showSnackBar(
          '¡Cuenta registrada exitosamente! Ahora puedes iniciar sesión.',
          backgroundColor: Colors.green);

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    } catch (e) {
      _showSnackBar(
          'Ocurrió un error al registrar la cuenta. Inténtalo de nuevo.',
          backgroundColor: Colors.red);
      //print('Error al registrar usuario: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = (String label) => InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        backgroundColor: Colors.indigo[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _usuarioController,
              decoration: inputDecoration('Usuario'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: inputDecoration('Correo electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: _obscurePassword,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: _obscureConfirmPassword,
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirmar contraseña',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: inputDecoration('Nombre(s)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _lastNameController,
              decoration: inputDecoration('Apellidos'),
            ),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.phone,
              controller: _phoneController,
              decoration: inputDecoration('Número de teléfono'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dobController,
              decoration: InputDecoration(
                labelText: 'Fecha de nacimiento (DD/MM/AAAA)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _registerUser,
                child: const Text('Crear cuenta',
                    style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
