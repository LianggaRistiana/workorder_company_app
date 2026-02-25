import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_switch.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class CompanyFaqConfigPage extends StatelessWidget {
  const CompanyFaqConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO : inject bloc here
    return _CompanyFaqConfigView();
  }
}

class _CompanyFaqConfigView extends StatelessWidget {
  const _CompanyFaqConfigView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          children: [
            // Row(
            //   children: [
            //     IconBox(icon: Icons.chat_bubble_outline_outlined),
            //     const SizedBox(width: 12),
            //     Text(
            //       "Konfigurasi Tanya Jawab",
            //       style: Theme.of(context).textTheme.titleLarge,
            //       maxLines: 2,
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //   ],
            // ),
            HorizontalSwitch(
                leadingIcon: Icons.chat_bubble_outline_outlined,
                title: "Aktifkan fitur tanya jawab",
                description:
                    "Saat diaktifkan, pelanggan dapat menggunakan fitur tanya jawab untuk membantu menjawab pertanyaan mereka",
                value: false,
                onChanged: (_) {}),
            const SizedBox(height: 12),
            DashedButton(
              title: "Unggah Berkas Basis Pengetahuan",
              icon: Icons.upload_outlined,
              onTap: () {},
              height: 200,
              color: Theme.of(context).colorScheme.primary,
              borderColor: Theme.of(context).disabledColor,
            )
          ],
        ),
      ),
    );
  }
}
