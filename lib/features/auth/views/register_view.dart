

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/core/utils/app_colors.dart';
import 'package:moghtarib/core/widgets/default_text_field.dart';

import 'package:moghtarib/features/auth/cubit/register/register_cubit.dart';
import 'package:moghtarib/features/auth/cubit/register/register_state.dart';

import 'package:moghtarib/core/routes/app_routes.dart';






class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // 💡 تم حذف المتغيرات وقائمة الـ roles من هنا ونقلها للـ Cubit لضمان الـ State Management السليم

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account Created Successfully'), backgroundColor: Colors.green),
            );
            // goTo(context, MainWrapper(), NavigatorType.pushReplacement);
          }
          if (state is RegisterErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);

          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: SafeArea(
              // 💡 تم الإبقاء على SingleChildScrollView واحدة فقط لمنع الـ Layout Crash
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Create an\naccount',
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, height: 1.3, color: AppColors.white),
                      ),
                      const SizedBox(height: 30),
                  
                      TextFormField(
                        controller: _userNameController,
                        keyboardType: TextInputType.name,
                        decoration: _inputDecoration(hint: 'Enter user name', icon: Icons.person),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _firstNameController,
                        keyboardType: TextInputType.name,
                        decoration: _inputDecoration(hint: 'Enter first Name', icon: Icons.person),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _lastNameController,
                        keyboardType: TextInputType.name,
                        decoration: _inputDecoration(hint: 'Enter last Name', icon: Icons.person),
                      ),
                      const SizedBox(height: 16),
                  
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration(hint: 'Email', icon: Icons.email),
                      ),
                      const SizedBox(height: 16),
                  
                      TextFormField(
                        controller: _passwordController,
                        obscureText: cubit.isPasswordHidden,
                        decoration: _inputDecoration(
                          hint: 'Password',
                          icon: Icons.lock,
                          suffix: IconButton(
                            icon: Icon(cubit.isPasswordHidden ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                            onPressed: () => cubit.changePasswordVisibility(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                  
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: cubit.isConfirmPasswordHidden,
                        decoration: _inputDecoration(
                          hint: 'Confirm Password',
                          icon: Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(cubit.isConfirmPasswordHidden ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                            onPressed: () => cubit.changeConfirmPasswordVisibility(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      DefaultTextField(
                        controller: _nationalIdController,
                        hintText: 'Enter National ID',
                      ),
                      const SizedBox(height: 16),
                      
                      // 💡 الـ DropdownButtonFormField المطور والمربوط بالـ Cubit مباشرة
                      DropdownButtonFormField<String>(
                        value: cubit.selectedRole, // القيمة تأتي من الـ Cubit
                        hint: const Text('Select role', style: TextStyle(color: Colors.grey)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        // قائمة الأدوار المحددة في الـ Cubit (بدون عنصر 'select role' لتجنب المشاكل)
                        items: ['Admin', 'Student', 'Sanaiee', 'Semsar'].map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role, style: const TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            cubit.changeSelectedRole(newValue); // دالة التغيير بداخل الـ Cubit
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Role is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration(hint: 'Enter Phone number', icon: Icons.phone),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _whatsappController,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration(hint: 'Enter WhatsApp number', icon: Icons.phone),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'By clicking the Register button, you agree to the public offer',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                      const SizedBox(height: 16),

                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.login);
                          },
                          child: const Text(
                            'Already have an account? Login',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),



                  
                      SizedBox(
                        width: 317,
                        height: 55,
                        child: state is RegisterLoadingState
                            ? const Center(child: CircularProgressIndicator(color: Color(0xFFF83758)))
                            : ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    cubit.userRegister(
                                      username: _userNameController.text,
                                      firstname: _firstNameController.text,
                                      lastname: _lastNameController.text,
                                      nationalid: _nationalIdController.text,
                                      role: cubit.selectedRole ?? '', // القيمة تُرسل من الـ Cubit
                                      phonenumber: _phoneController.text,
                                      password: _passwordController.text,
                                      email: _emailController.text,
                                      whatsappnumber: _whatsappController.text,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Create Account',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
// class RegisterView extends StatelessWidget {
//     RegisterView({super.key});

//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _userNameController = TextEditingController();
//    final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _WhatsappController = TextEditingController();
//   final TextEditingController _NationalidController = TextEditingController();
//    final TextEditingController _roleController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
  
  
// // المتغير اللي هيتخزن فيه الدور المختار
// String? selectedRole;

// // قائمة الأدوار المتاحة
// final List<String> roles = ['select role','Admin', 'Student', 'Sanaiee','Semsar'];

// // final TextEditingController _roleController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (BuildContext context) => RegisterCubit(),
//       child: BlocConsumer<RegisterCubit, RegisterStates>(
//         listener: (context, state) {
//           if (state is RegisterSuccessState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Account Created Successfully'), backgroundColor: Colors.green),);
//               // goTo(context,MainWrapper(),NavigatorType.pushReplacement);
            
          
//           }
//           if (state is RegisterErrorState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.error), backgroundColor: Colors.red),
//             );
//           }
//         },
//         builder: (context, state) {
//           var cubit = RegisterCubit.get(context);

//           return Scaffold(
//             backgroundColor:AppColors.scaffoldBackground,
//             // appBar: AppBar(
//             //   backgroundColor: Colors.white,
//             //   elevation: 0,
//             //   leading: IconButton(
//             //     icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
//             //     onPressed: () => goTo(context, GetStartedView(),NavigatorType.pushReplacement),
//             //   ),
//             // ),
//             body: SafeArea(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Form(
//                   key: _formKey,
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 10),
//                         const Text(
//                           'Create an\naccount',
//                           style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, height: 1.3 ,color: AppColors.white),
//                         ),
//                         const SizedBox(height: 30),
                    
//                         TextFormField(
//                           controller: _userNameController,
//                           keyboardType: TextInputType.name,
//                           decoration: _inputDecoration(hint: 'Enter user name', icon: Icons.person),
//                         ),
//                         const SizedBox(height: 16),

//                         TextFormField(
//                           controller: _firstNameController,
//                           keyboardType: TextInputType.name,
//                           decoration: _inputDecoration(hint: 'Enter first Name', icon: Icons.person),
//                         ),
//                         const SizedBox(height: 16),

//                         TextFormField(
//                           controller: _lastNameController,
//                           keyboardType: TextInputType.name,
//                           decoration: _inputDecoration(hint: 'Enter last Name', icon: Icons.person),
//                         ),
//                         const SizedBox(height: 16),
                    
                      
//                         TextFormField(
//                           controller: _emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           decoration: _inputDecoration(hint: 'Email', icon: Icons.email),
//                         ),
//                         const SizedBox(height: 16),
                    
                        
//                         TextFormField(
//                           controller: _passwordController,
//                           obscureText: cubit.isPasswordHidden,
//                           decoration: _inputDecoration(
//                             hint: 'Password',
//                             icon: Icons.lock,
//                             suffix: IconButton(
//                               icon: Icon(cubit.isPasswordHidden ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
//                               onPressed: () => cubit.changePasswordVisibility(),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
                    
                        
//                         TextFormField(
//                           controller: _confirmPasswordController,
//                           obscureText: cubit.isConfirmPasswordHidden,
//                           decoration: _inputDecoration(
//                             hint: 'Confirm Password',
//                             icon: Icons.lock_outline,
//                             suffix: IconButton(
//                               icon: Icon(cubit.isConfirmPasswordHidden ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
//                               onPressed: () => cubit.changeConfirmPasswordVisibility(),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         DefaultTextField(
//                           controller: _NationalidController,
//                           hintText:'Enter National ID',
//                           // decoration: _inputDecoration(hint: 'Enter National ID', icon: ),
//                           // decoration:InputDecoration(
//                           //   filled: true,
//                           //   fillColor: Colors.grey.shade100,
//                           //   border: OutlineInputBorder(
//                           //     borderRadius: BorderRadius.circular(10),
//                           //     borderSide: BorderSide.none,
//                           //   ),
//                           // );
//                         ),
//                         const SizedBox(height: 16),
//                            DropdownButtonFormField<String>(
//         value: selectedRole,
       
//       hint: const Text('Select role'),
      
//       decoration:
//        InputDecoration(filled: true,
//       fillColor: Colors.grey.shade100,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide.none,
//       ),
    
//         // contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         // border: OutlineInputBorder(
//         //   borderRadius: BorderRadius.circular(10),
//         //   borderSide: const BorderSide(color: Colors.grey),
//         // ),
//         // enabledBorder: OutlineInputBorder(
//         //   borderRadius: BorderRadius.circular(10),
//         //   borderSide: const BorderSide(color: Colors.grey),
//         // ),
//         // focusedBorder: OutlineInputBorder(
//         //   borderRadius: BorderRadius.circular(10),
//         //   borderSide: const BorderSide(color: Colors.grey, width: 2),
//         // ),
//         // errorBorder: OutlineInputBorder(
//         //   borderRadius: BorderRadius.circular(8),
//         //   borderSide: const BorderSide(color: Colors.red, width: 1),
//         // ),
//       ),
//       icon: const Icon(Icons.keyboard_arrow_down),
//       items: roles.map((String role) {
//         return DropdownMenuItem<String>(
//           value: role,
//           child: Text(role),
//         );
//       }).toList(),
//       onChanged: (String? newValue) {
//         // setState(() {
//           selectedRole = newValue;
//         // });
//       },
//       // الجزء المسؤول عن إظهار "Role is required"
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Role is required';
//         }
//         return null;
//       },
//     ),
//                         const SizedBox(height: 16),
//                          TextFormField(
//                           controller: _phoneController,
//                           keyboardType: TextInputType.phone,
//                           decoration: _inputDecoration(hint: 'Enter Phone number', icon: Icons.phone),
//                         ),
                        
//                        const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _WhatsappController,
//                           keyboardType: TextInputType.phone,
//                           decoration: _inputDecoration(hint: 'Enter WhatsApp number', icon: Icons.phone),
//                         ),
//                         const SizedBox(height: 24),
                    
                        
//                         Text(
//                           'By clicking the Register button, you agree to the public offer',
//                           style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//                         ),
//                         const SizedBox(height: 30),
                    
                        
//                         SizedBox(
//                           width:317,
//                           height: 55,
//                           child: state is RegisterLoadingState
//                               ? const Center(child: CircularProgressIndicator(color: Color(0xFFF83758)))
//                               :
//                                ElevatedButton(
//                                   onPressed: () {
//                                     if (_formKey.currentState!.validate()) {
//                                       cubit.userRegister(
//                                         username: _userNameController.text,
//                                         firstname: _firstNameController.text,
//                                         lastname: _lastNameController.text,
//                                         nationalid: _NationalidController.text,
//                                        role: selectedRole ?? '',
//                                         phonenumber: _phoneController.text,
//                                         password: _passwordController.text,
//                                         email: _emailController.text,
//                                         whatsappnumber: _WhatsappController.text,
//                                       );
//                                     }
                                    
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor:AppColors.primary,
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                     elevation: 0,
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal:8,vertical: 16 ),
//                                     child: const Text(
//                                       'Create Account',
//                                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

  
//   InputDecoration _inputDecoration({required String hint, required IconData icon, Widget? suffix}) {
//     return InputDecoration(
//       hintText: hint,
//       prefixIcon: Icon(icon, color: Colors.grey),
//       suffixIcon: suffix,
//       filled: true,
//       fillColor: Colors.grey.shade100,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide.none,
//       ),
//     );
//   }
// }