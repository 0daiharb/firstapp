import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'class.dart';

void main() {
  runApp(const ProviderSetup());
}

class ProviderSetup extends StatelessWidget {
  const ProviderSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TrackingModel(),
      child: const FitnessTrackerApp(),
    );
  }
}

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Activity Tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: const TrackerScreen(),
    );
  }
}

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Tracker'),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: Consumer<TrackingModel>(
        builder: (context, model, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildMetricCard(
                    icon: Icons.timer,
                    value: model.getElapsedTimeFormatted(),
                    label: 'Duration',
                    unit: '',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricCard(
                        icon: Icons.directions_run,
                        value: model.currentSteps.toString(),
                        label: 'Steps',
                        unit: '',
                      ),
                      _buildMetricCard(
                        icon: Icons.alt_route,
                        value: model.calculateDistanceKm().toStringAsFixed(2),
                        label: 'Distance',
                        unit: 'Km',
                      ),
                    ],
                  ),
                  _buildCaloriesDisplay(model),
                  _buildControlButton(context, model),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard({required IconData icon, required String value, required String label, required String unit}) {
    return Column(
      children: [
        Icon(icon, size: 48.0, color: Colors.green.shade600),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
        ),
        Text(
          '$label $unit',
          style: TextStyle(fontSize: 16.0, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildCaloriesDisplay(TrackingModel model) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              '${model.calculateCaloriesBurned()} kcal',
              style: const TextStyle(
                  fontSize: 40.0, fontWeight: FontWeight.w900, color: Colors.redAccent),
            ),
            const SizedBox(height: 10),
            if (!model.isRunning && model.getElapsedTimeSeconds() > 0)
              Text(
                'Suggested Carbs: ${model.calculateCarbsRecommendationGrams().toStringAsFixed(1)} g',
                style: const TextStyle(fontSize: 16.0, color: Colors.blueGrey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(BuildContext context, TrackingModel model) {
    Color buttonColor;
    String buttonText;

    if (model.isRunning) {
      buttonColor = Colors.red.shade600;
      buttonText = 'End Session';
    } else if (model.getElapsedTimeSeconds() > 0) {
      buttonColor = Colors.blueGrey;
      buttonText = 'Reset';
    } else {
      buttonColor = Colors.green.shade600;
      buttonText = 'Start';
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
      onPressed: () {
        if (model.getElapsedTimeSeconds() > 0 && !model.isRunning) {
          model.resetTracking();
        } else {
          model.toggleTracking();
        }
      },
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 20.0, color: Colors.white),
      ),
    );
  }
}
