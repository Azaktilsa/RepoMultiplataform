// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class ChatAdmin extends StatefulWidget {
  final String userId;

  const ChatAdmin({super.key, required this.userId});

  @override
  _ChatAdminState createState() => _ChatAdminState();
}

class _ChatAdminState extends State<ChatAdmin> {
  final TextEditingController _controllerAdmin = TextEditingController();
  final _scrollControllerAdmin = ScrollController();

  User? _currentAdmin;

  String? userName;
  String? userEmail;
  String? userRole;
  String? userImage;

  bool _isEmojiVisibleAdmin = false;
  // Para la selección de mensajes
  Set<String> selectedMessages = {};
  bool selectionMode = false;
  bool _isMessageEmpty = true;


  @override
  void initState() {
    super.initState();
    _currentAdmin = FirebaseAuth.instance.currentUser;
    _fetchUserInfo();
    _controllerAdmin.addListener(_handleMessageChange);
  }

  void markMessagesAsRead() async {
    final messagesRef = FirebaseFirestore.instance
        .collection('Chats')
        .doc('${widget.userId}_${_currentAdmin!.uid}')
        .collection('messages');

    final snapshot = await messagesRef
        .where('receiverId', isEqualTo: _currentAdmin!.uid)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  void _handleMessageChange() {
    final isEmpty = _controllerAdmin.text.trim().isEmpty;
    if (isEmpty != _isMessageEmpty) {
      setState(() {
        _isMessageEmpty = isEmpty;
      });
    }
  }

  Future<void> _fetchUserInfo() async {
    final dbRef = FirebaseDatabase.instance.ref();
    final snapshot = await dbRef.child(dotenv.env['CONTROLER']!).get();

    if (snapshot.exists) {
      final data = snapshot.value;

      if (data is Map) {
        final userData = data[widget.userId];
        if (userData != null && userData is Map) {
          setState(() {
            userName = userData['name'] ?? 'No disponible';
            userEmail = userData['email'] ?? 'No disponible';
            userRole = userData['role'] ?? 'No disponible';
            userImage = userData['profilePictureUrl'] ?? 'No disponible';
          });
        } else {
          setState(() {
            userName = 'Usuario no encontrado';
          });
        }
      } else {
        setState(() {
          userName = 'Formato de datos no válido';
        });
      }
    } else {
      setState(() {
        userName = 'Usuario no encontrado';
      });
    }
  }

  void _sendMessage() async {
    final text = _controllerAdmin.text.trim();
    if (text.isEmpty || _currentAdmin == null) return;

    await FirebaseFirestore.instance
        .collection('Chats')
        .doc('${widget.userId}_${_currentAdmin!.uid}')
        .collection('messages')
        .add({
      'receiverId': widget.userId,
      'senderId': _currentAdmin!.uid,
      'message': text,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    _controllerAdmin.clear();
  }

  void _toggleEmojiKeyboard() {
    FocusScope.of(context).unfocus(); // Oculta el teclado
    setState(() {
      _isEmojiVisibleAdmin = !_isEmojiVisibleAdmin;
    });
  }

  void _deleteSelectedMessages() async {
    // Muestra un cuadro de diálogo de confirmación
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar los mensajes seleccionados?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No eliminar
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmar eliminación
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    // Si el usuario confirma la eliminación, procedemos
    if (confirmDelete == true) {
      // Elimina los mensajes seleccionados
      for (String msgId in selectedMessages) {
        await FirebaseFirestore.instance
            .collection('Chats')
            .doc('${widget.userId}_${_currentAdmin!.uid}')
            .collection('messages')
            .doc(msgId)
            .delete();
      }

      // Restablece el estado después de eliminar los mensajes
      setState(() {
        selectionMode = false;
        selectedMessages.clear();
      });
    }
  }

  Future<void> _pickImageAndShowPreview({required ImageSource source}) async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile == null) {
      print('⚠️ No se seleccionó ninguna imagen.');
      return;
    }

    final File imageFile = File(pickedFile.path);

    // Mostrar vista previa
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vista previa'),
        content: Image.file(imageFile),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar vista previa
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              uploadImageFromFile(imageFile);
              Navigator.of(context).pop(); // Cerrar vista previa
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  Future<void> uploadImageFromFile(File imageFile) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = FirebaseStorage.instance.ref().child('chat_images/$fileName');

    try {
      final uploadTask = await ref.putFile(imageFile);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('Chats')
          .doc('${widget.userId}_${_currentAdmin!.uid}')
          .collection('messages')
          .add({
        'receiverId': widget.userId,
        'senderId': _currentAdmin!.uid,
        'message': '[imagen]',
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagen enviada correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir imagen: $e')),
      );
    }
  }

  /// imagen seleccionada en la App.
  Future<void> _saveSelectedImage() async {
    if (selectedMessages.length != 1) return;

    final selectedId = selectedMessages.first;
    final snapshot = await FirebaseFirestore.instance
        .collection('messages') // Usa el nombre de tu colección
        .doc(selectedId)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data()!;
      if (data.containsKey('imageUrl')) {
        final imageUrl = data['imageUrl'];
        await _saveImageToGallery(context, imageUrl);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagen guardada en galería')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El mensaje no es una imagen')),
        );
      }
    }
  }

  /// Guarda la imagen en la galería del dispositivo.
  Future<void> _saveImageToGallery(
      BuildContext context, String imageUrl) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de almacenamiento denegado')),
      );
      return;
    }

    try {
      final response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = Uint8List.fromList(response.data);

      // Ruta para carpeta de descargas en Android
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!downloadsDir.existsSync()) {
        await downloadsDir.create(recursive: true);
      }

      final filePath =
          '${downloadsDir.path}/chat_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final file = File(filePath);
      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imagen guardada en: ${file.path}')),
      );

      debugPrint('Imagen guardada en: $filePath');
    } catch (e) {
      debugPrint('Error al guardar la imagen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar la imagen')),
      );
    }
  }

  Future<void> _shareSelectedMessage() async {
    if (selectedMessages.length != 1) return;

    final selectedId = selectedMessages.first;

    final snapshot = await FirebaseFirestore.instance
        .collection('Chats')
        .doc('${widget.userId}_${_currentAdmin!.uid}')
        .collection('messages')
        .doc(selectedId)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data()!;
      if (data.containsKey('message')) {
        final text = data['message'];
        await Share.share(text);
      } else if (data.containsKey('imageUrl')) {
        final imageUrl = data['imageUrl'];

        final response = await Dio().get(
          imageUrl,
          options: Options(responseType: ResponseType.bytes),
        );

        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/shared_image.jpg');
        await file.writeAsBytes(response.data);

        await Share.shareXFiles([XFile(file.path)], text: 'Imagen del chat');
      }
    }
  }

  @override
  void dispose() {
    _controllerAdmin.removeListener(_handleMessageChange);
    _scrollControllerAdmin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMessageEmpty = _controllerAdmin.text.trim().isEmpty;
    markMessagesAsRead();
    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 126, 53, 0),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                selectionMode ? Icons.close : Icons.arrow_back,
                color: const Color(0xfff3ece7),
                size: 30,
              ),
              onPressed: () {
                if (selectionMode) {
                  setState(() {
                    selectionMode = false;
                    selectedMessages.clear();
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            title: selectionMode
                ? Text(
                    '${selectedMessages.length} seleccionados',
                    style: const TextStyle(
                      color: Color(0xfff3ece7),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xfff3ece7),
                        radius: 20,
                        backgroundImage: (userImage != null &&
                                userImage != 'No disponible' &&
                                userImage!.isNotEmpty)
                            ? NetworkImage(userImage!) as ImageProvider<Object>
                            : const AssetImage('assets/images/logoOscuro3.jpeg')
                                as ImageProvider<Object>,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        userName ?? 'No disponible',
                        style: const TextStyle(
                          color: Color(0xfff3ece7),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
            actions: selectionMode
                ? [
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Color(0xfff3ece7),
                      ),
                      onPressed: _deleteSelectedMessages,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.save_alt,
                        color: Color(0xfff3ece7),
                      ),
                      onPressed: _saveSelectedImage,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.share,
                        color: Color(0xfff3ece7),
                      ),
                      onPressed: _shareSelectedMessage,
                    ),
                  ]
                : [],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Chats')
                  .doc('${widget.userId}_${_currentAdmin!.uid}')
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/logoOscuro3.jpeg',
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No hay mensajes aún.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                // Aquí marcas como leídos los que no lo están y son para el admin
                for (var msg in messages) {
                  final data = msg.data() as Map<String, dynamic>;
                  if (data['receiverId'] == _currentAdmin!.uid &&
                      data['isRead'] == false) {
                    msg.reference.update({'isRead': true});
                  }
                }

                final messageScrollController = ScrollController();

                // Esperar un frame para asegurar que los widgets están construidos
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (messageScrollController.hasClients) {
                    messageScrollController.animateTo(
                      messageScrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return _AnimatedMessageBubble(
                      key: ValueKey(msg.id),
                      msg: msg,
                      currentAdmin: _currentAdmin?.uid,
                      isSelected: selectedMessages.contains(msg.id),
                      userName: userName,
                      onTap: () {
                        setState(() {
                          if (selectionMode) {
                            if (selectedMessages.contains(msg.id)) {
                              selectedMessages.remove(msg.id);
                              if (selectedMessages.isEmpty) {
                                selectionMode = false;
                              }
                            } else {
                              selectedMessages.add(msg.id);
                            }
                          }
                        });
                      },
                      onLongPress: () {
                        setState(() {
                          selectionMode = true;
                          selectedMessages.add(msg.id);
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.emoji_emotions_outlined,
                                color: Color.fromARGB(255, 176, 74, 11),
                              ),
                              onPressed: _toggleEmojiKeyboard,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _controllerAdmin,
                                scrollController: _scrollControllerAdmin,
                                decoration: const InputDecoration(
                                  hintText: 'Escribe un mensaje...',
                                  border: InputBorder.none,
                                ),
                                onTap: () {
                                  if (_isEmojiVisibleAdmin) {
                                    setState(() {
                                      _isEmojiVisibleAdmin = false;
                                    });
                                  }
                                },
                                onSubmitted: (_) => _sendMessage(),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.photo_camera,
                                color: Color.fromARGB(255, 176, 74, 11),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return SafeArea(
                                      child: Wrap(
                                        children: [
                                          ListTile(
                                            leading:
                                                const Icon(Icons.camera_alt),
                                            title: const Text('Tomar foto'),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _pickImageAndShowPreview(
                                                  source: ImageSource.camera);
                                            },
                                          ),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.photo_library),
                                            title:
                                                const Text('Elegir de galería'),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _pickImageAndShowPreview(
                                                  source: ImageSource.gallery);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: isMessageEmpty ? null : _sendMessage,
                      child: CircleAvatar(
                        backgroundColor: isMessageEmpty
                            ? Colors.grey
                            : const Color.fromARGB(255, 176, 74, 11),
                        radius: 22,
                        child: const Icon(
                          Icons.send_rounded,
                          color: Color(0xfff3ece7),
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _isEmojiVisibleAdmin
                      ? EmojiPicker(
                          key: const ValueKey(true),
                          textEditingController: _controllerAdmin,
                          scrollController: _scrollControllerAdmin,
                          config: Config(
                            height: 256,
                            checkPlatformCompatibility: true,
                            emojiViewConfig: EmojiViewConfig(
                              emojiSizeMax: 28 *
                                  (foundation.defaultTargetPlatform ==
                                          TargetPlatform.iOS
                                      ? 1.2
                                      : 1.0),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey(false)),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _AnimatedMessageBubble extends StatefulWidget {
  final DocumentSnapshot msg;
  final String? currentAdmin;
  final bool isSelected;
  final String? userName;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _AnimatedMessageBubble({
    super.key,
    required this.msg,
    required this.currentAdmin,
    required this.isSelected,
    required this.userName,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<_AnimatedMessageBubble> createState() => _AnimatedMessageBubbleState();
}

class _AnimatedMessageBubbleState extends State<_AnimatedMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(); // Inicia la animación
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final dateTime = timestamp.toDate();
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final senderId = widget.msg['senderId'];
    final isCurrentAdmin = senderId == widget.currentAdmin;
    final isUserMessage = isCurrentAdmin;

    final alignment =
        isUserMessage ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = widget.isSelected
        ? Colors.orange.shade100
        : isUserMessage
            ? const Color.fromARGB(255, 255, 197, 155)
            : Colors.grey.shade300;
    final textColor = isUserMessage
        ? const Color.fromARGB(255, 0, 0, 0)
        : const Color.fromARGB(255, 0, 0, 0);
    final senderLabel = isCurrentAdmin ? 'Tú' : widget.userName ?? senderId;

    final timestamp = widget.msg['timestamp'] as Timestamp?;
    final data = widget.msg.data() as Map<String, dynamic>;
    final isRead = data['isRead'] ?? false;

    return Align(
      alignment: alignment,
      child: SlideTransition(
        position: _offsetAnimation,
        child: GestureDetector(
          onTap: () {
            if (data.containsKey('imageUrl')) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ImagePreviewScreen(imageUrl: data['imageUrl']),
                ),
              );
            } else {
              widget.onTap();
            }
          },
          onLongPress: widget.onLongPress,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUserMessage ? 16 : 0),
                bottomRight: Radius.circular(isUserMessage ? 0 : 16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.containsKey('imageUrl'))
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      data['imageUrl'],
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Text(
                    widget.msg['message'],
                    style: TextStyle(
                      fontSize: 18,
                      color: widget.isSelected
                          ? const Color.fromARGB(255, 0, 0, 0)
                          : textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$senderLabel • ${_formatTimestamp(timestamp)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: widget.isSelected
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : textColor,
                      ),
                    ),
                    if (isCurrentAdmin) ...[
                      const SizedBox(
                        width: 50,
                      ),
                      Icon(
                        isRead ? Icons.done_all : Icons.done,
                        size: 16,
                        color: isRead ? Colors.blue : Colors.grey,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xfff3ece7),
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.download,
              color: Color(0xfff3ece7),
            ),
            onPressed: () async {
              await saveImageToLocal(imageUrl, context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Imagen guardada en la galería')),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.reply,
              color: Color(0xfff3ece7),
            ),
            onPressed: () async {
              final response = await Dio().get(
                imageUrl,
                options: Options(responseType: ResponseType.bytes),
              );

              final tempDir = await getTemporaryDirectory();
              final file = File('${tempDir.path}/shared_image.jpg');
              await file.writeAsBytes(response.data);

              await Share.shareXFiles([XFile(file.path)],
                  text: 'Imagen del chat');
            },
          ),
        ],
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
        ),
      ),
    );
  }

  Future<void> saveImageToLocal(String imageUrl, BuildContext context) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de almacenamiento denegado')),
      );
      return;
    }

    try {
      final response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = Uint8List.fromList(response.data);
      final directory = await getExternalStorageDirectory();

      // Asegúrate de que el directorio existe
      final downloadPath = Directory("${directory!.path}/Download");
      if (!(await downloadPath.exists())) {
        await downloadPath.create(recursive: true);
      }

      final filePath =
          "${downloadPath.path}/chat_image_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagen guardada en la carpeta Download')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar la imagen')),
      );
    }
  }
}
