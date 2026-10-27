
import 'package:flutter/material.dart';

class CatatanScreen extends StatefulWidget {
  const CatatanScreen({super.key});

  @override
  State<CatatanScreen> createState() => _CatatanScreenState();
}

class _CatatanScreenState extends State<CatatanScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _catatan = [];

  final Color _biru = const Color(0xFF2563EB);
  final Color _ungu = const Color(0xFF7C3AED);

  List<Map<String, dynamic>> get _catatanTerfilter {
    final kata = _searchController.text.trim().toLowerCase();

    if (kata.isEmpty) return _catatan;

    return _catatan.where((catatan) {
      final judul = (catatan['judul'] as String).toLowerCase();
      final isi = (catatan['isi'] as String).toLowerCase();

      return judul.contains(kata) || isi.contains(kata);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _bukaForm({Map<String, dynamic>? catatan}) {
    final judulController = TextEditingController(
      text: catatan?['judul'] ?? '',
    );
    final isiController = TextEditingController(
      text: catatan?['isi'] ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            catatan == null ? 'Catatan Baru' : 'Edit Catatan',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: judulController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Judul catatan',
                    hintText: 'Contoh: Ide tugas kuliah',
                    prefixIcon: const Icon(Icons.title_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: isiController,
                  maxLines: 5,
                  minLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Isi catatan',
                    hintText: 'Tuliskan catatan kamu di sini...',
                    alignLabelWithHint: true,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 70),
                      child: Icon(Icons.notes_rounded),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _biru,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final judul = judulController.text.trim();
                final isi = isiController.text.trim();

                if (judul.isEmpty || isi.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Judul dan isi catatan harus diisi.'),
                    ),
                  );
                  return;
                }

                setState(() {
                  if (catatan == null) {
                    _catatan.insert(0, {
                      'judul': judul,
                      'isi': isi,
                      'tanggal': DateTime.now(),
                    });
                  } else {
                    catatan['judul'] = judul;
                    catatan['isi'] = isi;
                    catatan['tanggal'] = DateTime.now();
                  }
                });

                Navigator.pop(dialogContext);
              },
              icon: const Icon(Icons.save_rounded),
              label: const Text('Simpan'),
            ),
          ],
        );
      },
    ).then((_) {
      judulController.dispose();
      isiController.dispose();
    });
  }

  void _hapusCatatan(Map<String, dynamic> catatan) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Hapus catatan?'),
        content: Text(
          'Catatan "${catatan['judul']}" akan dihapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              setState(() => _catatan.remove(catatan));
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Catatan berhasil dihapus.'),
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  String _formatTanggal(DateTime tanggal) {
    const namaBulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];

    return '${tanggal.day} ${namaBulan[tanggal.month - 1]} ${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    final daftar = _catatanTerfilter;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172554),
        title: const Text(
          'Catatan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Tambah catatan',
            onPressed: () => _bukaForm(),
            icon: Icon(Icons.add_circle_rounded, color: _biru, size: 30),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bukaForm(),
        backgroundColor: _biru,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.note_add_rounded),
        label: const Text('Catatan Baru'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_biru, _ungu],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: _biru.withValues(alpha: 0.20),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Simpan Ide Terbaikmu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${_catatan.length} catatan tersimpan di halaman ini',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Cari judul atau isi catatan...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFE5EAF4),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: daftar.isEmpty
                  ? _tampilanKosong()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: daftar.length,
                      itemBuilder: (context, index) {
                        final catatan = daftar[index];
                        final tanggal = catatan['tanggal'] as DateTime;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFE9EDF5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.025),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => _lihatCatatan(catatan),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: index.isEven
                                          ? const Color(0xFFE8EEFF)
                                          : const Color(0xFFF0E8FF),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      Icons.sticky_note_2_rounded,
                                      color: index.isEven ? _biru : _ungu,
                                    ),
                                  ),
                                  const SizedBox(width: 13),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          catatan['judul'] as String,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Color(0xFF172554),
                                          ),
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          catatan['isi'] as String,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            height: 1.45,
                                            color: Color(0xFF64748B),
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.schedule_rounded,
                                              size: 14,
                                              color: Colors.blueGrey.shade300,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              _formatTanggal(tanggal),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.blueGrey.shade400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    tooltip: 'Pilihan catatan',
                                    onSelected: (pilihan) {
                                      if (pilihan == 'edit') {
                                        _bukaForm(catatan: catatan);
                                      } else if (pilihan == 'hapus') {
                                        _hapusCatatan(catatan);
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit_rounded, size: 19),
                                            SizedBox(width: 10),
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'hapus',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete_outline_rounded,
                                              color: Colors.red,
                                              size: 19,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Hapus',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    icon: const Icon(
                                      Icons.more_vert_rounded,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
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

  Widget _tampilanKosong() {
    final sedangMencari = _searchController.text.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFE8EEFF),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                sedangMencari
                    ? Icons.search_off_rounded
                    : Icons.note_alt_outlined,
                size: 48,
                color: _biru,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              sedangMencari ? 'Catatan tidak ditemukan' : 'Belum ada catatan',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172554),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              sedangMencari
                  ? 'Coba gunakan kata kunci yang lain.'
                  : 'Mulai tulis ide, hal penting, atau catatan kuliahmu.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
            if (!sedangMencari) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => _bukaForm(),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Buat Catatan'),
                style: FilledButton.styleFrom(
                  backgroundColor: _biru,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _lihatCatatan(Map<String, dynamic> catatan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  catatan['judul'] as String,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172554),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _formatTanggal(catatan['tanggal'] as DateTime),
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 18),
                SingleChildScrollView(
                  child: Text(
                    catatan['isi'] as String,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          _bukaForm(catatan: catatan);
                        },
                        icon: const Icon(Icons.edit_rounded),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          _hapusCatatan(catatan);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: const Text('Hapus'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
