import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/presentation/widgets/internal_company_card.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_switch.dart';

class CompanyFaqConfigPage extends StatelessWidget {
  const CompanyFaqConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO[API REQUIRED] : inject bloc here
    return _CompanyFaqConfigView();
  }
}

class _CompanyFaqConfigView extends StatelessWidget {
  const _CompanyFaqConfigView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: AdaptiveSplitColumn(
                leftChildren: _leftChildren(),
                rightChildren: _rightChildren(context))));
  }

  List<Widget> _leftChildren() {
    return [
      Hero(
        tag: "company-card",
        child: InternalCompanyCard(),
      ),
      const SizedBox(
        height: AppSpacing.sm,
      ),
      HorizontalSwitch(
          leadingIcon: Icons.chat_bubble_outline_outlined,
          title: "Aktifkan fitur tanya jawab",
          description:
              "Saat diaktifkan, pelanggan dapat menggunakan fitur tanya jawab untuk membantu menjawab pertanyaan mereka",
          value: false,
          onChanged: (_) {}),
      const SizedBox(
        height: AppSpacing.sm,
      )
    ];
  }

  List<Widget> _rightChildren(BuildContext context) {
    return [
      DashedButton(
        title: "Unggah Berkas Basis Pengetahuan",
        icon: Icons.upload_outlined,
        onTap: () {},
        height: 200,
        color: Theme.of(context).colorScheme.primary,
        borderColor: Theme.of(context).disabledColor,
      )
    ];
  }
}
