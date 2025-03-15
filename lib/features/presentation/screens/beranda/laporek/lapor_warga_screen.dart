import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/presentation/provider/lapor_provider.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';
import 'package:tes_gradle/features/presentation/style/typography.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; 
import 'package:tes_gradle/features/presentation/screens/beranda/laporek/detail_laporan_screen.dart'; 

class LaporWargaScreen extends StatefulWidget {
  const LaporWargaScreen({super.key});

  @override
  _LaporWargaScreenState createState() => _LaporWargaScreenState();
}

class _LaporWargaScreenState extends State<LaporWargaScreen> {
  int _currentPage = 0;
  static const int _pageSize = 10;
  final TextEditingController _searchController = TextEditingController();
  final Map<String, bool> _selectedFilters = {
    'Terbaru': false,
    'Terlama': false,
    'Layanan Sosial': false,
    'Pelayanan Umum': false,
    'Keamanan & Ketertiban': false,
    'Infrastruktur': false,
    'Menunggu': false,
    'Sedang Diproses': false,
    'Selesai': false,
    'Blimbing': false,
    'Kedungkandang': false,
    'Klojen': false,
    'Lowokwaru': false,
    'Sukun': false,
  };

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchLaporan();
      });
    });
  }

  Future<void> _fetchLaporan() async {
    try {
      print('Fetching all laporan...');
      await Provider.of<LaporProvider>(
        context,
        listen: false,
      ).fetchAllLaporan();
      print('Fetched all laporan successfully.');
      _applyFilters();
    } catch (e) {
      print('Error fetching laporan: $e');
    }
  }

  void _applyFilters() {
    final laporProvider = Provider.of<LaporProvider>(context, listen: false);
    List<Laporan> filteredLaporan = laporProvider.laporanList ?? [];

    if (_selectedFilters['Terbaru'] == true) {
      filteredLaporan.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
    } else if (_selectedFilters['Terlama'] == true) {
      filteredLaporan.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
    }

    final categories = [
      'Layanan Sosial',
      'Pelayanan Umum',
      'Keamanan & Ketertiban',
      'Infrastruktur',
    ];
    final statuses = ['Menunggu', 'Sedang Diproses', 'Selesai'];

    List<Laporan> categoryFilteredLaporan = [];
    List<Laporan> statusFilteredLaporan = [];

    for (var category in categories) {
      if (_selectedFilters[category] == true) {
        print('Filtering by category: $category');
        categoryFilteredLaporan.addAll(
          filteredLaporan.where(
            (laporan) => laporan.kategoriLaporan == category,
          ),
        );
      }
    }

    for (var status in statuses) {
      if (_selectedFilters[status] == true) {
        print('Filtering by status: $status');
        print('Filtered laporan before status filter: $filteredLaporan');
        statusFilteredLaporan.addAll(
          filteredLaporan.where((laporan) {
            print('Checking laporan status: ${laporan.status}');
            print('Checking laporan status: $status');
            return laporan.status == status;
          }),
        );
        print('Filtered laporan after status filter: $statusFilteredLaporan');
      }
    }

    if (categoryFilteredLaporan.isNotEmpty) {
      print(
        'Category filtered laporan count: ${categoryFilteredLaporan.length}',
      );
      filteredLaporan = categoryFilteredLaporan;
    }

    if (statusFilteredLaporan.isNotEmpty) {
      print('Status filtered laporan count: ${statusFilteredLaporan.length}');
      print('Status filtered laporan: $statusFilteredLaporan');
      filteredLaporan =
          filteredLaporan
              .where((laporan) => statusFilteredLaporan.contains(laporan))
              .toList();
      print('Filtered laporan after status filter: $filteredLaporan');
    }

    print('Final filtered laporan count: ${filteredLaporan.length}');
    setState(() {
      laporProvider.filteredLaporanList = filteredLaporan;
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedFilters.updateAll((key, value) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Consumer<LaporProvider>(
              builder: (context, laporProvider, child) {
                if (laporProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                final laporanList = laporProvider.filteredLaporanList ?? [];
                final totalPages = (laporanList.length / _pageSize).ceil();
                final currentPageLaporan =
                    laporanList
                        .skip(_currentPage * _pageSize)
                        .take(_pageSize)
                        .toList();

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: currentPageLaporan.length,
                        itemBuilder: (context, index) {
                          final laporan = currentPageLaporan[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          DetailLaporanScreen(laporan: laporan),
                                ),
                              );
                            },
                            child: _buildLaporanCard(laporan),
                          );
                        },
                      ),
                    ),
                    _buildPaginationControls(totalPages),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppColors.c2a6892),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.c2a6892),
            ),
            child: IconButton(
              icon: Icon(Icons.filter_list, color: AppColors.c2a6892),
              onPressed: () {
                _showFilterModal(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close, color: AppColors.c2a6892),
                  ),
                  Text(
                    'Filter',
                    style: AppTextStyles.heading_3_bold.copyWith(
                      color: AppColors.c2a6892,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Urutkan', style: AppTextStyles.heading_4_bold),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: [
                          _buildFilterChip('Terbaru'),
                          _buildFilterChip('Terlama'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('Kategori', style: AppTextStyles.heading_4_bold),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: [
                          _buildFilterChip('Layanan Sosial'),
                          _buildFilterChip('Pelayanan Umum'),
                          _buildFilterChip('Keamanan & Ketertiban'),
                          _buildFilterChip('Infrastruktur'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('Status', style: AppTextStyles.heading_4_bold),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: [
                          _buildFilterChip('Menunggu'),
                          _buildFilterChip('Sedang Diproses'),
                          _buildFilterChip('Selesai'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('Lokasi', style: AppTextStyles.heading_4_bold),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: [
                          _buildFilterChip('Blimbing'),
                          _buildFilterChip('Kedungkandang'),
                          _buildFilterChip('Klojen'),
                          _buildFilterChip('Lowokwaru'),
                          _buildFilterChip('Sukun'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            onPressed: _resetFilters,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.c2a6892),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: AppColors.cce1f0,
                            ),
                            child: Text(
                              'Reset Filter',
                              style: AppTextStyles.paragraph_14_medium.copyWith(
                                color: AppColors.c2a6892,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _applyFilters();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.c2a6892,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Terapkan Filter',
                              style: AppTextStyles.paragraph_14_medium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(String label) {
    final bool isSelected = _selectedFilters[label] ?? false;

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : AppColors.c2a6892),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (label == 'Terbaru' && selected) {
            _selectedFilters['Terlama'] = false;
          } else if (label == 'Terlama' && selected) {
            _selectedFilters['Terbaru'] = false;
          }
          _selectedFilters[label] = selected;
        });
      },
      selectedColor: AppColors.c2a6892,
      backgroundColor: Colors.white,
      shape: StadiumBorder(side: BorderSide(color: AppColors.c2a6892)),
    );
  }

  Widget _buildLaporanCard(Laporan laporan) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  laporan.kategoriLaporan,
                  style: AppTextStyles.paragraph_14_medium.copyWith(
                    color: AppColors.c2a6892,
                  ),
                ),
                _buildStatusChip(laporan.status),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    laporan.judulLaporan,
                    style: AppTextStyles.heading_3_bold.copyWith(
                      color: AppColors.c2a6892,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Image.network(
                  laporan.foto,
                  height: 100,
                  width: 130,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Failed to load image');
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              laporan.lokasiKejadian,
              style: AppTextStyles.paragraph_14_regular.copyWith(
                color: AppColors.c3585ba,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(laporan.timeStamp),
                  style: AppTextStyles.paragraph_14_regular.copyWith(
                    color: AppColors.c3585ba,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.favorite_border, color: Colors.grey),
                    const SizedBox(width: 8),
                    Icon(Icons.comment, color: Colors.grey),
                    const SizedBox(width: 8),
                    Icon(Icons.share, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('d MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  Widget _buildStatusChip(String status) {
    Color textColor;
    Color borderColor;
    switch (status) {
      case 'Menunggu':
        textColor = Colors.blue;
        borderColor = Colors.blue;
        break;
      case 'Sedang Diproses':
        textColor = Colors.orange;
        borderColor = Colors.orange;
        break;
      case 'Selesai':
        textColor = Colors.green;
        borderColor = Colors.green;
        break;
      default:
        textColor = Colors.grey;
        borderColor = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: AppTextStyles.paragraph_14_regular.copyWith(color: textColor),
      ),
      backgroundColor: Colors.transparent,
      shape: StadiumBorder(side: BorderSide(color: borderColor)),
    );
  }

  Widget _buildPaginationControls(int totalPages) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed:
                _currentPage > 0
                    ? () {
                      setState(() {
                        _currentPage--;
                      });
                    }
                    : null,
            child: Text('Previous'),
          ),
          Text('Page ${_currentPage + 1} of $totalPages'),
          ElevatedButton(
            onPressed:
                _currentPage < totalPages - 1
                    ? () {
                      setState(() {
                        _currentPage++;
                      });
                    }
                    : null,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}
