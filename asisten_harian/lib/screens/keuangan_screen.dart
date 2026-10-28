import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KeuanganScreen extends StatefulWidget {
  const KeuanganScreen({super.key});

  @override
  State<KeuanganScreen> createState() => _KeuanganScreenState();
}

class _Transaksi {
  String judul;
  String kategori;
  double jumlah;
  DateTime tanggal;
  bool pemasukan;
  int? indeksTabungan;

  _Transaksi({
    required this.judul,
    required this.kategori,
    required this.jumlah,
    required this.tanggal,
    required this.pemasukan,
    this.indeksTabungan,
  });
}

class _TargetTabungan {
  String nama;
  double target;
  double terkumpul;

  _TargetTabungan({
    required this.nama,
    required this.target,
    this.terkumpul = 0,
  });
}

class _KeuanganScreenState extends State<KeuanganScreen> {
  static const Color navy = Color(0xFF102A56);
  static const Color biru = Color(0xFF246BFD);
  static const Color hijau = Color(0xFF18B786);
  static const Color merah = Color(0xFFE85D75);
  static const Color latar = Color(0xFFF4F7FC);
  static const Color teks = Color(0xFF24334D);
  static const Color abu = Color(0xFF7D8BA3);

  final NumberFormat rupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final List<String> kategori = [
    'Makanan',
    'Transportasi',
    'Kuliah',
    'Belanja',
    'Tagihan',
    'Hiburan',
    'Kesehatan',
    'Tabungan',
    'Lainnya',
  ];

  final Map<String, double> anggaran = {
    'Makanan': 0,
    'Transportasi': 0,
    'Kuliah': 0,
    'Belanja': 0,
    'Tagihan': 0,
    'Hiburan': 0,
    'Kesehatan': 0,
    'Tabungan': 0,
    'Lainnya': 0,
  };

  final List<_Transaksi> transaksi = [];
  final List<_TargetTabungan> tabungan = [];

  double saldoAwal = 0;
  int filterTransaksi = 0;

  String uang(num nilai) => rupiah.format(nilai);

  int get jumlahHariBulan {
    final sekarang = DateTime.now();
    return DateTime(sekarang.year, sekarang.month + 1, 0).day;
  }

  double get pemasukanBulan {
    final sekarang = DateTime.now();
    return transaksi
        .where((t) =>
            t.pemasukan &&
            t.tanggal.year == sekarang.year &&
            t.tanggal.month == sekarang.month)
        .fold(0.0, (total, t) => total + t.jumlah);
  }

  double get pengeluaranBulan {
    final sekarang = DateTime.now();
    return transaksi
        .where((t) =>
            !t.pemasukan &&
            t.tanggal.year == sekarang.year &&
            t.tanggal.month == sekarang.month)
        .fold(0.0, (total, t) => total + t.jumlah);
  }

  double get totalPemasukan =>
      transaksi.where((t) => t.pemasukan).fold(0.0, (s, t) => s + t.jumlah);

  double get totalPengeluaran =>
      transaksi.where((t) => !t.pemasukan).fold(0.0, (s, t) => s + t.jumlah);

  double get saldo => saldoAwal + totalPemasukan - totalPengeluaran;

  double get totalAnggaran =>
      anggaran.values.fold(0.0, (total, nilai) => total + nilai);

  double pengeluaranKategori(String nama) {
    final sekarang = DateTime.now();
    return transaksi
        .where((t) =>
            !t.pemasukan &&
            t.kategori == nama &&
            t.tanggal.year == sekarang.year &&
            t.tanggal.month == sekarang.month)
        .fold(0.0, (s, t) => s + t.jumlah);
  }

  double pengeluaranHariIni(String nama) {
    final sekarang = DateTime.now();
    return transaksi
        .where((t) =>
            !t.pemasukan &&
            t.kategori == nama &&
            t.tanggal.year == sekarang.year &&
            t.tanggal.month == sekarang.month &&
            t.tanggal.day == sekarang.day)
        .fold(0.0, (s, t) => s + t.jumlah);
  }

  double anggaranHarian(String nama) {
    final batas = (anggaran[nama] ?? 0) / jumlahHariBulan;
    return (batas - pengeluaranHariIni(nama)).clamp(0.0, double.infinity);
  }

