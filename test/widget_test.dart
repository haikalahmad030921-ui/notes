import 'package:flutter_test/flutter_test.dart';
import 'package:notes/main.dart';
import 'package:notes/services/sensor_math.dart';

void main() {
  testWidgets('GeoNotesApp renders LoginScreen and navigates to Beranda and Sensor',
      (WidgetTester tester) async {
    await tester.pumpWidget(const GeoNotesApp());

    expect(find.text('Selamat Datang!'), findsOneWidget);
    expect(find.text('Masuk Sekarang'), findsOneWidget);

    await tester.tap(find.text('Masuk Sekarang'));
    await tester.pumpAndSettle();

    expect(find.text('Hi James 👋'), findsOneWidget);
    expect(find.text('Catatan Geo Tersimpan'), findsOneWidget);

    await tester.tap(find.text('Sensor'));
    await tester.pumpAndSettle();

    expect(find.text('Sensor & Kompas Geo'), findsOneWidget);
    expect(find.text('Penghitung Guncangan'), findsOneWidget);
    expect(find.text('Kompas Digital'), findsOneWidget);
  });

  test('Sensor math calculates shake detection and compass direction', () {
    final detektor = PendeteksiGuncangan(ambang: 2, jedaMs: 800);
    expect(detektor.masukkan(const Vektor(0, 0, 1), 1000), isFalse);
    expect(detektor.masukkan(const Vektor(2.5, 0, 0), 1000), isTrue);
    expect(detektor.masukkan(const Vektor(2.5, 0, 0), 1200), isFalse);
    expect(detektor.masukkan(const Vektor(2.5, 0, 0), 1900), isTrue);

    expect(mataAngin(0), 'U');
    expect(mataAngin(90), 'T');
    expect(mataAngin(180), 'S');
    expect(mataAngin(270), 'B');
  });
}
