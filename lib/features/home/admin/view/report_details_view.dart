import 'package:flutter/material.dart';
import '../repo/admin_repo.dart';

class ReportDetailsView extends StatelessWidget {
  final dynamic report;

  const ReportDetailsView({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Report Details"),
        backgroundColor: const Color(0xFF6A11CB),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // الجزء العلوي: الأفاتار والاسم في صف واحد
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
              // color:const Color(0xFF6A11CB), 
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const CircleAvatar(radius: 30, backgroundColor: Color.fromARGB(94, 48, 45, 45),child: Icon(Icons.person, size: 35,color: Colors.blueAccent)),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(report.user?.userName ?? "Unknown", 
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(report.user?.email ?? "No Email", 
                          style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // قائمة التفاصيل
            _buildDetailCard(Icons.message, "Report Message", report.text ?? "No message"),
            _buildDetailCard(Icons.phone, "Phone", report.user?.phoneNumber ?? "N/A"),
            _buildDetailCard(Icons.chat, "WhatsApp", report.user?.whatsappNumber ?? "N/A"),
            _buildDetailCard(Icons.badge, "National ID", report.user?.nationalId ?? "N/A"),
            
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => AdminRepo().openWhatsApp(report.user?.whatsappNumber ?? ""),
                icon: const Icon(Icons.chat), 
                label: const Text("Contact on WhatsApp"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
         color: Colors.white.withOpacity(0.08), // لون خلفية البطاقات الموحد
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2575FC), size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}