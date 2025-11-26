
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class TrackingModel extends ChangeNotifier {
  final double _averageStrideLengthMeters = 0.76;
  final double _metValueForWalking = 3.5;
  final double _carbFactor = 0.9;
  final double _userWeightKg = 70.0;

  int _currentSteps = 0;
  DateTime? _startTime;
  bool _isRunning = false;
  Timer? _stepSimulatorTimer;

  int get currentSteps => _currentSteps;
  bool get isRunning => _isRunning;

  void toggleTracking() {
    if (_isRunning) {
      _stopTracking();
    } else {
      _startTracking();
    }
    notifyListeners();
  }

  void _startTracking() {
    _startTime = DateTime.now();
    _isRunning = true;
    _startStepSimulation();
  }

  void _stopTracking() {
    _isRunning = false;
    _stepSimulatorTimer?.cancel();
  }

  void resetTracking() {
    _stopTracking();
    _currentSteps = 0;
    _startTime = null;
    notifyListeners();
  }

  void _startStepSimulation() {
    _stepSimulatorTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRunning) {
        _currentSteps += Random().nextInt(3) + 2;
        notifyListeners();
      }
    });
  }

  int getElapsedTimeSeconds() {
    if (_startTime == null) return 0;
    return DateTime.now().difference(_startTime!).inSeconds;
  }

  String getElapsedTimeFormatted() {
    final seconds = getElapsedTimeSeconds();
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  double calculateDistanceKm() {
    final distanceMeters = _currentSteps * _averageStrideLengthMeters;
    return distanceMeters / 1000.0;
  }

  int calculateCaloriesBurned() {
    if (_userWeightKg <= 0.0) return 0;

    final durationHours = getElapsedTimeSeconds() / 3600.0;
    final calories = _userWeightKg * _metValueForWalking * durationHours;

    return calories.toInt();
  }

  double calculateCarbsRecommendationGrams() {
    return _userWeightKg * _carbFactor;
  }
}
