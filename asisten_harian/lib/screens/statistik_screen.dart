
import 'package:flutter/material.dart';

const Color _blue = Color(0xFF246BFD);
const Color _background = Color(0xFFF3F6FC);
const Color _text = Color(0xFF172B50);

class StatistikScreen extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;

  const StatistikScreen({
    super.key,
    required this.tasks,
  });

  int get _completed =>
      tasks.where((task) => task['done'] == true).length;

  int get _pending => tasks.length - _completed;

  double get _progress =>
      tasks.isEmpty ? 0 : _completed / tasks.length;

  Map<String, int> get _categoryCounts {
    final result = <String, int>{};

    for (final task in tasks) {
      final category =
          (task['category'] ?? 'Lainnya').toString();

      result[category] = (result[category] ?? 0) + 1;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final percent = (_progress * 100).round();

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text(
          'Statistik',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _background,
        foregroundColor: _text,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          _buildOverview(percent),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'Total Tugas',
                  value: '${tasks.length}',
                  subtitle: 'Semua kegiatan',
                  icon: Icons.assignment_rounded,
                  color: _blue,
                  background: const Color(0xFFE5EEFF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Selesai',
                  value: '$_completed',
                  subtitle: 'Tugas selesai',
                  icon: Icons.check_circle_rounded,
                  color: const Color(0xFF12A879),
                  background: const Color(0xFFDDF7EF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSummaryCard(
            title: 'Belum Selesai',
            value: '$_pending',
            subtitle: 'Tugas yang masih perlu dikerjakan',
            icon: Icons.pending_actions_rounded,
            color: const Color(0xFFEF9A25),
            background: const Color(0xFFFFF1D8),
            fullWidth: true,
          ),
          const SizedBox(height: 22),
          _buildSectionCard(
            title: 'Aktivitas berdasarkan Kategori',
            subtitle: 'Jumlah tugas pada setiap kategori',
            child: _buildCategoryStats(),
          ),
          const SizedBox(height: 18),
          _buildSectionCard(
            title: 'Rincian Tugas',
            subtitle: 'Status seluruh kegiatanmu',
            child: _buildTaskList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(int percent) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF17469B),
            Color(0xFF3478F6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _blue.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progres Aktivitas',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$percent%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tasks.isEmpty
                      ? 'Belum ada tugas tercatat.'
                      : '$_completed dari ${tasks.length} tugas selesai.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 88,
            height: 88,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 9,
                    backgroundColor: Colors.white24,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                const Icon(
                  Icons.insights_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color background,
    bool fullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF71809D),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF71809D),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _text,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF71809D),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildCategoryStats() {
    final categories = _categoryCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (categories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Belum ada data kategori.',
            style: TextStyle(color: Color(0xFF71809D)),
          ),
        ),
      );
    }

    final maxCount = categories.first.value;

    return Column(
      children: categories.map((entry) {
        final ratio = entry.value / maxCount;

        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${entry.value} tugas',
                    style: const TextStyle(
                      color: Color(0xFF71809D),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE8EEF9),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(_blue),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTaskList() {
    if (tasks.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Belum ada tugas untuk ditampilkan.',
            style: TextStyle(color: Color(0xFF71809D)),
          ),
        ),
      );
    }

    return Column(
      children: tasks.map((task) {
        final done = task['done'] == true;
        final title = (task['title'] ?? 'Tanpa judul').toString();
        final category =
            (task['category'] ?? 'Lainnya').toString();
        final time = (task['time'] ?? '--.--').toString();

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFBFE),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFFE8EDF7),
            ),
          ),
          child: Row(
            children: [
              Icon(
                done
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: done
                    ? const Color(0xFF12A879)
                    : const Color(0xFF9AA8BF),
                size: 25,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: _text,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        decoration: done
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$time • $category',
                      style: const TextStyle(
                        color: Color(0xFF71809D),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                done ? 'Selesai' : 'Pending',
                style: TextStyle(
                  color: done
                      ? const Color(0xFF12A879)
                      : const Color(0xFFEF9A25),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: const Color(0xFFE8EDF7),
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF254A80).withValues(alpha: 0.04),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
