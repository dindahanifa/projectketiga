import 'package:flutter/material.dart';
import 'package:projectketiga/api/user_api.dart';

class EditProfilScreen extends StatefulWidget {
  const EditProfilScreen({super.key});

  @override
  State<EditProfilScreen> createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserService userService = UserService();

  final TextEditingController nameController = TextEditingController(text: 'din_haf');
  final TextEditingController emailController = TextEditingController(text: 'dinda.h33@gmail.com');

  // Optional input (belum dikirim ke backend, hanya tampilan)
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController rtController = TextEditingController();
  final TextEditingController rwController = TextEditingController();
  final TextEditingController provinsiController = TextEditingController();
  final TextEditingController kotaController = TextEditingController();
  final TextEditingController kecamatanController = TextEditingController();
  final TextEditingController kelurahanController = TextEditingController();

  void _simpanPerubahan() async {
    if (!_formKey.currentState!.validate()) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin mengubah nama dan email?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ya')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await userService.updateProfile(
          nameController.text.trim(),
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
        Navigator.pop(context); // kembali ke halaman sebelumnya
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui profil: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Informasi Diri', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: _simpanPerubahan,
            child: const Text(
              'Ubah Profil',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSection(
                title: 'Pemilik Akun',
                children: [
                  _buildTextField(label: 'Username', controller: nameController, required: true),
                  _buildTextField(label: 'E-mail', controller: emailController, required: true),
                  _buildTextField(label: 'No. Handphone', controller: phoneController),
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: 'Alamat Domisili',
                children: [
                  _buildTextField(label: 'Alamat Domisili', controller: alamatController),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(label: 'RT', controller: rtController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField(label: 'RW', controller: rwController)),
                    ],
                  ),
                  _buildTextField(label: 'Provinsi', controller: provinsiController),
                  _buildTextField(label: 'Kota/Kabupaten', controller: kotaController),
                  _buildTextField(label: 'Kecamatan', controller: kecamatanController),
                  _buildTextField(label: 'Kelurahan', controller: kelurahanController),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: required
            ? (value) => value == null || value.trim().isEmpty ? '$label wajib diisi' : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          border: const UnderlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
        ),
      ),
    );
  }
}
