import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/admin/cubit/reports_cubit/reports_cubit.dart';
import 'package:moghtarib/features/home/admin/cubit/reports_cubit/reports_state.dart';
import 'package:moghtarib/features/home/admin/view/report_details_view.dart';
class ReportsTabView extends StatelessWidget {
  const ReportsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        int reportCount = (state is GetReportsSuccessState) ? state.reports.length : 0;

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
                        Text("All Reports", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text("Review user reports and support requests.", style: TextStyle(color: Colors.white70, fontSize: 12)),
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

  Widget _buildBody(BuildContext context, ReportState state) {
    if (state is GetReportsLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is GetReportsSuccessState) {
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
            child: Material(
              color: Colors.transparent,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportDetailsView(report: report),
                    ),
                  );
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  report.user?.userName ?? "Unknown",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    report.text ?? "No message",
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                trailing: Builder(
                  builder: (BuildContext innerContext) {
                    return IconButton(
                      icon: const Icon(Icons.delete_forever, color: Colors.white),
                      onPressed: () {
                        
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text("Delete Report"),
                            content: const Text("Are you sure you want to delete this report?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  // استخدام الـ innerContext الصحيح الذي يرى الـ Provider
                                  innerContext.read<ReportCubit>().deleteReport(report.id.toString());
                                  Navigator.pop(dialogContext);
                                },
                                child: const Text("Delete", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    }

    if (state is GetReportsErrorState) {
      return Center(child: Text(state.error, style: const TextStyle(color: Colors.red)));
    }

    return const SizedBox();
  }
}
