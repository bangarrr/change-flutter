import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageListScreen extends HookConsumerWidget {
  MessageListScreen({super.key});

  final List<Map<String, dynamic>> messages = [
    {
      'body': 'めっちゃわかる！w そういうときあるよね笑',
      'created_at': '2022-01-01T12:34:56',
      'user': {
        'name': '山田太郎',
      }
    },
    {
      'body': 'めっちゃわかる！w そういうときあるよね笑',
      'created_at': '2022-01-01T12:34:56',
      'user': {
        'name': '山田太郎',
      }
    },
    {
      'body': 'めっちゃわかる！w そういうときあるよね笑',
      'created_at': '2022-01-01T12:34:56',
      'user': {
        'name': '山田太郎',
      }
    }
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return ListTile(
              // leading: CircleAvatar(
              //   backgroundImage: NetworkImage(message['user']['icon']),
              // ),
              title: Text(message['user']['name']),
              subtitle: Text(message['body']),
              trailing: Text(message['created_at']),
            );
          },
        )
      ),
    );
  }
}
