import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void submitMessage() async {
    final enteredMessage = _controller.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }
    _controller.clear();
    Focus.of(context).unfocus();

    final user = FirebaseAuth.instance.currentUser!;
    final userData =
        await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'userId': user.uid,
      'message': enteredMessage,
      'createdAt': Timestamp.now(),
      'username': userData.data()!['username'],
      'userImage': userData.data()!['userImage']
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Enter message ...."),
            autocorrect: true,
            enableSuggestions: true,
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: submitMessage,
        )
      ],
    );
  }
}
