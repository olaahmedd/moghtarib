import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/add_report_cubit/add_report_cubit.dart';
import '../cubit/add_report_cubit/add_report_state.dart';

class AddReportTabView extends StatefulWidget {
 final int? apartmentId;
  const AddReportTabView({super.key,  this.apartmentId});

  @override
  State<AddReportTabView> createState() => _AddReportTabViewState();
}

class _AddReportTabViewState extends State<AddReportTabView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddReportCubit, AddReportState>(
      listener: (context, state) {
        if (state is AddReportSuccess) {
          _controller.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Report submitted successfully!"),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AddReportError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
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
              "Send New Report",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter your report details here...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
            
          child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),

onPressed: () {
  if (_controller.text.isNotEmpty) {
    context.read<AddReportCubit>().sendReport(_controller.text, context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("يرجى كتابة التقرير أولاً!"), backgroundColor: Colors.red),
    );
  }
},

                child: const Text("Submit Report", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
        )],
        ),
      ),
    );
  }
}