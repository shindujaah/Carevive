import 'package:flutter/material.dart';

class SeverityWidget extends StatelessWidget {
  final String severity;
  final Function(String) onChanged;

  SeverityWidget({required this.severity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSeverityOption(
            'None', Icons.sentiment_very_dissatisfied, Colors.red),
        _buildSeverityOption(
            'Mild', Icons.sentiment_dissatisfied, Colors.orange),
        _buildSeverityOption('Moderate', Icons.sentiment_neutral, Colors.blue),
        _buildSeverityOption('Good', Icons.sentiment_satisfied, Colors.green),
      ],
    );
  }

  Widget _buildSeverityOption(String label, IconData icon, Color color) {
    bool isSelected = label == severity;
    return GestureDetector(
      onTap: () => onChanged(label),
      child: Column(
        children: [
          Icon(icon, color: isSelected ? color : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? color : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
