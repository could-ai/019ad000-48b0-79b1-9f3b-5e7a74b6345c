import 'dart:math';
import '../models/user_model.dart';
import '../models/message_model.dart';

class MockService {
  static User? currentUser;
  static final Random _random = Random();

  static final List<User> users = [
    const User(id: '1', name: 'Alice', avatarUrl: 'https://i.pravatar.cc/150?u=1'),
    const User(id: '2', name: 'Bob', avatarUrl: 'https://i.pravatar.cc/150?u=2'),
    const User(id: '3', name: 'Charlie', avatarUrl: 'https://i.pravatar.cc/150?u=3'),
    const User(id: '4', name: 'David', avatarUrl: 'https://i.pravatar.cc/150?u=4'),
  ];

  static final List<Message> messages = [
    Message(
      id: '1',
      senderId: '2',
      receiverId: '1',
      text: 'Hey Alice, how are you?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Message(
      id: '2',
      senderId: '1',
      receiverId: '2',
      text: 'I am good Bob! Thanks for asking.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
  ];

  static final List<String> _randomPhrases = [
    "That's interesting!",
    "Tell me more.",
    "I see.",
    "Cool.",
    "How's it going?",
    "Nice!",
    "Really?",
    "Okay.",
    "Sounds good.",
    "What do you mean?",
    "I'm listening.",
    "Go on...",
    "Haha, that's funny!",
    "I was thinking the same thing.",
    "Can we talk about this later?",
    "Absolutely!",
  ];

  static void login(String name) {
    // Simple mock login: find user by name or create a temporary one
    try {
      currentUser = users.firstWhere((u) => u.name.toLowerCase() == name.toLowerCase());
    } catch (e) {
      // If not found, create a dummy user
      currentUser = User(id: '999', name: name, avatarUrl: 'https://i.pravatar.cc/150?u=999');
    }
  }

  static List<Message> getMessages(String otherUserId) {
    if (currentUser == null) return [];
    return messages.where((m) =>
      (m.senderId == currentUser!.id && m.receiverId == otherUserId) ||
      (m.senderId == otherUserId && m.receiverId == currentUser!.id)
    ).toList()..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  static void sendMessage(String text, String receiverId) {
    if (currentUser == null) return;
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: currentUser!.id,
      receiverId: receiverId,
      text: text,
      timestamp: DateTime.now(),
    );
    messages.add(newMessage);
  }
  
  static void receiveMockReply(String senderId, String text) {
     if (currentUser == null) return;
     final reply = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId,
      receiverId: currentUser!.id,
      text: text,
      timestamp: DateTime.now(),
    );
    messages.add(reply);
  }

  static String generateAutoReply(String message) {
    final lowerMsg = message.toLowerCase();
    
    if (lowerMsg.contains('hello') || lowerMsg.contains('hi') || lowerMsg.contains('hey')) {
      return "Hey there! How are you doing?";
    }
    if (lowerMsg.contains('how are you')) {
      return "I'm doing great, thanks for asking! And you?";
    }
    if (lowerMsg.contains('bye') || lowerMsg.contains('goodbye')) {
      return "See you later! Have a nice day.";
    }
    if (lowerMsg.contains('name')) {
      return "I'm a mock user, but you can call me friend.";
    }
    if (lowerMsg.contains('?')) {
      final answers = ["Yes, absolutely.", "No, I don't think so.", "Maybe.", "I'm not sure about that.", "Definitely!"];
      return answers[_random.nextInt(answers.length)];
    }
    
    return _randomPhrases[_random.nextInt(_randomPhrases.length)];
  }
}
