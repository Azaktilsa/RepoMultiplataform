// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:azaktilza/Presentation/client/Screens/Chat/ChatUser.dart';
import 'package:azaktilza/env_loader.dart';

class ChatListUser extends StatefulWidget {
  const ChatListUser({super.key});

  @override
  _ChatListUserState createState() => _ChatListUserState();
}

class _ChatListUserState extends State<ChatListUser> {
  late final DatabaseReference _dbRef;

  List<Map<String, dynamic>> dataList = [];
  String? selectedKeyAdmin; // Guarda la clave del usuario presionado
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    if (kIsWeb) {
      _dbRef = FirebaseDatabase.instance.ref(EnvLoader.get("CONTROLER")!);
    } else {
      _dbRef =
          FirebaseDatabase.instance.ref("Empresas/TerrawaSufalyng/Control");
    }
    _fetchDataUser();
  }

  void _fetchDataUser() async {
    final snapshot = await _dbRef.get();
    final dynamic data = snapshot.value;
    if (data is Map) {
      List<Map<String, dynamic>> tempList = [];

      for (var e in data.entries) {
        if (e.value['role']?.toString() == 'admin') {
          final adminKey = e.key.toString();
          final name = e.value['name']?.toString() ?? 'No disponible';
          final email = e.value['email']?.toString() ?? 'No disponible';
          final role = e.value['role']?.toString() ?? 'No disponible';

          String lastMessage = '';
          String lastMessageTime = '';
          int unreadCount = 0;

          try {
            final messageSnapshot = await FirebaseFirestore.instance
                .collection('Chats')
                .doc('${_currentUser!.uid}_$adminKey')
                .collection('messages')
                .orderBy('timestamp', descending: true)
                .limit(1)
                .get();

            if (messageSnapshot.docs.isNotEmpty) {
              final lastDoc = messageSnapshot.docs.first;
              lastMessage = lastDoc['message'] ?? '';
              final timestamp = lastDoc['timestamp'] as Timestamp;
              final date = timestamp.toDate();

              lastMessageTime =
                  '${(date.hour % 12 == 0 ? 12 : date.hour % 12).toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'pm' : 'am'}';
            }
          } catch (e) {
            // puedes imprimir el error si necesitas
          }
          try {
            final unreadSnapshot = await FirebaseFirestore.instance
                .collection('Chats')
                .doc('${_currentUser!.uid}_$adminKey')
                .collection('messages')
                .where('read', isEqualTo: false)
                .get();

            unreadCount = unreadSnapshot.docs.length;
          } catch (e) {
            // puedes imprimir el error si necesitas
          }

          tempList.add({
            'key': adminKey,
            'Name': name,
            'Email': email,
            'Rol': role,
            'lastMessage': lastMessage,
            'lastMessageTime': lastMessageTime,
            'unreadCount': unreadCount,
          });
        }
      }

      setState(() {
        dataList = tempList;
      });
    }
  }

  void _markMessagesAsRead(String adminId) async {
    final query = await FirebaseFirestore.instance
        .collection('Chats')
        .doc('${_currentUser!.uid}_$adminId')
        .collection('messages')
        .where('receiverId', isEqualTo: _currentUser!.uid)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in query.docs) {
      await doc.reference.update({
        'isRead': true,
        'status': 'read', // opcional si usas status
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: dataList.map((data) {
                bool isSelected = selectedKeyAdmin ==
                    data['key']; // Verificar si el contenedor está seleccionado

                return GestureDetector(
                  onLongPress: () {
                    setState(() {
                      selectedKeyAdmin =
                          data['key']; // Seleccionar el contenedor
                    });
                  },
                  onTap: () {
                    setState(() {
                      _markMessagesAsRead(data['key']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat_User(
                            adminId: data['key'],
                          ),
                        ),
                      );
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xfff3ece7)
                          : const Color(0xfff4f4f4),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xfff3ece7),
                          radius: 30,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logoOscuro3.jpeg',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['Name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                data['lastMessage'] ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if ((data['unreadCount'] ?? 0) > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${data['unreadCount']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Text(
                          data['lastMessageTime'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 73, 73, 73),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
