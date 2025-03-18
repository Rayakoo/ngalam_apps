import 'package:tes_gradle/features/data/datasources/notification_data_service.dart';
import 'package:tes_gradle/features/data/models/notification_model.dart';
import 'package:tes_gradle/features/domain/entities/notification.dart';
import 'package:tes_gradle/features/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataService _notificationDataService;

  NotificationRepositoryImpl(this._notificationDataService);

  @override
  Future<Notification> createNotification(Notification notification) async {
    final notificationModel = NotificationModel(
      id: '',
      judul: notification.judul,
      kategori: notification.kategori,
      waktu: notification.waktu,
      deskripsi: notification.deskripsi,
      userId: notification.userId,
    );
    final createdNotificationModel = await _notificationDataService
        .createNotification(notificationModel);
    return Notification(
      id: createdNotificationModel.id,
      judul: createdNotificationModel.judul,
      kategori: createdNotificationModel.kategori,
      waktu: createdNotificationModel.waktu,
      deskripsi: createdNotificationModel.deskripsi,
      userId: createdNotificationModel.userId,
    );
  }

  @override
  Future<List<Notification>> getNotificationsByUserId(String userId) async {
    final notificationModels = await _notificationDataService
        .getNotificationsByUserId(userId);
    return notificationModels.map((notificationModel) {
      return Notification(
        id: notificationModel.id,
        judul: notificationModel.judul,
        kategori: notificationModel.kategori,
        waktu: notificationModel.waktu,
        deskripsi: notificationModel.deskripsi,
        userId: notificationModel.userId,
      );
    }).toList();
  }
}
