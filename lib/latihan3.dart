// 1. Import library untuk menggunakan Flutter dan HTTP client
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

// 2. Deklarasi class untuk merepresentasikan sebuah universitas
class Univ {
  String name; // Nama universitas
  String website; // Website universitas

  Univ({required this.name, required this.website}); // Constructor
}

void main() {
  runApp(const MyApp()); // Memulai aplikasi Flutter
}

// 3. Deklarasi class MyApp sebagai StatefulWidget
class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Mengembalikan instance dari MyAppState
  }
}

// 4. Deklarasi MyAppState yang akan mengatur state aplikasi
class MyAppState extends State<MyApp> {
  late Future<List<Univ>> futureUniversities; // Future untuk data universitas

  // URL untuk memuat data universitas dari API
  String url = "http://universities.hipolabs.com/search?country=Indonesia";

  // 5. Method untuk mengambil data universitas dari API
  Future<List<Univ>> fetchData() async {
    final response =
        await http.get(Uri.parse(url)); // Mengirim HTTP GET request

    if (response.statusCode == 200) {
      // Jika respons sukses (status code 200)
      // Parse JSON
      List<dynamic> data = jsonDecode(response.body);
      List<Univ> kampus = [];

      // Membuat daftar universitas dari respons JSON
      for (var item in data) {
        kampus.add(Univ(
          name: item['name'],
          website: item['web_pages'][0],
        ));
      }

      return kampus; // Mengembalikan daftar universitas
    } else {
      throw Exception('Gagal memuat data'); // Jika respons tidak sukses
    }
  }

  @override
  void initState() {
    super.initState();
    futureUniversities =
        fetchData(); // Memuat data universitas saat initState dipanggil
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Universitas',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Daftar Universitas',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Center(
          child: FutureBuilder<List<Univ>>(
            future: futureUniversities,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika data tersedia
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final univ = snapshot.data![index];
                    final colorPalette = [
                      const Color(0xFF071E22),
                      const Color(0xFF1D7874),
                    ];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      color: colorPalette[index % colorPalette.length],
                      child: ListTile(
                        title: Text(
                          univ.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          univ.website,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        onTap: () {
                          // 6. Mengarahkan ke website dari universitas yang diklik
                          launch(univ.website);
                        },
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                // Jika terjadi error
                return Text('${snapshot.error}'); // Tampilkan pesan error
              }
              // Tampilkan spinner loading secara default
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
