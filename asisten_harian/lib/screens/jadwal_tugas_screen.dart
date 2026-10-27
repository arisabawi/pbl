
import 'package:flutter/material.dart';

const Color _blue = Color(0xFF246BFD);
const Color _background = Color(0xFFF3F6FC);
const Color _text = Color(0xFF172B50);

class JadwalTugasScreen extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;
  final VoidCallback onTasksChanged;

  const JadwalTugasScreen({
    super.key,
    required this.tasks,
    required this.onTasksChanged,
  });

  @override
  State<JadwalTugasScreen> createState() =>
      _JadwalTugasScreenState();
}

class _JadwalTugasScreenState extends State<JadwalTugasScreen> {
  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime _taskDate(Map<String, dynamic> task) {
    final value = task['date'];

    if (value is DateTime) {
      return DateTime(value.year, value.month, value.day);
    }

    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return DateTime(parsed.year, parsed.month, parsed.day);
      }
    }

    return _today();
  }

  String _dateLabel(DateTime date) {
    const days = [
      'Senin', 'Selasa', 'Rabu', 'Kamis',
      'Jumat', 'Sabtu', 'Minggu',
    ];

    const months = [
      'Januari', 'Februari', 'Maret', 'April',
      'Mei', 'Juni', 'Juli', 'Agustus',
      'September', 'Oktober', 'November', 'Desember',
    ];

    return '${days[date.weekday - 1]}, '
        '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  List<Map<String, dynamic>> _tasksOn(DateTime date) {
    final result = widget.tasks
        .where((task) => _taskDate(task) == date)
        .toList();

    result.sort(
      (a, b) => (a['time'] ?? '23.59')
          .toString()
          .compareTo((b['time'] ?? '23.59').toString()),
    );

    return result;
  }

  List<Map<String, dynamic>> get _todayTasks =>
      _tasksOn(_today());

  List<Map<String, dynamic>> get _upcomingTasks {
    final today = _today();
    final result = widget.tasks.where((task) {
      return _taskDate(task).isAfter(today);
    }).toList();

    result.sort((a, b) {
      final dateCompare =
          _taskDate(a).compareTo(_taskDate(b));

      if (dateCompare != 0) return dateCompare;

      return (a['time'] ?? '23.59')
          .toString()
          .compareTo((b['time'] ?? '23.59').toString());
    });

    return result;
  }

  List<Map<String, dynamic>> get _pastTasks {
  final today = _today();

  final result = widget.tasks.where((task) {
    return _taskDate(task).isBefore(today) &&
        task['done'] != true;
  }).toList();

  result.sort((a, b) {
    return _taskDate(b).compareTo(_taskDate(a));
  });

  return result;
}

  Future<void> _addTask() async {
    final titleController = TextEditingController();
    final timeController =
        TextEditingController(text: '08.00');

    DateTime date = _today();
    String category = 'Kuliah';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Tambah Jadwal Tugas'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Nama tugas / kegiatan',
                      prefixIcon: Icon(Icons.edit_note_rounded),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: timeController,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      labelText: 'Waktu (contoh 08.00)',
                      prefixIcon: Icon(Icons.schedule_rounded),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.calendar_month_rounded,
                      color: _blue,
                    ),
                    title: const Text('Tanggal tugas'),
                    subtitle: Text(_dateLabel(date)),
                    trailing: const Icon(Icons.edit_calendar_rounded),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: dialogContext,
                        initialDate: date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );

                      if (picked != null) {
                        setDialogState(() {
                          date = DateTime(
                            picked.year,
                            picked.month,
                            picked.day,
                          );
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Kuliah',
                        child: Text('Kuliah'),
                      ),
                      DropdownMenuItem(
                        value: 'Belajar',
                        child: Text('Belajar'),
                      ),
                      DropdownMenuItem(
                        value: 'Pekerjaan',
                        child: Text('Pekerjaan'),
                      ),
                      DropdownMenuItem(
                        value: 'Pribadi',
                        child: Text('Pribadi'),
                      ),
                      DropdownMenuItem(
                        value: 'Lainnya',
                        child: Text('Lainnya'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          category = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Batal'),
              ),
              FilledButton.icon(
                onPressed: () {
                  final title = titleController.text.trim();
                  if (title.isEmpty) return;

                  final time = timeController.text.trim();

                  widget.tasks.add({
                    'title': title,
                    'time': time.isEmpty ? '08.00' : time,
                    'category': category,
                    'done': false,
                    'date': date,
                  });

                  widget.onTasksChanged();
                  setState(() {});

                  Navigator.pop(dialogContext);
                },
                icon: const Icon(Icons.save_rounded),
                label: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );

    titleController.dispose();
    timeController.dispose();
  }

  Future<void> _deleteTask(
    Map<String, dynamic> task,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus tugas?'),
        content: Text('Tugas "${task['title']}" akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        widget.tasks.remove(task);
      });
      widget.onTasksChanged();
    }
  }

  Widget _sectionTitle(
    String title,
    int count,
    IconData icon, {
    Color color = _blue,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 10,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: _text,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count tugas',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskCard(Map<String, dynamic> task) {
    final done = task['done'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        leading: Checkbox(
          value: done,
          activeColor: _blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onChanged: (value) {
              if (value == true) {
               setState(() {
                task['done'] = true;
             });
            widget.onTasksChanged();

            Future.delayed(const Duration(milliseconds: 500),(){
              if (!mounted) return;

              setState(() {
                widget.tasks.remove(task);
              });
              widget.onTasksChanged();
            });
           }
          },
        ),
        title: Text(
          (task['title'] ?? 'Tanpa judul').toString(),
          style: TextStyle(
            color: _text,
            fontWeight: FontWeight.w600,
            decoration:
                done ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Wrap(
            spacing: 8,
            runSpacing: 5,
            children: [
              _chip(
                Icons.schedule_rounded,
                (task['time'] ?? '--.--').toString(),
              ),
              _chip(
                Icons.category_outlined,
                (task['category'] ?? 'Pribadi').toString(),
              ),
              _chip(
                done
                    ? Icons.check_circle_outline
                    : Icons.circle_outlined,
                done ? 'Selesai' : 'Belum selesai',
              ),
            ],
          ),
        ),
        trailing: IconButton(
          tooltip: 'Hapus tugas',
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Color(0xFFEF625B),
          ),
          onPressed: () => _deleteTask(task),
        ),
      ),
    );
  }

  Widget _emptyMessage(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.event_available_rounded,
            color: _blue,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF71809D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: _blue),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF536585),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todayTasks = _todayTasks;
    final upcomingTasks = _upcomingTasks;
    final pastTasks = _pastTasks;

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text(
          'Jadwal Tugas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        backgroundColor: _blue,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        backgroundColor: _blue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Tugas'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            decoration: const BoxDecoration(
              color: _blue,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ringkasan jadwal kamu',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _dateLabel(_today()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _summary(
                        '${todayTasks.length}',
                        'Hari Ini',
                        Icons.today_rounded,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _summary(
                        '${upcomingTasks.length}',
                        'Mendatang',
                        Icons.upcoming_rounded,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _summary(
                        '${pastTasks.length}',
                        'terlewat',
                        Icons.history_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              children: [
                _sectionTitle(
                  'Hari Ini',
                  todayTasks.length,
                  Icons.today_rounded,
                ),
                if (todayTasks.isEmpty)
                  _emptyMessage('Belum ada tugas untuk hari ini.')
                else
                  ...todayTasks.map(_taskCard),

                _sectionTitle(
                  'Tugas Mendatang',
                  upcomingTasks.length,
                  Icons.upcoming_rounded,
                ),
                if (upcomingTasks.isEmpty)
                  _emptyMessage('Belum ada tugas untuk hari mendatang.')
                else
                  ..._buildGroupedTasks(upcomingTasks),

                _sectionTitle(
                  'Tugas Terlewat',
                  pastTasks.length,
                  Icons.event_busy_rounded,
                  color: const Color(0xFF71809D),
                ),
                if (pastTasks.isEmpty)
                  _emptyMessage('Tidak ada tugas yang terlewat.')
                else
                  ..._buildGroupedTasks(pastTasks),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedTasks(
    List<Map<String, dynamic>> tasks,
  ) {
    final grouped = <DateTime, List<Map<String, dynamic>>>{};

    for (final task in tasks) {
      final date = _taskDate(task);
      grouped.putIfAbsent(date, () => []).add(task);
    }

    final widgets = <Widget>[];

    for (final entry in grouped.entries) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 8,
          ),
          child: Text(
            _dateLabel(entry.key),
            style: const TextStyle(
              color: Color(0xFF536585),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );

      widgets.addAll(entry.value.map(_taskCard));
    }

    return widgets;
  }

  Widget _summary(
    String value,
    String label,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 11,
        horizontal: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 19),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
