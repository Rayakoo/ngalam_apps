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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/top bar.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            'Notifikasi',
            style: AppTextStyles.heading_3_medium.copyWith(
              color: AppColors.c020608,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      body:
          notificationProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  SizedBox(height: 30),
                  _buildDateFilter(),
                  Expanded(
                    child: Consumer<NotificationProvider>(
                      builder: (context, notificationProvider, child) {
                        final notifications = _filterNotifications(
                          notificationProvider.notificationList ?? [],
                        );
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
      height: 40,
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

  List<domain.Notification> _filterNotifications(
    List<domain.Notification> notifications,
  ) {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'Hari ini':
        return notifications.where((notification) {
          return notification.waktu.year == now.year &&
              notification.waktu.month == now.month &&
              notification.waktu.day == now.day;
        }).toList();
      case '7 Hari terakhir':
        return notifications.where((notification) {
          return now.difference(notification.waktu).inDays < 7;
        }).toList();
      case '1 Bulan terakhir':
        return notifications.where((notification) {
          return now.difference(notification.waktu).inDays < 30;
        }).toList();
      default:
        return notifications;
    }
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
    String getImageForCategory(String category) {
      switch (category) {
        case 'Berita':
          return 'assets/images/berita.png';
        case 'Pemberitahuan':
          return 'assets/images/pengumuman.png';
        case 'Komentar':
          return 'assets/images/profile_default.jpg';
        default:
          return 'assets/images/pengumuman.png';
      }
    }

    return Card(
      color: Colors.white, // Set card color to white
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: AppColors.c7db4d9,
              child: Image.asset(getImageForCategory(notification.kategori)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.cce1f0,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.judul,
                      style: AppTextStyles.heading_4_medium.copyWith(
                        color: AppColors.c020608,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.deskripsi,
                      style: AppTextStyles.paragraph_14_regular.copyWith(
                        color: AppColors.c020608,
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
            ),
          ],
        ),
      ),
    );
  }
}
