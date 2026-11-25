
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/notification_model.dart';


class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user's notification collection
  CollectionReference<Map<String, dynamic>> get _notificationsRef {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      throw Exception('No user is currently logged in.');
    }

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications');
  }

  // Save a notification to Firestore
  Future<void> saveNotification({
    required String title,
    required String body,
    String type = 'general',
  }) async {
    await _notificationsRef.add({
      'title': title,
      'body': body,
      'type': type,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get notifications in real time
  Stream<List<NotificationModel>> getNotifications() {
    return _notificationsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    });
  }

  // Mark one notification as read
  Future<void> markAsRead(String notificationId) async {
    await _notificationsRef.doc(notificationId).update({
      'isRead': true,
    });
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    final snapshot = await _notificationsRef
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }
}
