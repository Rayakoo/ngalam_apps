import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/domain/entities/notification.dart'
    as domain;
import 'package:tes_gradle/features/presentation/provider/notification_provider.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _selectedFilter = 'Semua waktu';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserNotifications();
    });
  }

  Future<void> _fetchUserNotifications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      await Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).fetchNotificationsByUserId(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.cce1f0,
      ),
      body:
          notificationProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  _buildDateFilter(),
                  Expanded(
                    child: Consumer<NotificationProvider>(
                      builder: (context, notificationProvider, child) {
                        final notifications =
                            notificationProvider.notificationList ?? [];
                        final groupedNotifications = _groupNotificationsByDate(
                          notifications,
                        );

                        return ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: groupedNotifications.length,
                          itemBuilder: (context, index) {
                            final date = groupedNotifications.keys.elementAt(
                              index,
                            );
                            final notificationsForDate =
                                groupedNotifications[date]!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('d MMMM yyyy').format(date),
                                  style: AppTextStyles.heading_4_bold.copyWith(
                                    color: AppColors.c2a6892,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...notificationsForDate.map((notification) {
                                  return _buildNotificationCard(notification);
                                }).toList(),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildDateFilter() {
    final filters = [
      'Semua waktu',
      'Hari ini',
      '7 Hari terakhir',
      '1 Bulan terakhir',
    ];
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () {
              if (mounted) {
                setState(() {
                  _selectedFilter = filter;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.c2a6892 : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: AppColors.c2a6892),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: AppTextStyles.paragraph_14_medium.copyWith(
                    color: isSelected ? Colors.white : AppColors.c2a6892,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Map<DateTime, List<domain.Notification>> _groupNotificationsByDate(
    List<domain.Notification> notifications,
  ) {
    final Map<DateTime, List<domain.Notification>> groupedNotifications = {};
    for (var notification in notifications) {
      final date = DateTime(
        notification.waktu.year,
        notification.waktu.month,
        notification.waktu.day,
      );
      if (!groupedNotifications.containsKey(date)) {
        groupedNotifications[date] = [];
      }
      groupedNotifications[date]!.add(notification);
    }
    return groupedNotifications;
  }

  Widget _buildNotificationCard(domain.Notification notification) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.judul,
              style: AppTextStyles.heading_4_bold.copyWith(
                color: AppColors.c2a6892,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              notification.kategori,
              style: AppTextStyles.paragraph_14_medium.copyWith(
                color: AppColors.c3585ba,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              notification.deskripsi,
              style: AppTextStyles.paragraph_14_regular.copyWith(
                color: AppColors.c3585ba,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('HH:mm').format(notification.waktu),
              style: AppTextStyles.paragraph_14_regular.copyWith(
                color: AppColors.c3585ba,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
