import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class StaffUnassignedContent extends StatelessWidget {
  const StaffUnassignedContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InformationBlock.info(
              "Saat ini anda belum tergabung ke perusahaan manapun"),
          // TODO : add svg illustrator here
        ]);
  }
}
