import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leave_cal/services/leave_provider';
import 'package:provider/provider.dart';

class RequestLeaveModal extends StatefulWidget {
  const RequestLeaveModal({super.key});

  @override
  State<RequestLeaveModal> createState() => _RequestLeaveModalState();
}

class _RequestLeaveModalState extends State<RequestLeaveModal> {
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _reasonController =
      TextEditingController(); // New: Optional reason
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false; // Local UI state for the save button

  @override
  void dispose() {
    _daysController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF2E7D52),
            colorScheme: const ColorScheme.light(primary: Color(0xFF2E7D52)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    final provider = Provider.of<LeaveProvider>(context, listen: false);
    final int? days = int.tryParse(_daysController.text);

    // Validation
    if (days == null || days <= 0) {
      _showError("Please enter a valid number of days");
      return;
    }

    if (days > provider.remainingDays) {
      _showError("Insufficient leave balance");
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Logic: Calculate end date (simplified logic: start date + days)
      final DateTime endDate = _selectedDate.add(Duration(days: days - 1));

      // Call the Supabase method from LeaveProvider
      await provider.addLeave(
        _selectedDate,
        endDate,
        days,
        _reasonController.text.isEmpty
            ? "Annual Leave"
            : _reasonController.text,
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showError("Failed to save: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat('dd MMM yyyy').format(_selectedDate);
    final provider = Provider.of<LeaveProvider>(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),

          const Text(
            "Start Date",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildDatePicker(dateString),

          const SizedBox(height: 20),

          const Text(
            "Number of Days",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildTextField(
            _daysController,
            "Max ${provider.remainingDays}",
            TextInputType.number,
          ),

          const SizedBox(height: 30),

          _buildSubmitButton(),
        ],
      ),
    );
  }

  // --- Helper Widgets to keep code clean ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Request Leave",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          style: IconButton.styleFrom(backgroundColor: Colors.grey.shade100),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label) {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    TextInputType type,
  ) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D52),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Calculate",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
