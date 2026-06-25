import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../cubit/my_report_cubit/my_report_cubit.dart';
import '../cubit/my_report_cubit/my_report_state.dart';
import '../../../../core/cache/cache_helper.dart';
import '../view/my_report_details_view.dart';
class MyReportTabView extends StatelessWidget {
  const MyReportTabView({super.key});

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<MyReportsCubit,MyReportsState>(
      builder: (context, state) {
        int reportCount = (state is MyReportsSuccess) ? state.reports.length : 0;

        return Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("MY Reports", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        const Icon(Icons.description, color: Colors.white, size: 20),
                        Text("Total\n$reportCount", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: _buildBody(context, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, MyReportsState state) {
    if (state is MyReportsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is MyReportsSuccess) {
      if (state.reports.isEmpty) {
        return const Center(child: Text("No reports found", style: TextStyle(color: Colors.grey)));
      }

      return ListView.builder(
        itemCount: state.reports.length,
        itemBuilder: (context, index) {
          final report = state.reports[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: ListTile(
              onTap: () {
               // تأكد من وجود شاشة التفاصيل
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyReportDetailsView(report: report)));
              },
              title: Text(
                // report.userName ?? "Unknown User",
                (report.userName != null && report.userName!.isNotEmpty) 
      ? report.userName! 
      : (CacheHelper.getValue('userName') ?.toString() ?? "Student User"),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                report.text ?? "No message",
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
         
            ),
          );
        },
      );
    }

    if (state is MyReportsError) {
      return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
    }

    return const SizedBox();
  }
}