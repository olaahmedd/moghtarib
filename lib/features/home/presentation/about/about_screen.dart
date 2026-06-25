import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/utils/app_colors.dart';
class TeamMember {
  final String name;
  final String role;
  final String imagePath;
  final String whatsappUrl;

  TeamMember({
    required this.name,
    required this.role,
    required this.imagePath,
    required this.whatsappUrl,
  });
}
class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});
  final List<TeamMember> teamMembers = [
    TeamMember(
      name: 'Gamal Abd El Naser',
      role: 'Team Leader',
      imagePath: 'assets/images/gamal.jpeg',
      whatsappUrl: 'https://wa.me/201027964549', 
    ),
    TeamMember(
      name: 'Esraa Mohamed',
      role: 'UI/UX Designer',
      imagePath: 'assets/images/esraa.jpeg',
      whatsappUrl: 'https://wa.me/201145682612',
    ),
    TeamMember(
      name: 'Mohamed Samy',
      role: 'Software Tester',
      imagePath: 'assets/images/samy.jpeg',
      whatsappUrl: 'https://wa.me/201104866258',
    ),
    TeamMember(
      name: 'Ola Ahmed',
      role: 'Flutter Developer',
      imagePath: 'assets/images/ola.jpeg',
      whatsappUrl: 'https://wa.me/201551120823',
    ),
    TeamMember(
      name: 'Aya Ahmed',
      role: 'Flutter Developer',
      imagePath: 'assets/images/aya.jpeg',
      whatsappUrl: 'https://wa.me/201097589843',
    ),
    TeamMember(
      name: 'Abdulrhman Reda',
      role: 'Flutter Developer',
      imagePath: 'assets/images/abdo.jpeg',
      whatsappUrl: 'https://wa.me/201066723755',
    ),
  ];
  Future<void> _launchWhatsApp(String phoneUrl) async {
    
    final String phoneNumber = phoneUrl.replaceAll('https://wa.me/', '');

   
    final Uri whatsappAppUri = Uri.parse('whatsapp://send?phone=$phoneNumber');
    
    
    final Uri whatsappWebUri = Uri.parse('https://api.whatsapp.com/send?phone=$phoneNumber');

    try {
      
      final bool launched = await launchUrl(
        whatsappAppUri,
        mode: LaunchMode.externalNonBrowserApplication, 
      );
      if (!launched) {
        await launchUrl(
          whatsappWebUri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      debugPrint('تطبيق الواتساب غير مسطب، جاري الفتح عبر المتصفح: $e');
      try {
        await launchUrl(
          whatsappWebUri,
          mode: LaunchMode.platformDefault,
        );
      } catch (innerError) {
        debugPrint('Could not launch WhatsApp link at all: $innerError');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'About',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             
              const Text(
                'Meet Our Team',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              
              Container(
                width: 80,
                height: 4,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 25),

              
              GridView.builder(
                shrinkWrap: true, 
                physics: const NeverScrollableScrollPhysics(), 
                itemCount: teamMembers.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: 12, 
                  mainAxisSpacing: 16, 
                  childAspectRatio: 0.65, 
                ),
                itemBuilder: (context, index) {
                  final member = teamMembers[index];
                  return _buildTeamCard(member);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamCard(TeamMember member) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), 
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                member.imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.white10,
                  child: const Icon(Icons.person, color: Colors.white38, size: 50),
                ),
              ),
            ),
          ),
          
          
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 4.0),
            child: Text(
              member.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            member.role,
            style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 8),

          
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
            child: Row(
              children: [
                
                Expanded(
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'Say Hello 👋',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                
                GestureDetector(
                  onTap: () => _launchWhatsApp(member.whatsappUrl),
                  child: Container(
                    width: 32,
                    height: 32,
                    padding: const EdgeInsets.all(7.0), 
                    decoration: const BoxDecoration(
                      color: Color(0xFF25D366), 
                      shape: BoxShape.circle,
                    ),
                    child: CustomPaint(
                      painter: WhatsAppIconPainter(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class WhatsAppIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.cubicTo(size.width * 0.22, 0, 0, size.height * 0.22, 0, size.height * 0.5);
    path.cubicTo(0, size.height * 0.62, 0.04, size.height * 0.73, 0.11, size.height * 0.82);
    path.lineTo(size.width * 0.03, size.height * 0.97);
    path.lineTo(size.width * 0.19, size.height * 0.92);
    path.cubicTo(size.width * 0.28, size.height * 0.97, size.width * 0.39, size.height * 1, size.width * 0.5, size.height * 1);
    path.cubicTo(size.width * 0.78, size.height * 1, size.width * 1, size.height * 0.78, size.width * 1, size.height * 0.5);
    path.cubicTo(size.width * 1, size.height * 0.22, size.width * 0.78, 0, size.width * 0.5, 0);
    path.close();

    final phonePath = Path();
    phonePath.moveTo(size.width * 0.33, size.height * 0.33);
    phonePath.cubicTo(size.width * 0.35, size.height * 0.30, size.width * 0.40, size.height * 0.30, size.width * 0.43, size.height * 0.33);
    phonePath.lineTo(size.width * 0.48, size.height * 0.38);
    phonePath.cubicTo(size.width * 0.51, size.height * 0.41, size.width * 0.51, size.height * 0.46, size.width * 0.48, size.height * 0.49);
    phonePath.lineTo(size.width * 0.46, size.height * 0.51);
    phonePath.cubicTo(size.width * 0.50, size.height * 0.58, size.width * 0.56, size.height * 0.64, size.width * 0.63, size.height * 0.67);
    phonePath.lineTo(size.width * 0.65, size.height * 0.64);
    phonePath.cubicTo(size.width * 0.68, size.height * 0.61, size.width * 0.73, size.height * 0.61, size.width * 0.76, size.height * 0.64);
    phonePath.lineTo(size.width * 0.82, size.height * 0.70);
    phonePath.cubicTo(size.width * 0.85, size.height * 0.73, size.width * 0.85, size.height * 0.77, size.width * 0.82, size.height * 0.80);
    phonePath.cubicTo(size.width * 0.77, size.height * 0.85, size.width * 0.67, size.height * 0.84, size.width * 0.54, size.height * 0.78);
    phonePath.cubicTo(size.width * 0.40, size.height * 0.71, size.width * 0.30, size.height * 0.61, size.width * 0.25, size.height * 0.50);
    phonePath.cubicTo(size.width * 0.21, size.height * 0.40, size.width * 0.21, size.height * 0.32, size.width * 0.33, size.height * 0.33);
    phonePath.close();

    final backgroundPaint = Paint()
      ..color = const Color(0xFF25D366)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
    canvas.drawPath(phonePath, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}