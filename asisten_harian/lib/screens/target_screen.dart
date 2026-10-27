
import 'package:flutter/material.dart';

class TargetScreen extends StatefulWidget {
  const TargetScreen({super.key});

  @override
  State<TargetScreen> createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen> {
  final List<Map<String, dynamic>> _targets = [];

  final Color _primary = const Color(0xFF2878C8);
  final Color _background = const Color(0xFFF3F7FC);

  void _tambahTarget() {
    final judulController = TextEditingController();
    final deskripsiController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Tambah Target'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: judulController,
                  decoration: const InputDecoration(
                    labelText: 'Nama target',
                    hintText: 'Contoh: Belajar Flutter',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deskripsiController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    hintText: 'Tuliskan target yang ingin dicapai',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final judul = judulController.text.trim();

                if (judul.isEmpty) return;

                setState(() {
                  _targets.add({
                    'judul': judul,
                    'deskripsi': deskripsiController.text.trim(),
                    'selesai': false,
                  });
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    ).then((_) {
      judulController.dispose();
      deskripsiController.dispose();
    });
  }

  void _hapusTarget(int index) {
    setState(() {
      _targets.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final jumlahSelesai =
        _targets.where((target) => target['selesai'] == true).length;

    final progres = _targets.isEmpty
        ? 0.0
        : jumlahSelesai / _targets.length;

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text(
          'Target Saya',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahTarget,
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Target'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: _primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Langkah kecil, hasil besar!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$jumlahSelesai dari ${_targets.length} target selesai',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progres,
                      minHeight: 10,
                      backgroundColor: Colors.white30,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFFD166),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(progres * 100).round()}% tercapai',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _targets.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.flag_outlined,
                              size: 76,
                              color: _primary.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Belum ada target',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tambahkan target pertamamu dan mulai '
                              'langkah untuk mencapainya.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 90),
                      itemCount: _targets.length,
                      itemBuilder: (context, index) {
                        final target = _targets[index];
                        final selesai = target['selesai'] == true;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: selesai,
                                  activeColor: _primary,
                                  onChanged: (value) {
                                    setState(() {
                                      target['selesai'] = value ?? false;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        target['judul'] as String,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          decoration: selesai
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          color: selesai
                                              ? Colors.grey
                                              : Colors.black87,
                                        ),
                                      ),
                                      if ((target['deskripsi'] as String)
                                          .isNotEmpty) ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          target['deskripsi'] as String,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 8),
                                      Text(
                                        selesai ? 'Target tercapai' : 'Sedang berjalan',
                                        style: TextStyle(
                                          color: selesai
                                              ? Colors.green
                                              : _primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Hapus target',
                                  onPressed: () => _hapusTarget(index),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
