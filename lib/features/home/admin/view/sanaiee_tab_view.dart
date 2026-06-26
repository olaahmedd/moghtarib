import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/sanaiee_model.dart';
import '../cubit/sanaiee_cubit/sanaiee_cubit.dart';
import '../cubit/sanaiee_cubit/sanaiee_state.dart';
import 'package:moghtarib/features/home/admin/view/sanaiee_details_view.dart';
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
          child: const Column( 
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (newContext) => BlocProvider.value(
                            value: context.read<SanaieeCubit>(), 
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
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      email,
                                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
                                    ),
                                  ),
                                
                                const SizedBox(height: 8),

                               
                                if (user.departmentName != null && user.departmentName!.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2575FC).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xFF2575FC).withOpacity(0.3)),
                                    ),
                                    child: Text(
                                      user.departmentName!, 
                                      style: const TextStyle(
                                        color: Color(0xFF2575FC),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                else
                                  
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      user.departmentId != null && user.departmentId != "0"
                                          ? 'Department ID: ${user.departmentId}'
                                          : 'No Department',
                                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Colors.white.withOpacity(0.4),
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