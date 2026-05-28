import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:moghtarib/core/widgets/custom_btn.dart';
// import '../../core/utils/app_assets.dart';
import '../../core/utils/app_colors.dart';

//import 'package:moghtarib/features/auth/views/register_view.dart';


class WelcomeScreen extends StatelessWidget {

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height:514.h,
              //814 514
              child: Image.asset(
                'assets/images/Container.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Container(
                height: 350.h,
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32).r,
                    topRight: Radius.circular(32).r,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 37.h, horizontal: 32.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // العنوان الرئيسي باللون الداكن ليظهر بوضوح
                      Text(
                        'Mo8tareb — Your Home Away From Home',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 25.sp,
                          height: 1.3,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 16.h),
                      
                      // النص التوضيحي الفرعي
                      Text(
                        'Your journey to the perfect student home starts here. Explore verified listings near your university..',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          height: 1.5,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const Spacer(), // لدفع الزر إلى الأسفل بشكل متناسق تلقائياً
                      
                      // 🔥 3️⃣ الـ ElevatedButton الأصيل المصمم من الصفر بداخل الملف
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary, // اللون الأساسي للتطبيق
                          foregroundColor: Colors.white,      // لون تأثير الضغط (Splash) ونص الزر الافتراضي
                          elevation: 0,                       // إلغاء الظل ليكون مسطحاً ومودرن
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14), // مساحة داخلية على حجم الكلمة بالضبط
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // الـ Radius المطلوب (10) ليطابق بقية الحقول
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text(
                          "Let's Start",
                          style: TextStyle(
                            color: Colors.white, // النص أبيض وثابت
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: double.infinity,
//             width: double.infinity,
//             child: Image.asset(
//               AppAssets.building,
//               width: 430.w,
//               height: 538.h,
             
//               alignment: Alignment.topCenter,
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 421.h,
//               width: 430.w,
//               decoration: BoxDecoration(
//                 color: AppColors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(32).r,
//                   topRight: Radius.circular(32).r,
//                 ),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 52.h, horizontal: 32.r),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Get The Latest News And Updates',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 32.sp,
//                         color: AppColors.white,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     // SizedBox(height: 16.h),
//                     Text(
//                       'From Politics to Entertainment: Your One-Stop Source for Comprehensive Coverage of the Latest News and Developments Across the Glob will be right on your hand.',
//                       style: TextStyle(
//                         // height: 1.5,
//                         fontWeight: FontWeight.w400,
//                         fontSize: 18.sp,
//                         color: AppColors.white,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 8.h),
//                     CustomBtn(
//   // الألوان والتنسيق بداخل الـ child الخاص بالزر
//   child: Container(
//     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // لجعل الحجم على قد الكلمة بالضبط مع مساحة مريحة
//     decoration: BoxDecoration(
//       color: AppColors.primary, // اللون الأساسي للتطبيق
//       borderRadius: BorderRadius.circular(10), // الـ Radius المطلوب لتطابق بقية الحقول
//     ),
//     child: const Text(
//       "Let's Start",
//       style: TextStyle(
//         color: Colors.white, // النص أبيض
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//       ),
//     ),
//   ),
//   onPressed: () {
//     // تصحيح طريقة التنقل الـ Navigation الاحترافية في فلاتر
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => RegisterView()),
//     );
//   },
// ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }