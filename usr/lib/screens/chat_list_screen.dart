import 'package:flutter/material.dart';
import '../services/mock_service.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = MockService.currentUser;
    // Filter out current user from the list
    final otherUsers = MockService.users.where((u) => u.id != currentUser?.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: otherUsers.isEmpty 
        ? const Center(child: Text("No other users available"))
        : ListView.builder(
            itemCount: otherUsers.length,
            itemBuilder: (context, index) {
              final user = otherUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarUrl),
                  child: Text(user.name[0]),
                ),
                title: Text(user.name),
                subtitle: const Text('Tap to start chatting'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/chat',
                    arguments: user,
                  );
                },
              );
            },
          ),
    );
  }
}
