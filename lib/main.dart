import 'package:flutter/material.dart';

void main() {
  runApp(const BukuKontakApp());
}

class BukuKontakApp extends StatelessWidget {
  const BukuKontakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buku Kontak',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BerandaPage(),
    );
  }
}

// Model data untuk kontak
class KontakModel {
  final String nama;
  final String email;
  final String telepon;

  KontakModel({required this.nama, required this.email, required this.telepon});
}

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  // List untuk menyimpan data kontak
  final List<KontakModel> _daftarKontak = [];

  // Fungsi untuk menambah kontak baru
  void _tambahKontak(String nama, String email, String telepon) {
    setState(() {
      _daftarKontak.add(KontakModel(nama: nama, email: email, telepon: telepon));
    });
  }

  // Fungsi untuk menghapus kontak berdasarkan index
  void _hapusKontak(int index) {
    setState(() {
      _daftarKontak.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue, // Mengatur latar belakang AppBar jadi biru
          foregroundColor: Colors.white, // Warna teks dan ikon di AppBar jadi putih
          title: const Text('BUKU KONTAK'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Container(
              color: Colors.blue, // Mengatur latar belakang TabBar menjadi biru
              child: const TabBar(
                labelColor: Colors.white, // Warna teks/ikon tab yang aktif
                unselectedLabelColor: Colors.white70, // Warna teks/ikon tab yang tidak aktif
                indicatorColor: Colors.white, // Warna garis bawah tab
                tabs: [
                  Tab(icon: Icon(Icons.person), text: 'Kontak'),
                  Tab(icon: Icon(Icons.star), text: 'Favorit'),
                ],
              ),
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'BUKU KONTAK',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Kontak'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Tambah Kontak'),
                onTap: () async {
                  Navigator.pop(context);
                  final hasilBaru = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TambahKontakPage(),
                    ),
                  );
                  if (hasilBaru != null && hasilBaru is KontakModel) {
                    _tambahKontak(hasilBaru.nama, hasilBaru.email, hasilBaru.telepon);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Favorit'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Tentang'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TentangPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            KontakPage(
              daftarKontak: _daftarKontak,
              onHapus: _hapusKontak,
            ),
            const FavoritPage(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final hasilBaru = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TambahKontakPage(),
              ),
            );
            if (hasilBaru != null && hasilBaru is KontakModel) {
              _tambahKontak(hasilBaru.nama, hasilBaru.email, hasilBaru.telepon);
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class KontakPage extends StatelessWidget {
  final List<KontakModel> daftarKontak;
  final Function(int) onHapus;

  const KontakPage({super.key, required this.daftarKontak, required this.onHapus});

  @override
  Widget build(BuildContext context) {
    if (daftarKontak.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada kontak',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: daftarKontak.length,
      itemBuilder: (context, index) {
        final kontak = daftarKontak[index];
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(kontak.nama),
          subtitle: Text('${kontak.email}\n${kontak.telepon}'),
          isThreeLine: true,
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              onHapus(index);
            },
          ),
        );
      },
    );
  }
}

class FavoritPage extends StatelessWidget {
  const FavoritPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Belum ada kontak favorit',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}

class TambahKontakPage extends StatefulWidget {
  const TambahKontakPage({super.key});

  @override
  State<TambahKontakPage> createState() => _TambahKontakPageState();
}

class _TambahKontakPageState extends State<TambahKontakPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Tambah Kontak'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _teleponController,
              decoration: const InputDecoration(labelText: 'No Handphone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final nama = _namaController.text;
                final email = _emailController.text;
                final telepon = _teleponController.text;

                if (nama.isNotEmpty) {
                  Navigator.pop(
                    context,
                    KontakModel(nama: nama, email: email, telepon: telepon),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Tentang'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/ans.jpeg'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Anshar Deas Alif D',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('XII RPL B', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            const Text('SMK Negeri 5 Surakarta', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}