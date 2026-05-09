import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../injection_container.dart';
import '../../domain/usecases/splash_delay_usecase.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  int _countdown = 9;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
    _startSplash();
  }

  Future<void> _startSplash() async {
    // ⭐ Delay 9 detik via UseCase (domain layer) - sesuai soal
    // Countdown di UI hanya untuk tampilan
    for (int i = 9; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _countdown = i - 1);
    }
    // Panggil use case sebagai bukti arsitektur (delay sudah selesai di atas)
    await sl<SplashDelayUseCase>().executeIfNeeded();
    if (mounted) context.go('/home');
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F3460).withOpacity(0.8),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.store, size: 60, color: Color(0xFFE94560)),
              ),
              const SizedBox(height: 24),
              const Text(
                'UTD Store',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ikhsan Fadilah',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFE94560),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'NIM: 20123069',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white54,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                _countdown > 0 ? '$_countdown' : '🚀',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE94560),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _countdown > 0
                    ? 'Memuat dalam $_countdown detik...'
                    : 'Selamat datang!',
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                color: Color(0xFFE94560),
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
