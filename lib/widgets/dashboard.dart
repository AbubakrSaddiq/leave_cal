import 'package:flutter/material.dart';
import 'package:leave_cal/services/leave_provider';
import 'package:leave_cal/widgets/history_list.dart';
import 'package:leave_cal/widgets/request_leave_modal.dart';
import 'package:leave_cal/widgets/summary_card.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _showRequestModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RequestLeaveModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
             Icon(Icons.flag, color: Colors.green[800]), // Placeholder for flag
             const SizedBox(width: 8),
             const Text("Leave Calc", 
               style: TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.w700)
             ),
          ],
        ),
        actions: [
        IconButton(
    
    icon: const Icon(Icons.refresh, color: Colors.grey), 
    tooltip: "Reset All",
    onPressed: () {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Reset App"),
          content: const Text(
            "Are you sure you want to clear all leave history and reset your balance to 30 days?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                // Call the provider to clear data
                Provider.of<LeaveProvider>(context, listen: false).resetHistory();
                
                // Close the dialog
                Navigator.pop(ctx);
                
                // Optional: Show a confirmation snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All history cleared & balance reset.")),
                );
              },
              child: const Text("Reset", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    },
  )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SummaryCard(
              remaining: leaveProvider.remainingDays,
              entitlement: leaveProvider.totalEntitlement,
              used: leaveProvider.usedDays,
              progress: leaveProvider.progressPercentage,
            ),
            const SizedBox(height: 30),
            const Text(
              "Leave History",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),
            HistoryList(
              history: leaveProvider.history,
              onAddTap: () => _showRequestModal(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRequestModal(context),
        backgroundColor: const Color(0xFF2E7D52),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

