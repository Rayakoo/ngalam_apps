import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/presentation/screens/beranda/laporek/lapor_saya_screen.dart';
import 'package:tes_gradle/features/presentation/screens/beranda/laporek/lapor_warga_screen.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:tes_gradle/features/presentation/provider/lapor_provider.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LaporProvider>(context, listen: false).fetchAllLaporan();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            'Laporek',
            style: AppTextStyles.heading_3_medium.copyWith(
              color: AppColors.c020608,
            ),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go(AppRoutes.navbar);
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.c2a6892,
              indicatorWeight: 3.0,
              labelColor: AppColors.c2a6892,
              unselectedLabelColor: Colors.grey,
              tabs: const [Tab(text: 'Lapor Saya'), Tab(text: 'Lapor Warga')],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [LaporSayaScreen(), LaporWargaScreen()],
            ),
          ),
        ],
      ),
    );
  }
}
