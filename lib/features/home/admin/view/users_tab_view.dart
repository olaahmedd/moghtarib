import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/user_model.dart';
import '../view/user_details_view.dart';
import '../cubit/users_cubit/users_cubit.dart';
import '../cubit/users_cubit/users_state.dart';
class UsersTabView extends StatefulWidget {
  const UsersTabView({super.key});

  @override
  State<UsersTabView> createState() => _UsersTabViewState();
}

class _UsersTabViewState extends State<UsersTabView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UsersCubit>().fetchUsers();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'All Users',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                onChanged: (v) {
                  context.read<UsersCubit>().fetchUsers(searchText: v);
                  setState(() {});
                },
                onSubmitted: (v) {
                  context.read<UsersCubit>().fetchUsers(searchText: v);
                },
                decoration: InputDecoration(
                  hintText: 'Search by name',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.15),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _controller.clear();
                            context.read<UsersCubit>().fetchUsers();
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear, color: Colors.white),
                        )
                      : null,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: BlocBuilder<UsersCubit, UsersState>(
            builder: (context, state) {
              if (state is UsersLoading || state is UsersInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is UsersError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context.read<UsersCubit>().fetchUsers(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final List<UserModel> users = state is UsersLoaded
                  ? state.users
                  : state is UserDeleting
                      ? state.users
                      : state is UserDeleted
                          ? state.users
                          : <UserModel>[];

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
                  final UserModel user = users[index];
                  final String id = user.id; 
                  
                  final String rawName = user.userName ?? '${user.firstName ?? ""} ${user.lastName ?? ""}'.trim();
                  final String displayName = rawName.isNotEmpty ? rawName : 'No Name';
                  final String? email = user.email;


                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsView(user: user),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha:0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha:0.12)),
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
                          IconButton(
                            tooltip: 'Delete',
                            onPressed: () {
                              print("🚨🚨 BUTTON CLICKED! User Name: ${user.userName}, Core ID is: ${user.id}");
                              
                              context.read<UsersCubit>().deleteUser(userId: id);
                            },
                            icon: const Icon(Icons.delete_forever, color: Colors.white),
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





