import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/utils/todo_strings_helper.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

class StaffUnassignedContent extends StatelessWidget {
  const StaffUnassignedContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InformationBlock.info(
              "Saat ini anda belum tergabung ke perusahaan manapun"),
          const SizedBox(height: 16),
          const SectionTitle("Daftar Undangan"),
          const SizedBox(height: 8),
          ClickableCustomCard(
              child: Row(children: [
                IconBox(icon: Icons.mail_outline_outlined, paddingSize: 8, iconSize: 18),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(TodoText.title("invitation_company_name"),
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1))
              ]),
              onTap: () {})
        ]);
  }
}
