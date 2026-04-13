import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_complete.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/fab_work_order_fail.dart';

class FabGroupWorkOrderFinalize extends StatelessWidget {
  const FabGroupWorkOrderFinalize({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FabWorkOrderFail(onPressed: () {}),
        SizedBox(width: 10),
        FabWorkOrderComplete(onPressed: () {}),
      ],
    );
  }
}
