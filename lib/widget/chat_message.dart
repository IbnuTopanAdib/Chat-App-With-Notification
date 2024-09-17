import 'package:chat_with_notif/widget/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    final authenticatedUserId = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No message available'),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('There was an error'),
            );
          }

          final chatMessages = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 40, left: 15, right: 15),
            reverse: true,
            itemCount: chatMessages.length,
            itemBuilder: (context, index) {
              final chatMessage = chatMessages[index].data();
              final nextChatMessage = index + 1 < chatMessages.length
                  ? chatMessages[index + 1].data()
                  : null;

              final userId = chatMessage['userId'];
              final nextUserId =
                  nextChatMessage != null ? nextChatMessage['userId'] : null;

              final isNextUserSame = userId == nextUserId;
              if (!isNextUserSame) {
                return MessageBubble.next(
                    message: chatMessage['message'],
                    isMe: authenticatedUserId == userId);
              } else {
                return MessageBubble.first(
                    userImage: chatMessage['userImage'],
                    username: chatMessage['userName'],
                    message: chatMessage['message'],
                    isMe: authenticatedUserId == userId);
              }
            },
          );
        });
  }
}
