import 'package:flutter/material.dart';
import 'package:tes_gradle/features/domain/entities/notification.dart'
    as domain;
import 'package:tes_gradle/features/domain/usecases/notification_usecases.dart';

class NotificationProvider with ChangeNotifier {
  final CreateNotification _createNotification;
  final GetNotificationsByUserId _getNotificationsByUserId;

  NotificationProvider(
    this._createNotification,
    this._getNotificationsByUserId,
  );

  List<domain.Notification>? _notificationList;
  bool _isLoading = false;

  List<domain.Notification>? get notificationList => _notificationList;
  bool get isLoading => _isLoading;

  Future<void> fetchNotificationsByUserId(String userId) async {
    _setLoading(true);
    try {
      _notificationList = await _getNotificationsByUserId.call(userId);
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addNotification(domain.Notification notification) async {
    _setLoading(true);
    try {
      final createdNotification = await _createNotification.call(
        NotificationParams(notification),
      );
      _notificationList ??= [];
      _notificationList?.add(createdNotification);
      notifyListeners();
    } catch (e) {
      print('Error adding notification: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }
}
