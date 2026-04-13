import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_approve.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_reject.dart';

class FabGroupWorkOrderApproval extends StatelessWidget {
  const FabGroupWorkOrderApproval({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FabWorkOrderReject(onPressed: () {}),
        SizedBox(width: 10),
        FabWorkOrderApprove(onPressed: () {})
      ],
    );
  }
}
