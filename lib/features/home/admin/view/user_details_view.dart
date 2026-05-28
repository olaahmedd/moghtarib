import 'package:flutter/material.dart';
import '../model/user_model.dart'; // تأكدي من صحة المسار للموديل في مشروعك

class UserDetailsView extends StatelessWidget {
  final UserModel user;

  const UserDetailsView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // تحديد الاسم المعروض (دمج الاسم الأول والأخير أو استخدام الـ userName)
    final String rawName = user.userName ?? '${user.firstName ?? ""} ${user.lastName ?? ""}'.trim();
    final String displayName = rawName.isNotEmpty ? rawName : 'User';

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // خلفية داكنة متناسقة مع الكروت
      appBar: AppBar(
        title: const Text('User Details', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF6A11CB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // العودة للخلف
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
                style: TextStyle(color: Colors.white.withValues(alpha:0.6), fontSize: 14),
              ),
            ],
            const SizedBox(height: 24),
            
            // حاوية عرض كافة تفاصيل البيانات القادمة من الـ API
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha:0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha:0.1)),
              ),
              child: Column(
                children: [
                  _buildDetailRow(Icons.badge_outlined, 'First Name', user.firstName),
                  _buildDetailRow(Icons.badge_outlined, 'Last Name', user.lastName),
                  _buildDetailRow(Icons.phone_android, 'Phone Number', user.phoneNumber),
                  _buildDetailRow(Icons.credit_card, 'National ID', user.nationalId),
                  _buildDetailRow(Icons.chat_bubble_outline, 'WhatsApp', user.whatsappNumber),
                  _buildDetailRow(Icons.language, 'Website URL', user.websiteURL),
                  _buildDetailRow(Icons.admin_panel_settings_outlined, 'Account Type', user.type),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String? value) {
    if (value == null || value.trim().isEmpty || value == "string") return const SizedBox.shrink();
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
                Text(title, style: TextStyle(color: Colors.white.withValues(alpha:0.4), fontSize: 12)),
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


// import 'package:flutter/material.dart';
// import '../model/user_model.dart'; // تأكد من صحة المسار للموديل الخاص بك
// import 'package:flutter/material.dart';
// import '../model/user_model.dart'; // قم بتعديل المسار حسب مشروعك

// class UserDetailsView extends StatelessWidget {
//   final UserModel user;

//   const UserDetailsView({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     final String rawName = user.userName ?? '${user.firstName ?? ""} ${user.lastName ?? ""}'.trim();
//     final String displayName = rawName.isNotEmpty ? rawName : 'User';

//     return Scaffold(
//       backgroundColor: const Color(0xFF121212), // خلفية متناسقة مع تطبيقك
//       appBar: AppBar(
//         title: const Text('User Profile', style: TextStyle(color: Colors.white, fontSize: 18)),
//         backgroundColor: const Color(0xFF6A11CB),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context), // العودة للخلف بسهولة
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             Center(
//               child: CircleAvatar(
//                 radius: 45,
//                 backgroundColor: const Color(0xFF2575FC).withOpacity(0.2),
//                 child: const Icon(Icons.person, size: 50, color: Color(0xFF2575FC)),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               displayName,
//               style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             if (user.email != null && user.email!.isNotEmpty) ...[
//               const SizedBox(height: 4),
//               Text(
//                 user.email!,
//                 style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
//               ),
//             ],
//             const SizedBox(height: 24),
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.05),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.white.withOpacity(0.1)),
//               ),
//               child: Column(
//                 children: [
//                   _buildDetailRow(Icons.badge_outlined, 'First Name', user.firstName),
//                   _buildDetailRow(Icons.badge_outlined, 'Last Name', user.lastName),
//                   _buildDetailRow(Icons.phone_android, 'Phone Number', user.phoneNumber),
//                   _buildDetailRow(Icons.credit_card, 'National ID', user.nationalId),
//                   _buildDetailRow(Icons.chat_bubble_outline, 'WhatsApp Number', user.whatsappNumber),
//                   _buildDetailRow(Icons.language, 'Website URL', user.websiteURL),
//                   _buildDetailRow(Icons.admin_panel_settings_outlined, 'Account Type', user.type),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(IconData icon, String title, String? value) {
//     if (value == null || value.trim().isEmpty) return const SizedBox.shrink();
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [
//           Icon(icon, color: const Color(0xFF2575FC), size: 22),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
//                 const SizedBox(height: 2),
//                 Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }