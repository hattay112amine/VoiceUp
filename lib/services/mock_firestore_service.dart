import 'dart:async';
import 'package:collection/collection.dart';
import 'package:voiceup/models/models.dart';

class FirestoreService {
  final List<ChatModel> _fakeChats = [
    ChatModel(
      id: 'chat_mock_1',
      userIds: ['user_1', 'CURRENT_USER_ID'],
      lastMessage: "Salut, tu es dispo ?",
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 10)),
      unreadCount: 1,
    ),
    ChatModel(
      id: 'chat_mock_2',
      userIds: ['user_2', 'CURRENT_USER_ID'],
      lastMessage: "Ok, on fait comme ça.",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
    ),
  ];

  // --- Données Mockées Enrichies ---
  final List<UserModel> _fakeUsers = [
    UserModel(
        id: 'user_1',
        displayName: 'Thomas Shelby',
        email: 'tommy@test.com',
        photoURL: 'https://i.pravatar.cc/150?u=1',
        isOnline: true,
        lastSeen: DateTime.now()
    ),
    UserModel(
        id: 'user_2',
        displayName: 'Arthur Shelby',
        email: 'arthur@test.com',
        photoURL: null,
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(minutes: 15))
    ),
    UserModel(
        id: 'user_3',
        displayName: 'Polly Gray',
        email: 'polly@test.com',
        photoURL: 'https://i.pravatar.cc/150?u=3',
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(days: 2))
    ),
    UserModel(
        id: 'user_4',
        displayName: 'John Shelby',
        email: 'john@test.com',
        photoURL: '',
        isOnline: true,
        lastSeen: DateTime.now()
    ),
    UserModel(
        id: 'user_5',
        displayName: 'Grace Burgess',
        email: 'grace@test.com',
        photoURL: 'https://i.pravatar.cc/150?u=5',
        isOnline: true,
        lastSeen: DateTime.now()
    ),
    UserModel(
        id: 'user_6',
        displayName: 'Ada Thorne',
        email: 'ada@test.com',
        photoURL: null,
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(hours: 5))
    ),
  ];
  // --- Liste des amitiés mockées ---
  final List<FriendshipModel> _fakeFriendships = [
    FriendshipModel(user1Id: 'CURRENT_USER_ID', user2Id: 'user_2'), // Arthur
    FriendshipModel(user1Id: 'user_3', user2Id: 'CURRENT_USER_ID'), // Polly
  ];


  // Simulation de requêtes reçues
  final List<FriendRequestModel> _fakeRequests = [
    FriendRequestModel(
      id: 'req_mock_1',
      senderId: 'user_5',
      receiverId: 'CURRENT_USER_ID',
      status: FriendRequestStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    FriendRequestModel(
      id: 'req_mock_2',
      senderId: 'user_6',
      receiverId: 'CURRENT_USER_ID',
      status: FriendRequestStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // --- LECTURE (Streams / Futures) ---

  Future<UserModel?> getUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _fakeUsers.firstWhereOrNull((u) => u.id == userId);
  }

  Stream<List<UserModel>> getAllUsersStream() {
    return Stream.value(_fakeUsers);
  }

  Stream<List<FriendshipModel>> getFriendsStream(String currentUserId) {
    // On filtre la liste _fakeFriendships pour trouver les amitiés de l'utilisateur
    final myFriends = _fakeFriendships.where((f) =>
    f.user1Id == currentUserId || f.user2Id == currentUserId ||
        f.user1Id == 'CURRENT_USER_ID' || f.user2Id == 'CURRENT_USER_ID'
    ).toList();

    return Stream.value(myFriends);
  }

  Stream<List<FriendRequestModel>> getFriendRequestsStream(String currentUserId) {
    return Stream.value(_fakeRequests.where((r) =>
    (r.receiverId == currentUserId || r.receiverId == 'CURRENT_USER_ID') &&
        r.status == FriendRequestStatus.pending
    ).toList());
  }

  Stream<List<FriendRequestModel>> getSentFriendRequestsStream(String currentUserId) {
    return Stream.value(_fakeRequests.where((r) =>
    r.senderId == currentUserId &&
        r.status == FriendRequestStatus.pending
    ).toList());
  }

  // --- ÉCRITURE (Actions) ---

  Future<void> sendFriendRequest(FriendRequestModel request) async {
    await Future.delayed(const Duration(seconds: 1));
    _fakeRequests.add(request);
    print("MOCK: Requête envoyée de ${request.senderId} à ${request.receiverId}");
  }

  Future<void> cancelFriendRequest(String requestId) async {
    await Future.delayed(const Duration(seconds: 1));
    _fakeRequests.removeWhere((r) => r.id == requestId);
    print("MOCK: Requête $requestId annulée");
  }

  Future<void> acceptFriendRequest(String requestId) async {
    await Future.delayed(const Duration(seconds: 1));

    // 1. Trouver la demande
    final request = _fakeRequests.firstWhereOrNull((r) => r.id == requestId);

    if (request != null) {
      // 2. Créer la nouvelle amitié
      final newFriendship = FriendshipModel(
          user1Id: request.senderId,
          user2Id: request.receiverId
      );
      _fakeFriendships.add(newFriendship); // Ajouter à la liste

      // 3. Supprimer la demande
      _fakeRequests.removeWhere((r) => r.id == requestId);

      print("MOCK: Requête $requestId acceptée et amitié créée entre ${request.senderId} et ${request.receiverId}");
    }
  }

  Future<void> respondToFriendRequest(String requestId, FriendRequestStatus status) async {
    await Future.delayed(const Duration(seconds: 1));
    if (status == FriendRequestStatus.declined) {
      _fakeRequests.removeWhere((r) => r.id == requestId);
    }
    print("MOCK: Réponse à la requête $requestId : $status");
  }
  Future<void> removeFriendShip(String currentUserId, String friendId) async {
    await Future.delayed(const Duration(seconds: 1));

    _fakeFriendships.removeWhere((f) =>
    (f.user1Id == currentUserId && f.user2Id == friendId) ||
        (f.user1Id == friendId && f.user2Id == currentUserId) ||
        (f.user1Id == 'CURRENT_USER_ID' && f.user2Id == friendId) // Cas du mock
    );

    print("MOCK: Amitié avec $friendId supprimée");
  }

  Future<void> blockUser(String currentUserId, String friendId) async {
    await Future.delayed(const Duration(seconds: 1));
    print("MOCK: Ami $friendId bloqué");
  }

  Future<String> createOrGetChat(String currentUserId, String otherUserId) async {
    await Future.delayed(const Duration(seconds: 1));
    return "mock_chat_room_id_123";
  }

  Future<void> unblockUser(String currentUserId, String blockedUserId) async {
    await Future.delayed(const Duration(seconds: 1));
    print("MOCK: Utilisateur $blockedUserId débloqué par $currentUserId");
  }

  // --- CORRECTION ICI ---
  Stream<List<ChatModel>> getUserChatsStream(String currentUserId) {
    final myChats = _fakeChats.where((chat) {
      return chat.userIds.contains(currentUserId) || chat.userIds.contains('CURRENT_USER_ID');
    }).toList();

    // Correction du tri pour gérer les dates nulles
    myChats.sort((a, b) {
      // Si la date est null, on utilise une date très ancienne (0 millisecondes)
      final timeA = a.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
      final timeB = b.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);

      // Tri décroissant (le plus récent en premier)
      return timeB.compareTo(timeA);
    });

    return Stream.value(myChats);
  }

  // --- Données Mockées Notifications ---
  final List<NotificationModel> _fakeNotifications = [
    NotificationModel(
      id: 'notif_1',
      title: 'Nouveau message',
      body: 'Thomas Shelby vous a envoyé une photo.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false,
      type: 'message',
    ),
    NotificationModel(
      id: 'notif_2',
      title: 'Demande d\'ami',
      body: 'Grace Burgess souhaite vous ajouter en ami.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
      type: 'friend_request',
    ),
    NotificationModel(
      id: 'notif_3',
      title: 'Mise à jour système',
      body: 'VoiceUp v2.0 est maintenant disponible !',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
      type: 'system',
    ),
  ];

  Stream<List<NotificationModel>> getNotificationsStream(String currentUserId) {
    return Stream.value(_fakeNotifications);
  }

  Future<void> deleteChatForUser(String chatId, String currentUserId) async {
    await Future.delayed(const Duration(seconds: 1));
    _fakeChats.removeWhere((chat) => chat.id == chatId);
    print("MOCK: Chat $chatId supprimé avec succès pour l'utilisateur $currentUserId");
  }
}