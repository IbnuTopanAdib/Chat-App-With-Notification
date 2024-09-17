import 'package:chat_with_notif/widget/chat_message.dart';
import 'package:chat_with_notif/widget/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat Screen'),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Column(
          children: const [
            Expanded(child: ChatMessage()),
            NewMessage(),
          ],
        ));
  }
}
