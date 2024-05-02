// Import library untuk mengkonversi JSON ke dalam objek Dart
import 'dart:convert';

void main() {
  // String JSON yang berisi transkrip akademik mahasiswa
  String jsonTranskrip = '''
  {
    "mahasiswa": [
      {
        "nama": "Risda Rahmawati Harsono",
        "nim": "22082010040",
        "ip_semester": [
          {
            "semester": "Semester 1",
            "jumlah_sks": 20,
            "nilai": {
              "matkul_1": {"nama": "Pancasila", "sks": 2, "nilai": "A"},
              "matkul_2": {"nama": "Bahasa Inggris", "sks": 3, "nilai": "A"},
              "matkul_3": {"nama": "PENGANTAR SISTEM INFORMASI", "sks": 3, "nilai": "A"},
              "matkul_4": {"nama": "BAHASA PEMROGRAMAN 1", "sks": 3, "nilai": "B"},
              "matkul_5": {"nama": "LOGIKA DAN ALGORITMA", "sks": 3, "nilai": "A"},
              "matkul_6": {"nama": "PENGETAHUAN BISNIS", "sks": 3, "nilai": "A"},
              "matkul_7": {"nama": "Matematika Komputasi", "sks": 3, "nilai": "B"}
            }
          },
          {
            "semester": "Semester 2",
            "jumlah_sks": 21,
            "nilai": {
              "matkul_1": {"nama": "Kewarganegaraan", "sks": 2, "nilai": "A"},
              "matkul_2": {"nama": "Agama Islam", "sks": 2, "nilai": "A"},
              "matkul_3": {"nama": "Bahasa Indonesia", "sks": 2, "nilai": "A"},
              "matkul_4": {"nama": "Basis Data", "sks": 3, "nilai": "A"},
              "matkul_5": {"nama": "Analisis Proses Bisnis", "sks": 3, "nilai": "A"},
              "matkul_6": {"nama": "Bahasa Pemrograman 2", "sks": 3, "nilai": "A"},
              "matkul_7": {"nama": "REKAYASA PERANGKAT LUNAK", "sks": 3, "nilai": "A-"},
              "matkul_8": {"nama": "Sistem Informasi Manajemen", "sks": 3, "nilai": "A"}
            }
          }
        ]
      },
      {
        "nama": "Muhammad Rizky Fahrizal",
        "nim": "22082010041",
        "ip_semester": [
          {
            "semester": "Semester 1",
            "jumlah_sks": 20,
            "nilai": {
              "matkul_1": {"nama": "Pancasila", "sks": 2, "nilai": "A"},
              "matkul_2": {"nama": "Bahasa Inggris", "sks": 3, "nilai": "A"},
              "matkul_3": {"nama": "PENGANTAR SISTEM INFORMASI", "sks": 3, "nilai": "A"},
              "matkul_4": {"nama": "BAHASA PEMROGRAMAN 1", "sks": 3, "nilai": "B+"},
              "matkul_5": {"nama": "LOGIKA DAN ALGORITMA", "sks": 3, "nilai": "B"},
              "matkul_6": {"nama": "PENGETAHUAN BISNIS", "sks": 3, "nilai": "A"}
            }
          },
          {
            "semester": "Semester 2",
            "jumlah_sks": 21,
            "nilai": {
              "matkul_1": {"nama": "Kewarganegaraan", "sks": 2, "nilai": "B"},
              "matkul_2": {"nama": "Agama Islam", "sks": 2, "nilai": "A"},
              "matkul_3": {"nama": "Bahasa Indonesia", "sks": 2, "nilai": "B+"},
              "matkul_4": {"nama": "Basis Data", "sks": 3, "nilai": "A"},
              "matkul_5": {"nama": "Analisis Proses Bisnis", "sks": 3, "nilai": "B"},
              "matkul_6": {"nama": "Bahasa Pemrograman 2", "sks": 3, "nilai": "B"},
              "matkul_7": {"nama": "REKAYASA PERANGKAT LUNAK", "sks": 3, "nilai": "A-"},
              "matkul_8": {"nama": "Sistem Informasi Manajemen", "sks": 3, "nilai": "A-"}
            }
          }
        ]
      }
    ]
  }
''';

// Decode JSON ke dalam bentuk Map
  var transkripMahasiswa = jsonDecode(jsonTranskrip);

  // Mengakses data mahasiswa dari transkrip
  var mahasiswa = transkripMahasiswa['mahasiswa'];

  // Iterasi melalui setiap mahasiswa dalam transkrip
  for (var mhs in mahasiswa) {
    var namaMahasiswa = mhs['nama']; // Mendapatkan nama mahasiswa
    var nimMahasiswa = mhs['nim']; // Mendapatkan NIM mahasiswa
    var ipSemester = mhs['ip_semester']; // Mendapatkan data IP per semester

    // Variabel untuk menghitung total SKS dan total bobot nilai
    var totalSks = 0.0;
    var totalBobotNilai = 0.0;

    // Iterasi melalui setiap semester dalam transkrip mahasiswa
    for (var semester in ipSemester) {
      var nilai = semester['nilai']; // Mendapatkan data nilai per semester

      // Iterasi melalui setiap mata kuliah dalam semester
      for (var matkul in nilai.values) {
        var sks = matkul['sks']; // Mendapatkan jumlah SKS mata kuliah
        var bobotNilai =
            hitungBobotNilai(matkul['nilai']); // Menghitung bobot nilai
        totalSks += sks; // Menambahkan jumlah SKS ke total SKS
        totalBobotNilai += (sks *
            bobotNilai); // Menambahkan bobot nilai SKS ke total bobot nilai
      }
    }

    var ipk = totalBobotNilai / totalSks; // Menghitung IPK

    // Menampilkan hasil per mahasiswa
    print('Nama Mahasiswa: $namaMahasiswa');
    print('NIM Mahasiswa: $nimMahasiswa');
    print('IPK: ${ipk.toStringAsFixed(2)}');
    //menggunakan toStringAsFixed agar hasil dibulatkan
    print('\n');
  }
}

// Function untuk menghitung bobot nilai
double hitungBobotNilai(String nilai) {
  switch (nilai) {
    case 'A':
      return 4.0;
    case 'A-':
      return 3.75;
    case 'B+':
      return 3.50;
    case 'B':
      return 3.0;
    case 'B-':
      return 2.75;
    case 'C+':
      return 2.50;
    case 'C':
      return 2.0;
    case 'D+':
      return 1.50;
    case 'D':
      return 1.0;
    case 'E':
      return 0.0;
    default:
      return 0.0; // Default jika nilai tidak dikenali adalah 0.0
  }
}
