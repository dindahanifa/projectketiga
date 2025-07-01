import 'package:flutter/material.dart';
import 'package:projectketiga/api/laporan_api.dart';
import 'package:projectketiga/aplikasi/daftar_laporan.dart';
import 'package:projectketiga/aplikasi/kirim_laporan.dart';
import 'package:projectketiga/aplikasi/laporanwarga_laporan.dart';
import 'package:projectketiga/aplikasi/profile_laporan.dart';
import 'package:projectketiga/aplikasi/riwayat_laporan.dart';
import 'package:projectketiga/controller/notifier.dart';
import 'package:projectketiga/model/statistik_laporan.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  static String id = "/home_screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isEmergencyOpen = false;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    ProfilScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
          Positioned(
            bottom: 40,
            right: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_isEmergencyOpen) ...[
                  _buildEmergencyButton(Icons.phone, 'Panggilan Darurat', () {}),
                  SizedBox(height: 12),
                  _buildEmergencyButton(Icons.local_hospital, 'Ambulans', () {}),
                  SizedBox(height: 12),
                ],
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEmergencyOpen = !_isEmergencyOpen;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    radius: 23,
                    child: Icon(Icons.alarm, color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KirimLaporanScreen()),
          );
          statistikNotifier.value = !statistikNotifier.value;
        },
        backgroundColor: Color(0xff004aad),
        child: Icon(Icons.add, color: Colors.white),
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  Widget _buildEmergencyButton(IconData icon, String label, VoidCallback onTap) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: Text(label, style: TextStyle(fontSize: 14)),
        ),
        SizedBox(width: 8),
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.red),
        )
      ],
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () => _onItemTapped(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.home,
                          color: _selectedIndex == 0
                              ? Color(0xff1B6BF3)
                              : Colors.grey),
                      Text(
                        'Home',
                        style: TextStyle(
                            fontSize: 12,
                            color: _selectedIndex == 0
                                ? Color(0xff1B6BF3)
                                : Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
              Expanded(
                child: InkWell(
                  onTap: () => _onItemTapped(1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.person,
                          color: _selectedIndex == 1
                              ? Color(0xff1B6BF3)
                              : Colors.grey),
                      Text(
                        'Profil',
                        style: TextStyle(
                            fontSize: 12,
                            color: _selectedIndex == 1
                                ? Color(0xff1B6BF3)
                                : Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int jumlahTerbaru = 0;
  int jumlahProses = 0;
  int jumlahSelesai = 3; // dummy value untuk bar chart
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStatistik();
    statistikNotifier.addListener(fetchStatistik);
  }

  @override
  void dispose() {
    statistikNotifier.removeListener(fetchStatistik);
    super.dispose();
  }

  Future<void> fetchStatistik() async {
    setState(() {
      isLoading = true;
    });
    try {
      StatistikLaporan? statistik = await LaporanService().getStatistikLaporan();
      if (statistik != null) {
        setState(() {
          jumlahTerbaru = statistik.data?.masuk ?? 0;
          jumlahProses = statistik.data?.proses ?? 0;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Gagal mengambil statistik: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 28),
              decoration: BoxDecoration(
                color: Color(0xff004aad),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Selamat Datang!",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    "Laporkan masalah yang Anda temui di sekitar Anda",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBoxWithImage(context, "Laporan Warga", 'assets/image/laporan.png'),
                      _buildBoxWithImage(context, "Riwayat", 'assets/image/riwayat.png'),
                      _buildBoxWithImage(context, "Info", 'assets/image/info.png'),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildChartPreview(),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 135,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBoxWithCount(context, "Laporan Terbaru", jumlahTerbaru),
                      _buildBoxWithCount(context, "Proses", jumlahProses),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartPreview() {
    return Container(
      height: 150,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 30,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return Text("Terkirim", style: TextStyle(fontSize: 10));
                    case 1:
                      return Text("Proses", style: TextStyle(fontSize: 10));
                    case 2:
                      return Text("Selesai", style: TextStyle(fontSize: 10));
                    default:
                      return Text("");
                  }
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: jumlahTerbaru.toDouble(), color: Colors.blue)]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: jumlahProses.toDouble(), color: Colors.orange)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: jumlahSelesai.toDouble(), color: Colors.green)]),
          ],
        ),
      ),
    );
  }

  Widget _buildBoxWithCount(BuildContext context, String text, int count) {
    return Container(
      width: 130,
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xffffbd59),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBoxWithImage(BuildContext context, String label, String assetPath) {
    return GestureDetector(
      onTap: () {
        if (label == "Laporan Warga") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => LaporanWargaPage()));
        } else if (label == "Riwayat") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RiwayatLaporanScreen()));
        } else if (label == "Info") {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Info"),
              content: Text("Belum ada informasi"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Tutup")
                )
              ],
            ),
          );
        }
      },
      child: Container(
        width: 100,
        height: 100,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xffffbd59),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetPath, height: 40, width: 40),
            SizedBox(height: 6),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }
}
