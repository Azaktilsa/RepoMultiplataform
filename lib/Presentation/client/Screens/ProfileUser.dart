// ignore_for_file: dead_code, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:azaktilza/env_loader.dart';

class ProfileScreenUser extends StatefulWidget {
  const ProfileScreenUser({super.key});

  @override
  _ProfileScreenUserState createState() => _ProfileScreenUserState();
}

class _ProfileScreenUserState extends State<ProfileScreenUser> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DatabaseReference _databaseRef;
  late Future<Map<String, dynamic>> _userData;
  final ImagePicker _picker = ImagePicker();
  late User _currentUser;

  @override
  void initState() {
    super.initState();

    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('No hay sesión iniciada');
    } else {
      _currentUser = user;
      if (kIsWeb) {
        _databaseRef = FirebaseDatabase.instance
            .ref('${EnvLoader.get('CONTROLER')!}/${_currentUser.uid}');
      } else {
        _databaseRef = FirebaseDatabase.instance
            .ref('${dotenv.env['CONTROLER']!}/${_currentUser.uid}');
      }

      _userData = _fetchUserData();
    }
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      DataSnapshot snapshot = await _databaseRef.get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      } else {
        throw Exception('No se encontraron datos del usuario.');
      }
    } catch (e) {
      debugPrint('Error al obtener datos del usuario: $e');
      rethrow;
    }
  }

  Future<void> _addPhoto() async {
    if (!mounted) return;
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final uid = _auth.currentUser?.uid;
        if (uid == null) return;

        File file = File(pickedFile.path);
        // Crear carpeta con el ID del usuario y archivo interno
        final ref = FirebaseStorage.instance
            .ref()
            .child('profilePictures/$uid/avatar.jpg');
        await ref.putFile(file);
        final downloadUrl = await ref.getDownloadURL();

        await _databaseRef.update({'profilePictureUrl': downloadUrl});

        if (!mounted) return;
        setState(() {
          _userData = _fetchUserData();
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto de perfil actualizada correctamente.'),
            backgroundColor: Color.fromARGB(255, 176, 74, 11),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir la foto: $e')),
      );
    }
  }

  void _editProfile() async {
    if (!mounted) return;

    final data = await _userData;

    // Variables iniciales con los valores actuales del usuario
    String? newEmail = data['email'];
    int? newPhone = int.tryParse(data['phone'].toString());
    int? newDNI = int.tryParse(data['dni'].toString());
    int? newAge = int.tryParse(data['edad'].toString());
    String? newname = data['name'];

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF4F4F4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Editar Perfil',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCustomTextField(
                  label: 'Nombre de usuario',
                  initialValue: newname,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  onChanged: (value) => newname = value,
                ),
                _buildCustomTextField(
                  label: 'Email',
                  initialValue: newEmail,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  onChanged: (value) => newEmail = value,
                ),
                _buildCustomTextField(
                  label: 'Teléfono',
                  initialValue: newPhone?.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      newPhone = int.tryParse(value);
                    } else {
                      newPhone = null;
                    }
                  },
                ),
                _buildCustomTextField(
                  label: 'Cédula',
                  keyboardType: TextInputType.number,
                  initialValue: newDNI?.toString(),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      newDNI = int.tryParse(value);
                    } else {
                      newDNI = null;
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                _buildCustomTextField(
                  label: 'Edad',
                  initialValue: newAge?.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      newAge = int.tryParse(value);
                    } else {
                      newAge = null;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final updates = <String, String?>{};
                if (newname != null && newname!.isNotEmpty) {
                  updates['name'] = newname;
                }
                if (newEmail != null && newEmail!.isNotEmpty) {
                  updates['email'] = newEmail;
                }
                if (newPhone != null && newPhone.toString().isNotEmpty) {
                  updates['phone'] = newPhone.toString();
                }
                if (newDNI != null && newDNI.toString().isNotEmpty) {
                  updates['dni'] = newDNI.toString();
                }
                if (newAge != null && newAge.toString().isNotEmpty) {
                  updates['edad'] = newAge.toString();
                }

                if (!mounted) return;
                await _databaseRef.update(updates);
                setState(() {
                  _userData = _fetchUserData();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Perfil actualizado correctamente.'),
                    backgroundColor: Color.fromARGB(255, 176, 74, 11),
                  ),
                );
              },
              child: const Text(
                'Guardar',
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomTextField({
    required String label,
    required ValueChanged<String> onChanged,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    required List<dynamic> inputFormatters,
  }) {
    final controller = TextEditingController(text: initialValue);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 126, 53, 0)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 126, 53, 0)),
          ),
        ),
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      body: StreamBuilder<DatabaseEvent>(
        stream: _databaseRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('No se encontraron datos.'));
          }

          final user = Map<String, dynamic>.from(
            snapshot.data!.snapshot.value as Map,
          );
          return SingleChildScrollView(
            // Aquí envolvemos el contenido
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                // Foto de perfil
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(137, 249, 248, 255),
                        Color.fromARGB(145, 241, 242, 244)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                    ),
                    color: Color.fromARGB(
                        21, 244, 244, 244), // Color de fondo del contenedor
                    borderRadius: BorderRadius.all(Radius.circular(80)),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(-10, 10),
                        color: Color.fromARGB(80, 0, 0, 0),
                        blurRadius: 10,
                      ),
                      BoxShadow(
                          offset: Offset(-5, -5),
                          color: Color.fromARGB(150, 255, 255, 255),
                          blurRadius: 10),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xfff3ece7),
                      radius: 80,
                      backgroundImage: user['profilePictureUrl'] != null
                          ? NetworkImage(user['profilePictureUrl'])
                          : const AssetImage('assets/images/logoOscuro3.jpeg')
                              as ImageProvider,
                    )
                        .animate()
                        .fadeIn(duration: 1.seconds)
                        .moveY(end: 0, begin: -50),
                  ),
                ),

                const SizedBox(height: 16),

                // Nombre y Edad
                Text(
                  '${user['name']}, ${user['edad'].toString()}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 1.seconds)
                    .moveY(end: 0, begin: -50),
                const SizedBox(height: 32),
                // Botones de acción
                SafeArea(
                  bottom: true,
                  child: SizedBox(
                    height: 500,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xfff3ece7),
                                  Color(0xfff3ece7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                              ),
                              color: Color(0xfff3ece7),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    40), // Esquina superior izquierda redondeada
                                topRight: Radius.circular(
                                    40), // Esquina superior derecha redondeada
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(-5, -5),
                                  color: Color.fromARGB(80, 0, 0, 0),
                                  blurRadius: 10,
                                ),
                                BoxShadow(
                                    offset: Offset(5, 5),
                                    color: Color(0xfff3ece7),
                                    blurRadius: 10),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 16),
                                      // Botón "Añadir Foto"
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 4),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xfff3ece7),
                                              Color(0xfff3ece7),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 176, 74, 11),
                                            width: 2,
                                          ),
                                        ),
                                        child: TextButton.icon(
                                          onPressed: _addPhoto,
                                          icon: const Icon(
                                            Icons.camera_alt,
                                            color: Color.fromARGB(
                                                255, 176, 74, 11),
                                          ),
                                          label: const Text(
                                            'Añadir Foto',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 176, 74, 11),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      )
                                          .animate()
                                          .fadeIn(duration: 1.seconds)
                                          .moveY(end: 0, begin: -50),
                                      const SizedBox(width: 16),
                                      // Botón "Editar Información"
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 4),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xfff3ece7),
                                              Color(0xfff3ece7),
                                            ], // Gradiente blanco
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 176, 74, 11),
                                            width: 2,
                                          ),
                                        ),
                                        child: TextButton.icon(
                                          onPressed: _editProfile,
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Color.fromARGB(
                                                255, 176, 74, 11),
                                          ),
                                          label: const Text(
                                            'Editar Perfil',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 176, 74, 11),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      )
                                          .animate()
                                          .fadeIn(duration: 1.seconds)
                                          .moveY(end: 0, begin: -50),
                                    ],
                                  ),
                                  const SizedBox(height: 32),
                                  // Datos adicionales
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.cake_outlined,
                                              color: Color.fromARGB(
                                                  255, 176, 74, 11),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                user['edad'].toString(),
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 85, 85, 85),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.badge_outlined,
                                              color: Color.fromARGB(
                                                  255, 176, 74, 11),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                user['dni'].toString(),
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 85, 85, 85),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.email,
                                              color: Color.fromARGB(
                                                  255, 176, 74, 11),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                user['email'] ??
                                                    'No disponible',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 85, 85, 85),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.phone,
                                              color: Color.fromARGB(
                                                  255, 176, 74, 11),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                user['phone'].toString(),
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 85, 85, 85),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.edit,
                                              color: Color.fromARGB(
                                                  255, 176, 74, 11),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                // Abrir un cuadro de diálogo para pedir el correo electrónico
                                                String? email =
                                                    await showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    String tempEmail = '';
                                                    bool _obscureText = true;

                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Restablecer Contraseña'),
                                                      content: StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                          return TextField(
                                                            onChanged: (value) {
                                                              tempEmail = value;
                                                            },
                                                            obscureText:
                                                                _obscureText,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Correo Electrónico',
                                                              hintText:
                                                                  'Introduce tu correo electrónico',
                                                              suffixIcon:
                                                                  IconButton(
                                                                icon: Icon(
                                                                  _obscureText
                                                                      ? Icons
                                                                          .visibility_off
                                                                      : Icons
                                                                          .visibility,
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _obscureText =
                                                                        !_obscureText; // Alterna la visibilidad
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(
                                                                    null); // Cancelar
                                                          },
                                                          child: const Text(
                                                              'Cancelar'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(
                                                                    tempEmail); // Confirmar
                                                          },
                                                          child: const Text(
                                                              'Enviar'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                // Validar el correo e intentar enviar el correo de restablecimiento
                                                if (email != null &&
                                                    email.isNotEmpty) {
                                                  try {
                                                    await FirebaseAuth.instance
                                                        .sendPasswordResetEmail(
                                                            email: email);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Correo de restablecimiento enviado. Verifica tu bandeja de entrada.'),
                                                      ),
                                                    );
                                                  } catch (e) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Error al enviar el correo: $e'),
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'El correo electrónico no puede estar vacío.'),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'Restablecer Contraseña',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 85, 85, 85),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 22),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
