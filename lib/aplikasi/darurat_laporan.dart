import 'package:flutter/material.dart';

class PanggilanDaruratScreen extends StatefulWidget {
  const PanggilanDaruratScreen({super.key});

  @override
  State<PanggilanDaruratScreen> createState() =>
      _PanggilanDaruratScreenState();
}

class _PanggilanDaruratScreenState extends State<PanggilanDaruratScreen> {
  String lokasi = '-';
  String nomorHP = '-';
  int _counter = 0;
  bool _isPressed = false;

  void _editData(String title, String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Ubah $title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          )
        ],
      ),
    );
  }

  void _startCountdown() {
    setState(() {
      _isPressed = true;
      _counter = 3;
    });

    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if (!_isPressed) return false;

      setState(() {
        _counter--;
      });

      if (_counter <= 0) {
        _triggerDarurat();
        _isPressed = false;
        return false;
      }

      return true;
    });
  }

  void _triggerDarurat() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Panggilan Darurat"),
        content: const Text("Permintaan darurat berhasil dikirim."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panggilan Darurat"),
        leading: BackButton(),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    lokasi,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () {
                    _editData("Lokasi", lokasi, (value) {
                      setState(() {
                        lokasi = value;
                      });
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "No. HP yang akan kami hubungi:",
                  style: TextStyle(fontSize: 14),
                ),
                const Spacer(),
                Text(nomorHP),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () {
                    _editData("Nomor HP", nomorHP, (value) {
                      setState(() {
                        nomorHP = value;
                      });
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTapDown: (_) => _startCountdown(),
              onTapUp: (_) => _isPressed = false,
              onTapCancel: () => _isPressed = false,
              child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                  boxShadow: [
                    BoxShadow(color: Colors.red.shade200, blurRadius: 12)
                  ],
                ),
                child: Center(
                  child: Text(
                    _isPressed ? '$_counter' : 'DARURAT',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Tekan Tombol Darurat Selama 3 Detik",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "Fitur ini tersedia "),
                    TextSpan(
                        text: "gratis",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " hanya untuk wilayah "),
                    TextSpan(
                      text: "DKI Jakarta",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            ". Pastikan kamu gunakan dalam kondisi darurat saja."),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
