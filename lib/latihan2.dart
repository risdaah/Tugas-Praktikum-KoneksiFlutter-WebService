// Import library untuk menggunakan Flutter framework dan untuk melakukan HTTP requests.
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp()); // Mulai aplikasi Flutter.
}

// Kelas untuk menampung data hasil panggilan API.
class Activity {
  String aktivitas; // Attribut untuk menampung aktivitas.
  String jenis; // Attribut untuk menampung jenis aktivitas.

  Activity(
      {required this.aktivitas,
      required this.jenis}); // Constructor untuk kelas Activity.

  // Method untuk mengubah data dari JSON ke atribut kelas Activity.
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'], // Ambil data aktivitas dari JSON.
      jenis: json['type'], // Ambil data jenis aktivitas dari JSON.
    );
  }
}

// Kelas utama aplikasi Flutter.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Mengembalikan instance dari MyAppState.
  }
}

// State untuk MyApp.
class MyAppState extends State<MyApp> {
  late Future<Activity>
      futureActivity; // Future untuk menampung hasil panggilan API.
  String url =
      "https://www.boredapi.com/api/activity"; // URL untuk panggilan API.

  // Method untuk inisialisasi futureActivity.
  Future<Activity> init() async {
    return Activity(
        aktivitas: "",
        jenis: ""); // Mengembalikan instance Activity dengan nilai default.
  }

  // Method untuk mengambil data dari API.
  Future<Activity> fetchData() async {
    final response =
        await http.get(Uri.parse(url)); // Melakukan panggilan GET ke URL.
    if (response.statusCode == 200) {
      // Jika respons sukses (status code 200),
      // parse respons JSON.
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // Jika respons gagal (bukan status code 200),
      // lempar exception.
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = init();
    // Inisialisasi futureActivity pada awal aplikasi.
  }

  @override
  Widget build(Object context) {
    return MaterialApp(
        debugShowCheckedModeBanner:
            false, // Menghilangkan banner debug pada mode debug.
        home: Scaffold(
          body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      futureActivity = fetchData();
                      // Ketika tombol ditekan, panggil fetchData untuk mendapatkan aktivitas baru.
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue, // Style tombol dengan latar belakang biru.
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Saya bosan ..."), // Teks pada tombol.
                ),
              ),
              FutureBuilder<Activity>(
                future: futureActivity,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Jika data tersedia, tampilkan aktivitas dan jenis.
                    return Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Text(snapshot.data!.aktivitas),
                          Text("Jenis: ${snapshot.data!.jenis}")
                        ]));
                  } else if (snapshot.hasError) {
                    // Jika terjadi error, tampilkan pesan error.
                    return Text('${snapshot.error}');
                  }
                  // Default: tampilkan loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ]),
          ),
        ));
  }
}
