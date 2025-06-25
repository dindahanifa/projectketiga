import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static String id = "/home_screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    _HomeContent(),
    ProfilContent(),
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
      body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('FAB (+) ditekan!');
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      color: Colors.white,
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
              child: InkWell(
            onTap: () => _onItemTapped(0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
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
          )),
          Expanded(child: SizedBox()),
          Expanded(
              child: InkWell(
            onTap: () => _onItemTapped(1),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
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
          )),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Update',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    _buildUpdateSection(
                        "10", "100", "Laporan Baru", Colors.black),
                    SizedBox(height: 24),
                    _buildMenuSection(),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/image/logo.png',
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateSection(
      String count, String total, String title, Color accentColor) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(count,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey)),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Menu',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildMenuItem(Icons.file_download, 'Laporan masuk'),
            _buildMenuItem(Icons.file_upload, 'Laporan Keluar'),
            _buildMenuItem(Icons.drafts, 'Riwayat'),
          ],
        )
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          SizedBox(height: 8),
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey))
        ],
      ),
    );
  }
}

class ProfilContent extends StatelessWidget {
  const ProfilContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Halaman Profil',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
