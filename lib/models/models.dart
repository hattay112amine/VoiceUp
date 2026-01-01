enum FriendRequestStatus {
  pending,
  accepted,
  declined,
}

// --- MODELS ---

class FriendRequestModel {
  final String id;
  final String senderId;
  final String receiverId;
  final FriendRequestStatus status;
  final DateTime createdAt;

  FriendRequestModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
  });
}

class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String? photoURL;
  final bool isOnline;
  final DateTime? lastSeen;

  UserModel({
    this.id = '',
    required this.displayName,
    required this.email,
    this.photoURL,
    this.isOnline = false,
    this.lastSeen,
  });

  String get uid => id;
}

class FriendshipModel {
  final String user1Id;
  final String user2Id;
  final bool isBlocked;

  FriendshipModel({
    required this.user1Id,
    required this.user2Id,
    this.isBlocked = false,
  });

  String getOtherUserId(String currentUserId) {
    if (user1Id == currentUserId) {
      return user2Id;
    } else {
      return user1Id;
    }
  }
}

// --- CLASS ChatModel CORRIGÉE ---

class ChatModel {
  final String id;
  final List<String> userIds;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final String lastMessageSenderId; // Ajouté comme champ réel

  ChatModel({
    required this.id,
    required this.userIds,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.lastMessageSenderId = '', // Valeur par défaut
  });

  // CORRECTION 1 : Méthode pour obtenir l'ID de l'autre participant
  String getOtherParticipant(String currentUserId) {
    return userIds.firstWhere(
          (id) => id != currentUserId,
      orElse: () => '',
    );
  }

  // CORRECTION 2 : Retourne le compteur stocké
  int getUnreadCount(String currentUserId) {
    return unreadCount;
  }

  // CORRECTION 3 : La fonction retourne maintenant obligatoirement un booléen
  bool isMessageSeen(String currentUserId, String otherUserId) {
    // LOGIQUE :
    // Si l'envoyeur est l'utilisateur actuel, on veut savoir si l'autre a vu le message.
    // Dans ce modèle simple, on ne stocke pas encore "vu par qui".
    // Pour corriger l'erreur technique, on retourne 'false' par défaut ou une logique basée sur un champ futur.

    // Exemple temporaire pour que le code compile :
    // Si j'ai envoyé le message, je considère qu'il est "vu" (simulé) pour l'instant
    if (lastMessageSenderId == currentUserId) {
      return true; // Mettre à false si vous voulez tester l'icône grise
    }

    return false;
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final String type;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.isRead,
    required this.type,
  });
}