import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Ensure this is imported for date formatting

class HistoryList extends StatelessWidget {
  final List history; // In a strict app, List<LeaveRecord>
  final VoidCallback onAddTap;

  const HistoryList({super.key, required this.history, required this.onAddTap});

  // Helper logic to find the next working day after the leave ends
  DateTime _calculateResumptionDate(DateTime endDate) {
    DateTime resumeDate = endDate.add(const Duration(days: 1));

    // If the next day is Saturday, jump to Monday (add 2 days)
    if (resumeDate.weekday == DateTime.saturday) {
      return resumeDate.add(const Duration(days: 2));
    }
    // If the next day is Sunday, jump to Monday (add 1 day)
    else if (resumeDate.weekday == DateTime.sunday) {
      return resumeDate.add(const Duration(days: 1));
    }
    // Otherwise it's a weekday
    return resumeDate;
  }

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(20),
          // ignore: deprecated_member_use
          color: Colors.white.withOpacity(0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No leave history yet.\nTap + to start.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];

        // Calculate dates
        final String startDate = DateFormat(
          'dd MMM yyyy',
        ).format(item.startDate);
        final String endDate = DateFormat('dd MMM yyyy').format(item.endDate);

        final DateTime resumptionParams = _calculateResumptionDate(
          item.endDate,
        );
        final String resumptionDate = DateFormat(
          'dd MMM yyyy',
        ).format(resumptionParams);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade100),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFEAF4FA),
                child: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF2E7D52),
                  size: 18,
                ),
              ),
              title: Text(
                "${item.days} Working Days",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              // We use a Column here to stack the dates
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateRow("Starts:", startDate),
                    const SizedBox(height: 2),
                    _buildDateRow("Ends:", endDate),
                    const SizedBox(height: 2),
                    _buildDateRow(
                      "Resumption:",
                      resumptionDate,
                      isHighlight: true,
                    ),
                  ],
                ),
              ),
              isThreeLine: true, // Allocates more space for the subtitle
            ),
          ),
        );
      },
    );
  }

  // Small helper widget for the date rows
  Widget _buildDateRow(String label, String date, {bool isHighlight = false}) {
    return Row(
      children: [
        SizedBox(
          width: 80, // Fixed width for alignment
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          date,
          style: TextStyle(
            fontSize: 12,
            color: isHighlight
                ? const Color(0xFF2E7D52)
                : const Color(0xFF1F2937),
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
