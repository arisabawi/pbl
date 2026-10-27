
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color primaryBlue = Color(0xFF246BFD);
  static const Color backgroundColor = Color(0xFFF3F6FC);
  static const Color textColor = Color(0xFF172B50);

  String name = 'Pengguna Asisten';
  String email = 'pengguna@email.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 190,
            pinned: true,
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Profil Saya',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF246BFD),
                      Color(0xFF65B5FF),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -35,
                      top: 35,
                      child: Icon(
                        Icons.wb_sunny_rounded,
                        size: 175,
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    Positioned(
                      left: 22,
                      bottom: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Halo, selamat datang!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Kartu informasi pengguna
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withValues(alpha: 0.07),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 94,
                              height: 94,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF246BFD),
                                    Color(0xFF72C6FF),
                                  ],
                                ),
                                border: Border.all(
                                  color: const Color(0xFFE5EEFF),
                                  width: 5,
                                ),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                size: 55,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF19B978),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          name,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          email,
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _editProfile,
                            icon: const Icon(Icons.edit_rounded, size: 18),
                            label: const Text('Edit Profil'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 13,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  _sectionTitle('Akun Saya'),

                  const SizedBox(height: 12),

                  _menuCard([
                    _menuItem(
                      Icons.person_outline_rounded,
                      'Informasi Pribadi',
                      'Nama dan email pengguna',
                      () => _editProfile(),
                    ),
                    _menuItem(
                      Icons.notifications_none_rounded,
                      'Notifikasi',
                      'Pengingat aktivitas harian',
                      () => _showMessage('Pengaturan notifikasi'),
                    ),
                    _menuItem(
                      Icons.lock_outline_rounded,
                      'Keamanan Akun',
                      'Pengaturan keamanan akun',
                      () => _showMessage(
                        'Fitur keamanan akan tersedia setelah login dibuat',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  _sectionTitle('Preferensi'),

                  const SizedBox(height: 12),

                  _menuCard([
                    _menuItem(
                      Icons.palette_outlined,
                      'Tampilan Aplikasi',
                      'Tema dan tampilan',
                      () => _showMessage('Pengaturan tampilan'),
                    ),
                    _menuItem(
                      Icons.help_outline_rounded,
                      'Bantuan',
                      'Panduan penggunaan aplikasi',
                      () => _showMessage('Pusat bantuan Asisten Harian'),
                    ),
                    _menuItem(
                      Icons.info_outline_rounded,
                      'Tentang Aplikasi',
                      'Asisten Harian versi 1.0.0',
                      () => _showAbout(),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _confirmLogout,
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Keluar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(
                          color: Color(0xFFFFD7D7),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Asisten Harian • Versi 1.0.0',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: textColor,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _menuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }

  Widget _menuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: primaryBlue.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: primaryBlue),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.blueGrey,
          fontSize: 12,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Colors.blueGrey,
      ),
      onTap: onTap,
    );
  }

  void _editProfile() {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = nameController.text.trim();
              final newEmail = emailController.text.trim();

              if (newName.isEmpty || newEmail.isEmpty) {
                return;
              }

              setState(() {
                name = newName;
                email = newEmail;
              });

              Navigator.pop(dialogContext);
              _showMessage('Profil berhasil diperbarui di tampilan aplikasi');
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    ).then((_) {
      nameController.dispose();
      emailController.dispose();
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Asisten Harian',
      applicationVersion: '1.0.0',
      applicationLegalese: 'Aplikasi untuk membantu aktivitas harian.',
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text(
          'Fitur login belum diaktifkan. '
          'Apakah kamu ingin menutup dialog ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Kembali'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _showMessage(
                'Fitur keluar akan aktif setelah sistem login tersedia',
              );
            },
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }
}
