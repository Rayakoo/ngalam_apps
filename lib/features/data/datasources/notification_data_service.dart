import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tes_gradle/features/data/models/notification_model.dart';

class NotificationDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<NotificationModel> createNotification(
    NotificationModel notification,
  ) async {
    try {
      final notificationData = notification.toJson();
      final notificationRef = await _firestore
          .collection('notifications')
          .add(notificationData);
      final notificationId = notificationRef.id;

      // Add the notification ID to the user's document
      await _firestore.collection('users').doc(notification.userId).update({
        'notifications': FieldValue.arrayUnion([notificationId]),
      });

      return NotificationModel.fromJson(notificationData, notificationId);
    } catch (e) {
      print('Error creating notification: $e');
      throw Exception('Error creating notification: $e');
    }
  }

  Future<List<NotificationModel>> getNotificationsByUserId(
    String userId,
  ) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('notifications')
              .where('userId', isEqualTo: userId)
              .get();
      return querySnapshot.docs
          .map(
            (doc) => NotificationModel.fromJson(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      print('Error getting notifications: $e');
      throw Exception('Error getting notifications: $e');
    }
  }
}