  double pengeluaranMingguan(String nama) {
    final sekarang = DateTime.now();
    final hariIni = DateTime(sekarang.year, sekarang.month, sekarang.day);
    final mulai = hariIni.subtract(const Duration(days: 6));
    final besok = hariIni.add(const Duration(days: 1));

    return transaksi
        .where((t) =>
            !t.pemasukan &&
            t.kategori == nama &&
            !t.tanggal.isBefore(mulai) &&
            t.tanggal.isBefore(besok))
        .fold(0.0, (s, t) => s + t.jumlah);
  }

  double sisaMingguan(String nama) {
    final batas = (anggaran[nama] ?? 0) / jumlahHariBulan * 7;
    return (batas - pengeluaranMingguan(nama))
        .clamp(0.0, double.infinity);
  }

  IconData ikonKategori(String nama) {
    switch (nama) {
      case 'Makanan':
        return Icons.restaurant_rounded;
      case 'Transportasi':
        return Icons.directions_car_rounded;
      case 'Kuliah':
        return Icons.school_rounded;
      case 'Belanja':
        return Icons.shopping_bag_rounded;
      case 'Tagihan':
        return Icons.receipt_long_rounded;
      case 'Hiburan':
        return Icons.movie_rounded;
      case 'Kesehatan':
        return Icons.health_and_safety_rounded;
      case 'Tabungan':
        return Icons.savings_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  Color warnaKategori(String nama) {
    switch (nama) {
      case 'Makanan':
        return const Color(0xFFFFA940);
      case 'Transportasi':
        return const Color(0xFF4987F8);
      case 'Kuliah':
        return const Color(0xFF8B70E8);
      case 'Belanja':
        return const Color(0xFFFF7895);
      case 'Tagihan':
        return const Color(0xFF26B6B0);
      case 'Hiburan':
        return const Color(0xFFB078DD);
      case 'Kesehatan':
        return const Color(0xFF35B87A);
      case 'Tabungan':
        return hijau;
      default:
        return abu;
    }
  }

  String tanggal(DateTime t) {
    String dua(int n) => n.toString().padLeft(2, '0');
    return '${dua(t.day)}/${dua(t.month)}/${t.year} '
        '${dua(t.hour)}:${dua(t.minute)}';
  }

  void tambahTransaksi({
    required String judul,
    required String kategori,
    required double jumlah,
    required bool pemasukan,
    int? indeksTabungan,
  }) {
    if (jumlah <= 0) return;
    setState(() {
      transaksi.insert(
        0,
        _Transaksi(
          judul: judul,
          kategori: kategori,
          jumlah: jumlah,
          tanggal: DateTime.now(),
          pemasukan: pemasukan,
          indeksTabungan: indeksTabungan,
        ),
      );
    });
  }

  Future<void> aturSaldo() async {
    final c = TextEditingController(
      text: saldoAwal == 0 ? '' : saldoAwal.toStringAsFixed(0),
    );

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Atur saldo awal'),
        content: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Saldo awal',
            prefixText: 'Rp ',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final nilai =
                  double.tryParse(c.text.replaceAll('.', '')) ?? 0;
              setState(() => saldoAwal = nilai);
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    c.dispose();
  }

  Future<void> tambahTransaksiDialog() async {
    final namaC = TextEditingController();
    final jumlahC = TextEditingController();
    bool pemasukan = false;
    String pilihanKategori = kategori.first;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          title: const Text('Tambah transaksi'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: false,
                      label: Text('Pengeluaran'),
                      icon: Icon(Icons.south_west_rounded),
                    ),
                    ButtonSegment(
                      value: true,
                      label: Text('Pemasukan'),
                      icon: Icon(Icons.north_east_rounded),
                    ),
                  ],
                  selected: {pemasukan},
                  onSelectionChanged: (v) =>
                      setDialog(() => pemasukan = v.first),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: namaC,
                  decoration: const InputDecoration(
                    labelText: 'Nama transaksi',
                    hintText: 'Contoh: Makan siang',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: jumlahC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah uang',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: pilihanKategori,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items: kategori
                      .map((k) =>
                          DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setDialog(() => pilihanKategori = v);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                final nama = namaC.text.trim();
                final jumlah =
                    double.tryParse(jumlahC.text.replaceAll('.', '')) ?? 0;

                if (nama.isEmpty || jumlah <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Isi nama dan jumlah dengan benar.'),
                    ),
                  );
                  return;
                }

                tambahTransaksi(
                  judul: nama,
                  kategori: pilihanKategori,
                  jumlah: jumlah,
                  pemasukan: pemasukan,
                );
                Navigator.pop(ctx);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );

    namaC.dispose();
    jumlahC.dispose();
  }

