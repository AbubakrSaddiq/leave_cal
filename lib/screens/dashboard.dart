import 'package:flutter/material.dart';
import 'package:leave_cal/services/leave_provider';
import 'package:leave_cal/services/auth_service.dart'; // Import for logout
import 'package:leave_cal/widgets/history_list.dart';
import 'package:leave_cal/widgets/request_leave_modal.dart';
import 'package:leave_cal/widgets/summary_card.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule fetch after the first frame to ensure provider is accessible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LeaveProvider>(context, listen: false).fetchLeaveData();
    });
  }

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
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Leave Calculator",
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: "Logout",
            onPressed: () async {
              await authService.signOut();
            },
          ),
          // Reset Button (Modified to handle Supabase later if needed)
          // IconButton(
          //   icon: const Icon(Icons.refresh, color: Colors.grey),
          //   tooltip: "Reset All",
          //   onPressed: () {
          //     _showResetDialog(context);
          //   },
          // ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => leaveProvider.fetchLeaveData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRequestModal(context),
        backgroundColor: const Color(0xFF2E7D52),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
