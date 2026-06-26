import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/core/utils/app_colors.dart';
import 'package:moghtarib/features/auth/cubit/register/register_cubit.dart';
import 'package:moghtarib/features/auth/cubit/register/register_state.dart';

import 'package:moghtarib/core/routes/app_routes.dart';
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
  String? _selectedDepartmentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit()..getDepartmentsData(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account Created Successfully'), 
                backgroundColor: Colors.green,
              ),
            );

            final cubit = RegisterCubit.get(context);
            final normalizedRole = (cubit.selectedRole ?? '').toLowerCase();

            String nextRoute;
            switch (normalizedRole) {
              case 'admin':
                nextRoute = AppRoutes.adminHome;
                break;
              case 'student':
                nextRoute = AppRoutes.studentHome;
                break;
              case 'semsar':
                nextRoute = AppRoutes.semsarHome;
                break;
              case 'sanaiee':
                nextRoute = AppRoutes.sanaieeHome;
                break;
              default:
                nextRoute = AppRoutes.welcome;
            }

            Navigator.pushNamedAndRemoveUntil(context, nextRoute, (route) => false);
          }
          
          if (state is RegisterErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
          
          if (state is RegisterGetDepartmentsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('خطأ في تحميل المهن: ${state.error}'), backgroundColor: Colors.orange),
            );
          }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);

          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: SafeArea(
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
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, height: 1.3, color: Colors.white),
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
                      
                      TextFormField(
                        controller: _nationalIdController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(hint: 'Enter National ID', icon: Icons.badge),
                      ),
                      const SizedBox(height: 16),
                      
                      
                      DropdownButtonFormField<String>(
                        value: cubit.selectedRole,
                        hint: const Text('Select role', style: TextStyle(color: Colors.grey)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        items: ['Admin', 'Student', 'Sanaiee', 'Semsar'].map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role, style: const TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            cubit.changeSelectedRole(newValue);
                            if (newValue != 'Sanaiee') {
                              setState(() {
                                _selectedDepartmentId = null;
                              });
                            }
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Role is required';
                          }
                          return null;
                        },
                      ),
                      if (cubit.selectedRole == 'Sanaiee') ...[
                        const SizedBox(height: 16),
                        state is RegisterGetDepartmentsLoadingState
                            ? const Center(child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(color: Colors.white),
                              ))
                            : DropdownButtonFormField<String>(
                                value: _selectedDepartmentId,
                                hint: const Text('Choose your department ', style: TextStyle(color: Colors.grey)),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                               
                                items: cubit.departments.map((dept) {
                                  return DropdownMenuItem<String>(
                                    value: dept['id'].toString(), 
                                    child: Text(dept['name'] ?? '', style: const TextStyle(color: Colors.black)),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedDepartmentId = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (cubit.selectedRole == 'Sanaiee' && value == null) {
                                    return 'Please select your department';
                                  }
                                  return null;
                                },
                              ),
                      ],
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
                        width: double.infinity, 
                        height: 55,
                        child: state is RegisterLoadingState
                            ? const Center(child: CircularProgressIndicator(color: Color(0xFFF83758)))
                            : Container( 
                                width: double.infinity,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF2575FC).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                               
onPressed: () {
  if (_formKey.currentState!.validate()) {
    cubit.userRegister(
      username: _userNameController.text,
      firstname: _firstNameController.text,
      lastname: _lastNameController.text,
      nationalid: _nationalIdController.text,
      role: cubit.selectedRole ?? '', 
      phonenumber: _phoneController.text,
      password: _passwordController.text,
      email: _emailController.text,
      whatsappnumber: _whatsappController.text,
      
      departmentId: cubit.selectedRole == 'Sanaiee' ? _selectedDepartmentId : null, 
    );
  }
},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Create Account',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
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