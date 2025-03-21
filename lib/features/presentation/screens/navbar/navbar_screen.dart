import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:tes_gradle/features/presentation/screens/activity/activity_screen.dart';
import 'package:tes_gradle/features/presentation/screens/notification/notification_screen.dart';
import 'package:tes_gradle/features/presentation/screens/profile/profile_screen.dart';
import 'package:tes_gradle/features/presentation/screens/beranda/home_screen.dart';
import 'package:tes_gradle/features/presentation/screens/profile/pop_up_alamat.dart'; // Import PopUpAlamatScreen
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/provider/user_provider.dart'; // Import UserProvider

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  @override
  _NavbarScreenState createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 3) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.userData;

      print('User data in NavbarScreen: $user'); // Debug print statement

      if (user?['address'] == '-') {
        print('Address is "-", showing dialog'); // Debug print statement
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const PopUpAlamatScreen();
            },
          );
        });
      } else {
        print(
          'Address is not "-", not showing dialog',
        ); // Debug print statement
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomeScreen(),
          ActivityScreen(),
          NotificationScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color
              blurRadius: 10, // Blur radius
              offset: Offset(0, -2), // Offset for shadow
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white, // Set background color to white
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.c2a6892,
          unselectedItemColor: Colors.blueGrey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Aktivitas'),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifikasi',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
