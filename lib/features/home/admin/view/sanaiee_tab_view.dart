import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/sanaiee_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../cubit/sanaiee_cubit/sanaiee_cubit.dart';
import '../cubit/sanaiee_cubit/sanaiee_state.dart';
import 'package:moghtarib/features/home/admin/view/sanaiee_details_view.dart';
// class SanaieeTabView extends StatefulWidget {
//   const SanaieeTabView({super.key});

//   @override
//   State<SanaieeTabView> createState() => _UsersTabViewState();
// }

// class _UsersTabViewState extends State<SanaieeTabView> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     context.read<SanaieeCubit>().fetchSanaiee();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(16),
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFF6A11CB),
//                 Color(0xFF2575FC),
//               ],
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'All Sanaieeia',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               // TextField(
//               //   controller: _controller,
//               //   onChanged: (v) {
//               //     context.read<SanaieeCubit>().fetchUsers(searchText: v);
//               //     setState(() {});
//               //   },
//               //   onSubmitted: (v) {
//               //     context.read<SanaieeCubit>().fetchUsers(searchText: v);
//               //   },
//               //   decoration: InputDecoration(
//               //     hintText: 'Search by name',
//               //     filled: true,
//               //     fillColor: Colors.white.withOpacity(0.15),
//               //     prefixIcon: const Icon(Icons.search, color: Colors.white),
//               //     suffixIcon: _controller.text.isNotEmpty
//               //         ? IconButton(
//               //             onPressed: () {
//               //               _controller.clear();
//               //               context.read<UsersCubit>().fetchUsers();
//               //               setState(() {});
//               //             },
//               //             icon: const Icon(Icons.clear, color: Colors.white),
//               //           )
//               //         : null,
//               //     enabledBorder: OutlineInputBorder(
//               //       borderRadius: BorderRadius.circular(12),
//               //       borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
//               //     ),
//               //     focusedBorder: OutlineInputBorder(
//               //       borderRadius: BorderRadius.circular(12),
//               //       borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
//               //     ),
//               //   ),
//               //   style: const TextStyle(color: Colors.white),
//               // ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),
//         Expanded(
//           child: BlocBuilder<SanaieeCubit, SanaieeState>(
//             builder: (context, state) {
//               if (state is SanaieeLoading || state is SanaieeInitial) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               if (state is StateError) {
//                 return Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // Text(
//                         //   // state.message,
//                         //   // textAlign: TextAlign.center,
//                         //   // style: const TextStyle(color: Colors.white),
//                         // ),
//                         // const SizedBox(height: 12),
//                         ElevatedButton(
//                           onPressed: () => context.read<SanaieeCubit>().fetchSanaiee(),
//                           child: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }

//          final List<SanaieeModel> users = state is SanaieeLoaded 
//             ? state.sanaiee 
//                : <SanaieeModel>[];
//               if (users.isEmpty) {
//                 return const Center(
//                   child: Text(
//                     'No users found',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 );
//               }

//               return ListView.separated(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: users.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 12),
//                 itemBuilder: (context, index) {
//                   final SanaieeModel user = users[index];
//                   final String id = user.id; // ✨ سيقرأ الـ id السليم الآن بفضل تعديل الموديل الخاص بكِ
                  
//                   final String rawName = user.userName ?? '${user.firstName ?? ""} ${user.lastName ?? ""}'.trim();
//                   final String displayName = rawName.isNotEmpty ? rawName : 'No Name';
//                   final String? email = user.email;

//                   // ✨ تم التغليف بـ GestureDetector لفتح صفحة التفاصيل عند الضغط على الكارت
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => SanaieeDetailsView(user: user),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.08),
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(color: Colors.white.withOpacity(0.12)),
//                       ),
//                       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   displayName,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 if (email != null && email.isNotEmpty)
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 6),
//                                     child: Text(
//                                       email,
//                                       style: TextStyle(color: Colors.white.withOpacity(0.8)),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                           // IconButton(
//                           //   tooltip: 'Delete',
//                           //   onPressed: () {
//                           //     print("🚨🚨 BUTTON CLICKED! User Name: ${user.userName}, Core ID is: ${user.id}");
//                           //     // ✨ الحذف سيعمل بشكل ممتاز الآن ولن يرسل قيمة 0 مجدداً
//                           //     context.read<SanaieeCubit>().deleteUser(userId: id);
//                           //   },
//                           //   icon: const Icon(Icons.delete_forever, color: Colors.white),
//                           // ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//    );
//   }
// }


class SanaieeTabView extends StatefulWidget {
  const SanaieeTabView({super.key});

  @override
  State<SanaieeTabView> createState() => _UsersTabViewState();
}

class _UsersTabViewState extends State<SanaieeTabView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SanaieeCubit>().fetchSanaiee();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF6A11CB),
                Color(0xFF2575FC),
              ],
            ),
          ),
          child: const Column( // ✨ تم إصلاح مشكلة child: Column القديمة هنا بجعلها مستقرة ونظيفة
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'All Sanaieeia',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: BlocBuilder<SanaieeCubit, SanaieeState>(
            builder: (context, state) {
              if (state is SanaieeLoading || state is SanaieeInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is StateError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () => context.read<SanaieeCubit>().fetchSanaiee(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final List<SanaieeModel> users = state is SanaieeLoaded 
                  ? state.sanaiee 
                  : <SanaieeModel>[];
                  
              if (users.isEmpty) {
                return const Center(
                  child: Text(
                    'No users found',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final SanaieeModel user = users[index];
                  final String rawName = user.userName ?? '${user.firstName ?? ""} ${user.lastName ?? ""}'.trim();
                  final String displayName = rawName.isNotEmpty ? rawName : 'No Name';
                  final String? email = user.email;

                  return GestureDetector(
                    onTap: () {
                      // 💡 تعديل الانتقال لحقن الـ Cubit داخل شاشة التفاصيل بسلام لمنع الشاشة الحمراء
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (newContext) => BlocProvider.value(
                            value: context.read<SanaieeCubit>(), // تمرير الـ Cubit الحالي الممتد من الـ Tab الرئيسي
                            child: SanaieeDetailsView(user: user),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.12)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (email != null && email.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      email,
                                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}