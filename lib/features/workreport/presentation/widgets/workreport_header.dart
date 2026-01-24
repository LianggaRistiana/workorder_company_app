import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class WorkreportHeader extends StatelessWidget {
  const WorkreportHeader({super.key});

  @override
  Widget build(BuildContext context) {
          return Row(
        children: [
          IconBox(paddingSize: AppSpacing.md, icon: Icons.assignment_outlined),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Laporan",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      );
    // return BlocBuilder<WorkorderDetailCubit, WorkorderDetailState>(
    //     builder: (context, state) {
    //   return Row(
    //     children: [
    //       IconBox(paddingSize: AppSpacing.md, icon: Icons.assignment_outlined),
    //       const SizedBox(width: 12),
    //       Expanded(
    //         child: Text(
    //           "Laporan",
    //           style: Theme.of(context).textTheme.titleLarge,
    //         ),
    //       ),
    //     ],
    //   );
    // }
    // );
  }
}