  Future<void> aturAnggaran(String nama) async {
    final c = TextEditingController(
      text: (anggaran[nama] ?? 0) == 0
          ? ''
          : anggaran[nama]!.toStringAsFixed(0),
    );

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Anggaran $nama'),
        content: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Anggaran per bulan',
            prefixText: 'Rp ',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final n = double.tryParse(c.text.replaceAll('.', '')) ?? 0;
              setState(() => anggaran[nama] = n < 0 ? 0 : n);
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    c.dispose();
  }

  Future<void> aturSemuaAnggaran() async {
    final controllers = <String, TextEditingController>{
      for (final k in kategori)
        k: TextEditingController(
          text: (anggaran[k] ?? 0) == 0
              ? ''
              : anggaran[k]!.toStringAsFixed(0),
        ),
    };

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Atur semua anggaran'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: kategori.map((k) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextField(
                    controller: controllers[k],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: k,
                      prefixText: 'Rp ',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                for (final k in kategori) {
                  final n = double.tryParse(
                        controllers[k]!.text.replaceAll('.', ''),
                      ) ??
                      0;
                  anggaran[k] = n < 0 ? 0 : n;
                }
              });
              Navigator.pop(ctx);
            },
            child: const Text('Simpan semua'),
          ),
        ],
      ),
    );

    for (final c in controllers.values) {
      c.dispose();
    }
  }

  Future<void> tambahTarget() async {
    final namaC = TextEditingController();
    final targetC = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Target tabungan baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaC,
              decoration: const InputDecoration(
                labelText: 'Nama target',
                hintText: 'Contoh: Beli laptop',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: targetC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah target',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final nama = namaC.text.trim();
              final target =
                  double.tryParse(targetC.text.replaceAll('.', '')) ?? 0;

              if (nama.isEmpty || target <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Isi nama dan jumlah target dengan benar.'),
                  ),
                );
                return;
              }

              setState(() {
                tabungan.add(
                  _TargetTabungan(nama: nama, target: target),
                );
              });
              Navigator.pop(ctx);
            },
            child: const Text('Buat target'),
          ),
        ],
      ),
    );

    namaC.dispose();
    targetC.dispose();
  }

  Future<void> nabung(int indeks) async {
    final c = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Nabung: ${tabungan[indeks].nama}'),
        content: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Jumlah tabungan',
            prefixText: 'Rp ',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final n = double.tryParse(c.text.replaceAll('.', '')) ?? 0;
              if (n <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Masukkan jumlah yang benar.')),
                );
                return;
              }

              setState(() {
                tabungan[indeks].terkumpul += n;
                transaksi.insert(
                  0,
                  _Transaksi(
                    judul: 'Tabungan ${tabungan[indeks].nama}',
                    kategori: 'Tabungan',
                    jumlah: n,
                    tanggal: DateTime.now(),
                    pemasukan: false,
                    indeksTabungan: indeks,
                  ),
                );
              });
              Navigator.pop(ctx);
            },
            child: const Text('Simpan tabungan'),
          ),
        ],
      ),
    );
    c.dispose();
  }

  Future<void> hapusTransaksi(int indeks) async {
    final t = transaksi[indeks];

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus transaksi?'),
        content: Text('Transaksi "${t.judul}" akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: merah),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi == true && mounted) {
      setState(() {
        if (t.indeksTabungan != null &&
            t.indeksTabungan! < tabungan.length) {
          tabungan[t.indeksTabungan!].terkumpul =
              (tabungan[t.indeksTabungan!].terkumpul - t.jumlah)
                  .clamp(0.0, double.infinity);
        }
        transaksi.removeAt(indeks);
      });
    }
  }

  Widget judulBagian(String judul, String keterangan,
      {Widget? aksi}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    color: teks,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  keterangan,
                  style: const TextStyle(color: abu, fontSize: 11),
                ),
              ],
            ),
          ),
          if (aksi != null) aksi,
        ],
      ),
    );
  }

  Widget kartuSaldo(double lebar) {
    final rasio = totalAnggaran > 0
        ? (pengeluaranBulan / totalAnggaran).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF102A56), Color(0xFF1E56A7), Color(0xFF2677E8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: biru.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
                size: 25,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Saldo Keuangan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Atur saldo awal',
                onPressed: aturSaldo,
                icon: const Icon(Icons.edit_rounded, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            uang(saldo),
            style: TextStyle(
              color: saldo < 0 ? const Color(0xFFFFB7C1) : Colors.white,
              fontSize: lebar < 360 ? 25 : 31,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Saldo awal + pemasukan − pengeluaran',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Penggunaan anggaran bulan ini',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              Text(
                '${(rasio * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: rasio,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                rasio >= 1 ? const Color(0xFFFF8C9B) : const Color(0xFF63E6B5),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            totalAnggaran == 0
                ? 'Anggaran belum diatur'
                : 'Sisa anggaran: ${uang(totalAnggaran - pengeluaranBulan)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget kartuRingkasan(
    String judul,
    double nilai,
    IconData ikon,
    Color warna,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFE8EDF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, color: warna, size: 24),
          const SizedBox(height: 12),
          Text(judul, style: const TextStyle(color: abu, fontSize: 12)),
          const SizedBox(height: 5),
          Text(
            uang(nilai),
            style: const TextStyle(
              color: teks,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget bagianAnggaran() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        judulBagian(
          'Anggaran Saya',
          'Semua kategori dalam satu tabel yang bisa digeser.',
          aksi: TextButton.icon(
            onPressed: aturSemuaAnggaran,
            icon: const Icon(Icons.tune_rounded, size: 18),
            label: const Text('Atur semua'),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE8EDF5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Total anggaran',
                            style: TextStyle(color: abu, fontSize: 12),
                          ),
                        ),
                        Text(
                          uang(totalAnggaran),
                          style: const TextStyle(
                            color: navy,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Pengeluaran bulan ini',
                            style: TextStyle(color: abu, fontSize: 12),
                          ),
                        ),
                        Text(
                          uang(pengeluaranBulan),
                          style: const TextStyle(
                            color: merah,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor:
                      WidgetStateProperty.all(const Color(0xFFF4F7FC)),
                  columnSpacing: 18,
                  horizontalMargin: 10,
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 62,
                  columns: const [
                    DataColumn(label: Text('Kategori')),
                    DataColumn(label: Text('Anggaran')),
                    DataColumn(label: Text('Terpakai')),
                    DataColumn(label: Text('Sisa/hari')),
                    DataColumn(label: Text('Sisa/minggu')),
                    DataColumn(label: Text('Atur')),
                  ],
                  rows: kategori.map((k) {
                    final batas = anggaran[k] ?? 0;
                    final pakai = pengeluaranKategori(k);
                    final lewat = batas > 0 && pakai > batas;

                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                ikonKategori(k),
                                color: warnaKategori(k),
                                size: 18,
                              ),
                              const SizedBox(width: 7),
                              Text(k),
                            ],
                          ),
                        ),
                        DataCell(Text(uang(batas))),
                        DataCell(
                          Text(
                            uang(pakai),
                            style: TextStyle(
                              color: lewat ? merah : teks,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            uang(anggaranHarian(k)),
                            style: const TextStyle(color: biru),
                          ),
                        ),
                        DataCell(
                          Text(
                            uang(sisaMingguan(k)),
                            style: const TextStyle(color: hijau),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            tooltip: 'Atur $k',
                            onPressed: () => aturAnggaran(k),
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: biru,
                              size: 19,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Geser tabel ke samping untuk melihat seluruh kolom.',
                  style: TextStyle(color: abu, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget bagianTabungan() {
    final totalTarget =
        tabungan.fold(0.0, (s, t) => s + t.target);
    final terkumpul =
        tabungan.fold(0.0, (s, t) => s + t.terkumpul);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        judulBagian(
          'Tabungan',
          'Pantau perkembangan target keuangan.',
          aksi: IconButton(
            onPressed: tambahTarget,
            icon: const Icon(Icons.add_circle_rounded, color: hijau, size: 29),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFE5FBF2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.savings_rounded, color: hijau, size: 35),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total tabungan terkumpul',
                      style: TextStyle(color: abu, fontSize: 11),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      uang(terkumpul),
                      style: const TextStyle(
                        color: navy,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              if (totalTarget > 0)
                Text(
                  '${(terkumpul / totalTarget * 100).clamp(0, 100).round()}%',
                  style: const TextStyle(
                    color: hijau,
                    fontWeight: FontWeight.w900,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (tabungan.isEmpty)
          const _KartuKosong(
            ikon: Icons.savings_outlined,
            judul: 'Belum ada target tabungan',
            keterangan: 'Tekan tombol tambah untuk membuat target.',
          )
        else
          ...List.generate(tabungan.length, (i) {
            final t = tabungan[i];
            final progress = (t.terkumpul / t.target).clamp(0.0, 1.0);

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE8EDF5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          t.nama,
                          style: const TextStyle(
                            color: teks,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: const TextStyle(
                          color: hijau,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFE7F5EE),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(hijau),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${uang(t.terkumpul)} dari ${uang(t.target)}',
                          style: const TextStyle(color: abu, fontSize: 11),
                        ),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => nabung(i),
                        icon: const Icon(Icons.add_rounded, size: 17),
                        label: const Text('Nabung'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget bagianAnalisis() {
    final selisih = pemasukanBulan - pengeluaranBulan;
    final rasio = pemasukanBulan > 0
        ? (pengeluaranBulan / pemasukanBulan).clamp(0.0, 1.0)
        : 0.0;

    String terbesar = kategori.first;
    for (final k in kategori) {
      if (pengeluaranKategori(k) > pengeluaranKategori(terbesar)) {
        terbesar = k;
      }
    }

    final nilaiTerbesar = pengeluaranKategori(terbesar);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        judulBagian(
          'Analisis Keuangan',
          'Ringkasan kondisi keuangan bulan ini.',
        ),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE8EDF5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Arus kas bulan ini',
                style: TextStyle(
                  color: teks,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              _BarisAnalisis(
                judul: 'Pemasukan',
                nilai: uang(pemasukanBulan),
                warna: hijau,
              ),
              const SizedBox(height: 14),
              _BarisAnalisis(
                judul: 'Pengeluaran',
                nilai: uang(pengeluaranBulan),
                warna: merah,
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: rasio,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFEAF0FA),
                  valueColor: const AlwaysStoppedAnimation<Color>(merah),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                pemasukanBulan > 0
                    ? '${(rasio * 100).round()}% pemasukan telah digunakan.'
                    : 'Tambahkan pemasukan untuk melihat analisis persentase.',
                style: const TextStyle(color: abu, fontSize: 11),
              ),
              const Divider(height: 28),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Selisih pemasukan dan pengeluaran',
                      style: TextStyle(color: abu, fontSize: 11),
                    ),
                  ),
                  Text(
                    uang(selisih),
                    style: TextStyle(
                      color: selisih < 0 ? merah : hijau,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8EB),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.lightbulb_rounded,
                color: Color(0xFFE5A12A),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  pemasukanBulan == 0 && pengeluaranBulan == 0
                      ? 'Mulai catat pemasukan dan pengeluaran untuk mendapatkan analisis.'
                      : selisih < 0
                          ? 'Pengeluaran lebih besar daripada pemasukan bulan ini. Periksa kembali anggaranmu.'
                          : nilaiTerbesar > 0
                              ? 'Pengeluaran terbesar bulan ini ada pada kategori $terbesar, sebesar ${uang(nilaiTerbesar)}.'
                              : 'Pertahankan kebiasaan mencatat transaksi.',
                  style: const TextStyle(
                    color: Color(0xFF8A6B37),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget bagianTransaksi() {
    final daftar = transaksi.where((t) {
      if (filterTransaksi == 1) return t.pemasukan;
      if (filterTransaksi == 2) return !t.pemasukan;
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        judulBagian(
          'Transaksi',
          'Daftar pemasukan dan pengeluaran.',
          aksi: IconButton(
            onPressed: tambahTransaksiDialog,
            icon: const Icon(Icons.add_circle_rounded, color: biru, size: 29),
          ),
        ),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Semua'),
              selected: filterTransaksi == 0,
              onSelected: (_) => setState(() => filterTransaksi = 0),
            ),
            ChoiceChip(
              label: const Text('Pemasukan'),
              selected: filterTransaksi == 1,
              onSelected: (_) => setState(() => filterTransaksi = 1),
            ),
            ChoiceChip(
              label: const Text('Pengeluaran'),
              selected: filterTransaksi == 2,
              onSelected: (_) => setState(() => filterTransaksi = 2),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (daftar.isEmpty)
          const _KartuKosong(
            ikon: Icons.receipt_long_rounded,
            judul: 'Belum ada transaksi',
            keterangan: 'Tekan tombol tambah untuk mencatat transaksi.',
          )
        else
          ...daftar.map((t) {
            final indeks = transaksi.indexOf(t);
            final warna = t.pemasukan ? hijau : merah;

            return Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: const Color(0xFFE8EDF5)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: warnaKategori(t.kategori).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      ikonKategori(t.kategori),
                      color: warnaKategori(t.kategori),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.judul,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: teks,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${t.kategori} • ${tanggal(t.tanggal)}',
                          style: const TextStyle(color: abu, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${t.pemasukan ? '+' : '−'}${uang(t.jumlah)}',
                        style: TextStyle(
                          color: warna,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Hapus transaksi',
                        onPressed: () => hapusTransaksi(indeks),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: abu,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: latar,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: tambahTransaksiDialog,
          backgroundColor: navy,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Transaksi'),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final lebar = constraints.maxWidth;
              final padding = lebar > 760 ? 24.0 : 16.0;

              return Center(
                child: SizedBox(
                  width: lebar > 760 ? 720 : lebar,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          padding,
                          15,
                          padding,
                          12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [navy, biru],
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Keuangan',
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Atur uang, capai tujuanmu.',
                                    style: TextStyle(
                                      color: abu,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Atur saldo awal',
                              onPressed: aturSaldo,
                              icon: const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: navy,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Material(
                        color: Colors.white,
                        child: TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          labelColor: biru,
                          unselectedLabelColor: abu,
                          indicatorColor: biru,
                          tabs: const [
                            Tab(
                              icon: Icon(Icons.dashboard_rounded),
                              text: 'Ringkasan',
                            ),
                            Tab(
                              icon: Icon(Icons.table_chart_rounded),
                              text: 'Anggaran',
                            ),
                            Tab(
                              icon: Icon(Icons.savings_rounded),
                              text: 'Tabungan',
                            ),
                            Tab(
                              icon: Icon(Icons.analytics_rounded),
                              text: 'Analisis',
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(
                                padding,
                                16,
                                padding,
                                100,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  kartuSaldo(lebar),
                                  const SizedBox(height: 20),
                                  judulBagian(
                                    'Ringkasan Bulan Ini',
                                    'Pemasukan dan pengeluaran bulan ini.',
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: kartuRingkasan(
                                          'Pemasukan',
                                          pemasukanBulan,
                                          Icons.south_west_rounded,
                                          hijau,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: kartuRingkasan(
                                          'Pengeluaran',
                                          pengeluaranBulan,
                                          Icons.north_east_rounded,
                                          merah,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 22),
                                  bagianTransaksi(),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(
                                padding,
                                16,
                                padding,
                                100,
                              ),
                              child: bagianAnggaran(),
                            ),
                            SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(
                                padding,
                                16,
                                padding,
                                100,
                              ),
                              child: bagianTabungan(),
                            ),
                            SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(
                                padding,
                                16,
                                padding,
                                100,
                              ),
                              child: Column(
                                children: [
                                  bagianAnalisis(),
                                  const SizedBox(height: 24),
                                  bagianTransaksi(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _KartuKosong extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String keterangan;

  const _KartuKosong({
    required this.ikon,
    required this.judul,
    required this.keterangan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFE8EDF5)),
      ),
      child: Column(
        children: [
          Icon(ikon, color: const Color(0xFFB4C0D2), size: 38),
          const SizedBox(height: 10),
          Text(
            judul,
            style: const TextStyle(
              color: Color(0xFF24334D),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            keterangan,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF7D8BA3),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _BarisAnalisis extends StatelessWidget {
  final String judul;
  final String nilai;
  final Color warna;

  const _BarisAnalisis({
    required this.judul,
    required this.nilai,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: warna,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            judul,
            style: const TextStyle(
              color: Color(0xFF7D8BA3),
              fontSize: 12,
            ),
          ),
        ),
        Text(
          nilai,
          style: const TextStyle(
            color: Color(0xFF24334D),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}