import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final int remaining;
  final int entitlement;
  final int used;
  final double progress;

   const SummaryCard({
    super.key,
    required this.remaining,
    required this.entitlement,
    required this.used,
    required this.progress,
  });

  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: 1.0, // Background ring
                  strokeWidth: 12,
                  color: Colors.grey.shade200,
                ),
              ),
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: progress, // Actual progress
                  strokeWidth: 12,
                  color: const Color(0xFF2E7D52), // Brand Green
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$remaining",
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    "Days Left",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              _buildStatBox("Entitlement", entitlement),
              const SizedBox(width: 16),
              _buildStatBox("Used", used),
            ],
          )
        ],
      ),
    );
  }

    Widget _buildStatBox(String label, int value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4FA),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              "$value",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D52),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}