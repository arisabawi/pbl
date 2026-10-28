import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'jadwal_tugas_screen.dart';
import 'catatan_screen.dart';
import 'target_screen.dart';
import 'keuangan_screen.dart';
import 'statistik_screen.dart';

const Color primaryBlue = Color(0xFF246BFD);
const Color backgroundColor = Color(0xFFF3F6FC);
const Color textColor = Color(0xFF172B50);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Mengerjakan tugas kuliah',
      'time': '09.00',
      'category': 'Kuliah',
      'done': false,
    },
    {
      'title': 'Membaca materi pemrograman',
      'time': '13.00',
      'category': 'Belajar',
      'done': false,
    },
    {
      'title': 'Merapikan catatan',
      'time': '16.00',
      'category': 'Pribadi',
      'done': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredTasks {
    final query = _searchController.text.toLowerCase();
    return _tasks.where((task) {
      return task['title'].toString().toLowerCase().contains(query);
    }).toList();
  }

  int get _completedTasks =>
      _tasks.where((task) => task['done'] == true).length;

  double get _progress =>
      _tasks.isEmpty ? 0 : _completedTasks / _tasks.length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final timeController = TextEditingController(text: '08.00');

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tambah Kegiatan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Nama kegiatan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Waktu',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isEmpty) return;

              setState(() {
                _tasks.add({
                  'title': title,
                  'time': timeController.text.trim().isEmpty
                      ? '--.--'
                      : timeController.text.trim(),
                  'category': 'Pribadi',
                  'done': false,
                });
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    ).then((_) {
      titleController.dispose();
      timeController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: _selectedIndex == 4
          ? const ProfileScreen()
          : SafeArea(
              bottom: false,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader()),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: _buildProgressCard(),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: _buildMenuCard(),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                    sliver: SliverToBoxAdapter(
                      child: _buildAgendaCard(),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // HEADER GAMBAR, SAPAAN, DAN PENCARIAN
  Widget _buildHeader() {
    return SizedBox(
      width: double.infinity,
      height: 190,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1600&q=90',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF17469B),
                        Color(0xFF3478F6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.42),
                    Colors.black.withValues(alpha: 0.04),
                    Colors.black.withValues(alpha: 0.24),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat datang! 👋',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Atur harimu agar lebih terarah.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showMessage(
                            'Belum ada notifikasi baru.',
                          ),
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 29,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 16,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Cari tugas atau catatan...',
                          hintStyle: const TextStyle(
                            color: Color(0xFF8290AA),
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: primaryBlue,
                            size: 27,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => _showMessage(
                              'Fitur input suara akan ditambahkan.',
                            ),
                            icon: const Icon(
                              Icons.mic_none_rounded,
                              color: primaryBlue,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 17,
                          ),
                        ),
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

  // KARTU PROGRES HARIAN
  Widget _buildProgressCard() {
    final percent = (_progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EEFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: primaryBlue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progres Harian',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Pantau kegiatanmu hari ini',
                      style: TextStyle(
                        color: Color(0xFF71809D),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$percent%',
                style: const TextStyle(
                  color: primaryBlue,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 9,
              backgroundColor: const Color(0xFFE8EEF9),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(primaryBlue),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$_completedTasks dari ${_tasks.length} tugas selesai',
            style: const TextStyle(
              color: Color(0xFF71809D),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Terus semangat menyelesaikan kegiatanmu!',
            style: TextStyle(
              color: Color(0xFF536585),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // MENU PINTASAN
  Widget _buildMenuCard() {
    final menus = [
      (
        'Jadwal tugas',
        Icons.calendar_month_rounded,
        Color(0xFF12A879),
        Color(0xFFDDF7EF),
      ),
      (
        'Catatan',
        Icons.edit_note_rounded,
        Color(0xFFF39A19),
        Color(0xFFFFF1D8),
      ),
      (
        'Target',
        Icons.track_changes_rounded,
        Color(0xFF8754E8),
        Color(0xFFF0E7FF),
      ),
      (
        'Keuangan',
        Icons.account_balance_wallet_outlined,
        Color(0xFF10A6A0),
        Color(0xFFDDF8F5),
      ),
      (
        'Pengingat',
        Icons.alarm_rounded,
        Color(0xFFEF625B),
        Color(0xFFFFE7E5),
      ),
      (
        'Statistik',
        Icons.insert_chart_rounded,
        Color(0xFF246BFD),
        Color(0xFFE5EEFF),
      ),
      (
        'Daftar menu',
        Icons.grid_view_rounded,
        Color(0xFF64748B),
        Color(0xFFEDF1F7),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Menu Pintasan',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _showMessage(
                  'Daftar menu akan dikembangkan selanjutnya.',
                ),
                child: const Text('Lihat semua'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: menus.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 8,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final menu = menus[index];

              return InkWell(
                borderRadius: BorderRadius.circular(16),
          

onTap: () {
  if (menu.$1 == 'Catatan') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CatatanScreen(),
      ),
    );
  } else if (menu.$1 == 'Target') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TargetScreen(),
      ),
    );
  } else if (menu.$1 == 'Keuangan') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const KeuanganScreen(),
      ),
    );
  } else if (menu.$1 == 'Jadwal tugas') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JadwalTugasScreen(
          tasks: _tasks,
          onTasksChanged: () {
            setState(() {});
          },
        ),
      ),
    );
  }
  else if (menu.$1 == 'Statistik') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => StatistikScreen(
        tasks: _tasks,
      ),
    ),
  );
}
},

                child: Column(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: menu.$4,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        menu.$2,
                        color: menu.$3,
                        size: 29,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      menu.$1,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // AGENDA HARI INI DAN TIPS
  Widget _buildAgendaCard() {
    final tasks = _filteredTasks;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'jadwal hari ini',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Tidak ada jadwal hari ini.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...tasks.map((task) {
              final done = task['done'] as bool;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFBFE),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE4EAF5),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: done
                            ? const Color(0xFFF0E7FF)
                            : const Color(0xFFE5EEFF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        done
                            ? Icons.check_circle_outline_rounded
                            : Icons.description_outlined,
                        color: done
                            ? const Color(0xFF8754E8)
                            : primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['title'].toString(),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              decoration: done
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${task['time']} • ${task['category']}',
                            style: const TextStyle(
                              color: Color(0xFF7A89A5),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: done,
                      activeColor: primaryBlue,
                      onChanged: (value) {
                        setState(() {
                          task['done'] = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFF2ECFF),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Color(0xFF8754E8),
                  size: 29,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tips hari ini',
                        style: TextStyle(
                          color: Color(0xFF7540D8),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Selesaikan tugas terpenting terlebih dahulu '
                        'agar harimu lebih teratur.',
                        style: TextStyle(
                          color: Color(0xFF536585),
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: const Color(0xFFE8EDF7),
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF254A80).withValues(alpha: 0.05),
          blurRadius: 16,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  // NAVIGASI BAWAH
  Widget _buildBottomNavigation() {
    const items = [
      (Icons.home_rounded, 'Beranda'),
      (Icons.grid_view_rounded, 'Daftar menu'),
      (Icons.auto_awesome_rounded, 'Asisten'),
      (Icons.favorite_border_rounded, 'Favorit'),
      (Icons.person_outline_rounded, 'Profil'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: NavigationBar(
          height: 66,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedIndex: _selectedIndex,
          labelBehavior:
              NavigationDestinationLabelBehavior.alwaysShow,
          indicatorColor: const Color(0xFFE5EEFF),
          onDestinationSelected: (index) {
            if (index == 0 || index == 4) {
              setState(() {
                _selectedIndex = index;
              });
            } else {
              _showMessage(
                '${items[index].$2} akan dikembangkan nanti.',
              );
            }
          },
          destinations: items.map((item) {
            return NavigationDestination(
              icon: Icon(item.$1),
              label: item.$2,
            );
          }).toList(),
        ),
      ),
    );
  }
}