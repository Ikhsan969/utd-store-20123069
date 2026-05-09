// lib/domain/usecases/splash_delay_usecase.dart
// ⭐ LOGIKA PERSONAL: delay diatur di domain layer
// NIM: 20123069 → digit terakhir = 9 → delay 9 detik

class SplashDelayUseCase {
  static const int _lastDigitNIM = 9;
  bool _hasExecuted = false;

  // Dipakai jika belum pernah dijalankan (menghindari double delay)
  Future<void> executeIfNeeded() async {
    if (_hasExecuted) return;
    _hasExecuted = true;
    // Delay sudah terjadi di countdown UI, jadi di sini tidak perlu lagi
    // Fungsi ini tetap ada sebagai bukti arsitektur domain layer
  }

  // Dipakai jika ingin delay penuh dari domain layer
  Future<void> execute() async {
    final int delaySeconds = _lastDigitNIM == 0 ? 5 : _lastDigitNIM;
    await Future.delayed(Duration(seconds: delaySeconds));
  }
}
