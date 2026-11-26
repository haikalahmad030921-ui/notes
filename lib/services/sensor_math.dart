import 'dart:math' as math;

/// Gravitasi bumi dalam m/s². Dipakai untuk mengubah akselerometer dari m/s² ke g.
const gravitasi = 9.80665;

class Vektor {
  const Vektor(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;
}

/// Besar vektor tiga sumbu. Akselerometer diam di meja bernilai sekitar 1 g.
double besarVektor(Vektor v) => math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z);

/// Guncangan bila besar percepatan (satuan g) lebih besar dari ambang.
/// Tepat di ambang belum dihitung.
bool terdeteksiGuncangan(Vektor v, {double ambang = 2}) =>
    besarVektor(v) > ambang;

/// Menghitung satu guncangan per kejadian. Pembacaan dalam [jedaMs] setelah guncangan
/// dianggap bagian dari guncangan yang sama.
class PendeteksiGuncangan {
  PendeteksiGuncangan({this.ambang = 2, this.jedaMs = 800});

  final double ambang;
  final int jedaMs;
  int? _terakhirMs;

  /// Mengembalikan true bila pembacaan ini dihitung sebagai satu guncangan baru.
  bool masukkan(Vektor v, int waktuMs) {
    if (!terdeteksiGuncangan(v, ambang: ambang)) return false;
    final terakhir = _terakhirMs;
    if (terakhir != null && waktuMs - terakhir < jedaMs) return false;
    _terakhirMs = waktuMs;
    return true;
  }
}

/// Derajat kompas (0 = utara, searah jarum jam) dari magnetometer saat ponsel datar.
/// Perkiraan saja: sumbu tiap perangkat dapat berbeda.
double arahKompas(double x, double y) {
  final derajat = math.atan2(-x, y) * 180 / math.pi;
  return (derajat + 360) % 360;
}

const _mataAngin = ['U', 'TL', 'T', 'TG', 'S', 'BD', 'B', 'BL'];

/// Singkatan mata angin untuk derajat: U, TL, T, TG, S, BD, B, BL.
String mataAngin(double derajat) {
  final normal = ((derajat % 360) + 360) % 360;
  return _mataAngin[(normal / 45).round() % 8];
}
