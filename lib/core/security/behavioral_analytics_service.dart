import 'dart:async';
import 'dart:developer';

class BehavioralAnalyticsService {
  // DNA Profile: average interaction intervals
  double _avgTypingInterval = 0.0;
  int _interactionCount = 0;
  DateTime? _lastInteraction;

  // Behavioral Trust Score (0-100)
  int _trustScore = 100;

  // Stream for Adaptive Auth UI tracking
  final _scoreController = StreamController<int>.broadcast();
  Stream<int> get trustScoreStream => _scoreController.stream;

  /// Call this on every keystroke or significant interaction
  void recordInteraction() {
    final now = DateTime.now();
    if (_lastInteraction != null) {
      final interval = now.difference(_lastInteraction!).inMilliseconds;

      // Basic DNA update (running average)
      _interactionCount++;
      _avgTypingInterval =
          (_avgTypingInterval * (_interactionCount - 1) + interval) /
              _interactionCount;

      // Anomalous detection (e.g., bot-like speed or sudden erratic shifts)
      if (interval < 50 || interval > 10000) {
        _penalizeScore(5);
        log('🧠 [BEHAVIORAL] Anomaly detected: Interval $interval ms. Trust Score: $_trustScore');
      } else {
        _rewardScore(1);
      }

      _scoreController.add(_trustScore);
    }
    _lastInteraction = now;
  }

  /// Explicitly trigger a "Bot Attack" simulation for testing Adaptive Auth
  void simulateBotAttack() {
    _trustScore = 20; // Critical drop
    _scoreController.add(_trustScore);
    log('🚨 [BEHAVIORAL] BOT_ATTACK_SIMULATED. Trust Score collapsed to $_trustScore.');
  }

  void _penalizeScore(int points) {
    _trustScore = (_trustScore - points).clamp(0, 100);
  }

  void _rewardScore(int points) {
    if (_trustScore < 100) {
      _trustScore = (_trustScore + points).clamp(0, 100);
    }
  }

  int getTrustScore() => _trustScore;

  /// Returns a behavioral fingerprint hash
  String getBehavioralFingerprint() {
    return 'dna_v1_${_avgTypingInterval.toInt()}_$_interactionCount';
  }

  void dispose() {
    _scoreController.close();
  }
}
