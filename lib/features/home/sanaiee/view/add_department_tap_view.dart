import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/department_cubit/department_cubit.dart'; 
import '../cubit/department_cubit/department_state.dart'; 
class AddDepartmentTabView extends StatefulWidget {
  const AddDepartmentTabView({super.key});

  @override
  State<AddDepartmentTabView> createState() => _AddDepartmentTabViewState();
}

class _AddDepartmentTabViewState extends State<AddDepartmentTabView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DepartmentCubit, DepartmentState>(
      listener: (context, state) {
        if (state is DepartmentSuccess) {
          _controller.clear(); 
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Department added successfully"), 
              backgroundColor: Colors.green
            ),
          );
        } else if (state is DepartmentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error), 
              backgroundColor: Colors.red
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Department",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Department name",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6A11CB), Color(0xFF2575FC)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, 
                  shadowColor: Colors.transparent
                ),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                  
                    context.read<DepartmentCubit>().sendDepartment(_controller.text);
                  } 
                  
                },
                child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}