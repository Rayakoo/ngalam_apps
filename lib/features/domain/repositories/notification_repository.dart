import 'package:tes_gradle/features/domain/entities/notification.dart';

abstract class NotificationRepository {
  Future<Notification> createNotification(Notification notification);
  Future<List<Notification>> getNotificationsByUserId(String userId);
}
