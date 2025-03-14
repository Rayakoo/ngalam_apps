import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/screens/beranda/laporek/lapor_saya_screen.dart';
import 'package:tes_gradle/features/presentation/screens/beranda/laporek/lapor_warga_screen.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';

class LaporekBar extends StatefulWidget {
  const LaporekBar({super.key});

  @override
  _LaporekBarState createState() => _LaporekBarState();
}

class _LaporekBarState extends State<LaporekBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cce1f0,
        title: const Text("Laporek"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go(AppRoutes.navbar);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Container(
            color: AppColors.white, // Set the background color to white
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.c2a6892, // Blue bottom border color
              indicatorWeight: 3.0,
              labelColor: AppColors.c2a6892, // Blue text color for selected tab
              unselectedLabelColor:
                  Colors.grey, // Grey text color for unselected tabs
              tabs: const [Tab(text: 'Lapor Saya'), Tab(text: 'Lapor Warga')],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [LaporSayaScreen(), LaporWargaScreen()],
      ),
    );
  }
}
