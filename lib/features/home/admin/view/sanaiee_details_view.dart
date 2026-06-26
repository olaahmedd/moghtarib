import 'package:flutter/material.dart';
import '../model/sanaiee_model.dart'; 
import '../cubit/sanaiee_cubit/sanaiee_cubit.dart';
import '../cubit/sanaiee_cubit/sanaiee_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class SanaieeDetailsView extends StatelessWidget {
  final SanaieeModel user;

  const SanaieeDetailsView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final String rawName = user.userName ?? '${user.firstName ?? ""} ${user.lastName ?? ""}'.trim();
    final String displayName = rawName.isNotEmpty ? rawName : 'User';

    return BlocListener<SanaieeCubit, SanaieeState>(
      listener: (context, state) {
        if (state is OpenWhatsAppError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF121212), 
        appBar: AppBar(
          title: const Text('Sanaiee Details', style: TextStyle(color: Colors.white, fontSize: 18)),
          backgroundColor: Colors.transparent, 
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context), 
          ),
          
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Center(
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: const Color(0xFF2575FC).withOpacity(0.2),
                  child: const Icon(Icons.person, size: 50, color: Color(0xFF2575FC)),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                displayName,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (user.email != null && user.email!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  user.email!,
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                ),
              ],
              if (user.departmentName != null && user.departmentName!.isNotEmpty) ...[
                const SizedBox(height: 10),
                _buildDepartmentBadge(user.departmentName!),
              ] else if (user.websiteURL != null && user.websiteURL != "string" && user.websiteURL!.isNotEmpty) ...[
                const SizedBox(height: 10),
                _buildDepartmentBadge(user.websiteURL!), 
              ],

              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(Icons.badge_outlined, 'First Name', user.firstName),
                    _buildDetailRow(Icons.badge_outlined, 'Last Name', user.lastName),
                    _buildDetailRow(Icons.phone_android, 'Phone Number', user.phoneNumber),
                    _buildDetailRow(Icons.credit_card, 'National ID', user.nationalId),
                    _buildDetailRow(Icons.chat_bubble_outline, 'WhatsApp', user.whatsappNumber),
                    _buildDetailRow(
                      Icons.language, 
                      'Website URL', 
                      (user.websiteURL == "string") ? null : user.websiteURL, 
                    ),
                    _buildDetailRow(Icons.admin_panel_settings_outlined, 'Account Type', user.type),
                    _buildDetailRow(
                      Icons.work_outline, 
                      'Department Name', 
                      (user.departmentName != null && user.departmentName!.isNotEmpty) ? user.departmentName : user.websiteURL,
                    ),
                  ],
                ),
              ),
              
              if (user.whatsappNumber != null && user.whatsappNumber!.isNotEmpty) ...[
                const SizedBox(height: 20),
                BlocBuilder<SanaieeCubit, SanaieeState>(
                  builder: (context, state) {
                    final isLoading = state is OpenWhatsAppLoading;
                    
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff12B866), 
                        minimumSize: const Size(double.infinity, 52), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: isLoading 
                          ? null 
                          : () {
                              context.read<SanaieeCubit>().contactViaWhatsApp(user.whatsappNumber!);
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat, color: Colors.white), 
                                SizedBox(width: 10),
                                Text(
                                  'Message on WhatsApp',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildDepartmentBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF6A11CB).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6A11CB).withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF8A4FFF), fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String? value) {
    if (value == null || value.trim().isEmpty || value.toLowerCase() == "string") return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2575FC), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}