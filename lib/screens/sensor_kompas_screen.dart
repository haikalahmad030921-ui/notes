import 'dart:async';
import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../services/sensor_math.dart';
import '../theme/app_theme.dart';

class SensorKompasScreen extends StatefulWidget {
  const SensorKompasScreen({super.key});

  @override
  State<SensorKompasScreen> createState() => _SensorKompasScreenState();
}

class _SensorKompasScreenState extends State<SensorKompasScreen> {
  StreamSubscription<AccelerometerEvent>? _akselerometer;
  StreamSubscription<GyroscopeEvent>? _giroskop;
  StreamSubscription<MagnetometerEvent>? _magnetometer;

  final _pendeteksi = PendeteksiGuncangan(ambang: 2, jedaMs: 800);
  Vektor _gravitasiG = const Vektor(0, 0, 0);
  Vektor _rotasi = const Vektor(0, 0, 0);
  double _derajat = 0;
  int _jumlah = 0;

  @override
  void initState() {
    super.initState();
    _initSensors();
  }

  void _initSensors() {
    try {
      _akselerometer = accelerometerEventStream().listen(
        (e) {
          final v = Vektor(e.x / gravitasi, e.y / gravitasi, e.z / gravitasi);
          final guncang = _pendeteksi.masukkan(
            v,
            DateTime.now().millisecondsSinceEpoch,
          );
          if (!mounted) return;
          setState(() {
            _gravitasiG = v;
            if (guncang) _jumlah++;
          });
        },
        onError: (_) {},
      );

      _giroskop = gyroscopeEventStream().listen(
        (e) {
          if (!mounted) return;
          setState(() => _rotasi = Vektor(e.x, e.y, e.z));
        },
        onError: (_) {},
      );

      _magnetometer = magnetometerEventStream().listen(
        (e) {
          if (!mounted) return;
          setState(() => _derajat = arahKompas(e.x, e.y));
        },
        onError: (_) {},
      );
    } catch (_) {
      // Abaikan jika perangkat/platform tidak mendukung sensor native.
    }
  }

  @override
  void dispose() {
    _akselerometer?.cancel();
    _giroskop?.cancel();
    _magnetometer?.cancel();
    super.dispose();
  }

  String _f(double n) => n.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final arah = mataAngin(_derajat);
    final percepatan = besarVektor(_gravitasiG);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.purpleBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCircleButton(
                      icon: Icons.chevron_left,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    Column(
                      children: [
                        const Text(
                          'Sensor & Kompas Geo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Penghitung Guncangan & Arah',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.78),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    _buildCircleButton(
                      icon: Icons.refresh_rounded,
                      onTap: () => setState(() => _jumlah = 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Main Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  children: [
                    // Shake Counter Card (Orange Accent)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeCardGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.accentOrange.withValues(alpha: 0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.22),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'AKSELEROMETER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.22),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_f(percepatan)} g',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Penghitung Guncangan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '$_jumlah',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 44,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  'guncangan',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.88),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Guncang ponsel untuk menambah hitungan. Satu guncangan dihitung sekali (> 2 g).',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12.5,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => setState(() => _jumlah = 0),
                              icon: const Icon(Icons.restart_alt, size: 18),
                              label: const Text(
                                'Reset Hitungan',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.accentOrange,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Compass Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.explore_rounded,
                                    color: AppColors.primaryIndigo,
                                    size: 22,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Kompas Digital',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF2FF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  '${_derajat.round()}° $arah',
                                  style: const TextStyle(
                                    color: AppColors.primaryIndigo,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          // Visual Compass Dial
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: CustomPaint(
                              painter: _CompassDialPainter(derajat: _derajat),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${_derajat.round()}°',
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      arah,
                                      style: const TextStyle(
                                        color: AppColors.accentOrange,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Letakkan ponsel datar agar arah kompas akurat.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Gyroscope Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.screen_rotation_rounded,
                                color: AppColors.primaryIndigo,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Giroskop (rad/s)',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              _buildAxisBox('X', _f(_rotasi.x)),
                              const SizedBox(width: 10),
                              _buildAxisBox('Y', _f(_rotasi.y)),
                              const SizedBox(width: 10),
                              _buildAxisBox('Z', _f(_rotasi.z)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAxisBox(String axis, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              axis,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 22),
      ),
    );
  }
}

class _CompassDialPainter extends CustomPainter {
  final double derajat;

  _CompassDialPainter({required this.derajat});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer ring
    canvas.drawCircle(
      center,
      radius - 4,
      Paint()
        ..color = AppColors.inputBg
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      radius - 4,
      Paint()
        ..color = AppColors.primaryIndigo.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // North indicator needle rotated by -derajat
    final angleRad = -derajat * math.pi / 180;
    final tipX = center.dx + (radius - 16) * math.sin(angleRad);
    final tipY = center.dy - (radius - 16) * math.cos(angleRad);

    canvas.drawLine(
      center,
      Offset(tipX, tipY),
      Paint()
        ..color = AppColors.accentOrange
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(
      Offset(tipX, tipY),
      5,
      Paint()..color = AppColors.accentOrange,
    );
  }

  @override
  bool shouldRepaint(covariant _CompassDialPainter oldDelegate) =>
      oldDelegate.derajat != derajat;
}
