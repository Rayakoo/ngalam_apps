import 'package:tes_gradle/core/usecases.dart';
import 'package:tes_gradle/features/domain/entities/notification.dart';
import 'package:tes_gradle/features/domain/repositories/notification_repository.dart';

class CreateNotification implements UseCase<Notification, NotificationParams> {
  final NotificationRepository repository;

  CreateNotification(this.repository);

  @override
  Future<Notification> call(NotificationParams params) async {
    return await repository.createNotification(params.notification);
  }
}

class GetNotificationsByUserId implements UseCase<List<Notification>, String> {
  final NotificationRepository repository;

  GetNotificationsByUserId(this.repository);

  @override
  Future<List<Notification>> call(String userId) async {
    return await repository.getNotificationsByUserId(userId);
  }
}

class NotificationParams {
  final Notification notification;

  NotificationParams(this.notification);
}
