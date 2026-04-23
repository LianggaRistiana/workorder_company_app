import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/presentation/widgets/internal_company_card.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

enum CompanyFlowTypeAfterProfile {
  none,
  serviceOnly,
  faqOnly,
  serviceFirst,
  faqFirst,
  serviceAndFaq
}

class InternalCompanyConfigFlow extends StatefulWidget {
  const InternalCompanyConfigFlow({super.key});

  @override
  State<InternalCompanyConfigFlow> createState() =>
      _InternalCompanyConfigFlowState();
}

class _InternalCompanyConfigFlowState extends State<InternalCompanyConfigFlow> {
  CompanyFlowTypeAfterProfile _selectedFlow = CompanyFlowTypeAfterProfile.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: AdaptiveSplitColumn(
          leftChildren: _leftChildren(context),
          rightChildren: _rightChildren(context),
        ),
      ),
    );
  }

  List<Widget> _leftChildren(BuildContext context) {
    return [
      Hero(
        tag: "company-card",
        child: InternalCompanyCard(),
      ),
      const SizedBox(height: AppSpacing.md),
    ];
  }

  List<Widget> _rightChildren(BuildContext context) {
    return [
      PropertyTitle(
        label: "Alur bisnis",
        icon: AppIcon.flowBusiness,
      ),
      const SizedBox(height: AppSpacing.sm),
      _FlowStep(
        number: "1",
        showLine: true,
        locked: true,
        child: PropertyTitle(
          label: "Profile Perusahaan",
          icon: AppIcon.info,
        ),
      ),
      _buildFlow(),
      if (_selectedFlow == CompanyFlowTypeAfterProfile.none)
        DashedButton(
          height: 60,
          onTap: () async {
            final result = await _showFlowSelector(context);

            if (result != null) {
              setState(() {
                _selectedFlow = result;
              });
            }
          },
          borderColor: Theme.of(context).colorScheme.primary,
          color: Theme.of(context).colorScheme.primary,
          title: "Konfigurasi alur selanjutnya",
        )
      else ...[
        const SizedBox(height: AppSpacing.md),
        TextButton.icon(
          icon: Icon(AppIcon.edit),
          onPressed: () async {
            final result = await _showFlowSelector(context);

            if (result != null) {
              setState(() {
                _selectedFlow = result;
              });
            }
          },
          label: Text("Edit"),
        )
      ]
    ];
  }

  Widget _buildFlow() {
    switch (_selectedFlow) {
      case CompanyFlowTypeAfterProfile.none:
        return const SizedBox();
      case CompanyFlowTypeAfterProfile.serviceOnly:
        return const _ServiceOnlyFlow();
      case CompanyFlowTypeAfterProfile.faqOnly:
        return const _FaqOnlyFlow();
      case CompanyFlowTypeAfterProfile.serviceFirst:
        return const _ServiceFirstFlow();
      case CompanyFlowTypeAfterProfile.faqFirst:
        return const _FaqFirstFlow();
      case CompanyFlowTypeAfterProfile.serviceAndFaq:
        return const _ServiceAndFaqFlow();
    }
  }
}

Future<CompanyFlowTypeAfterProfile?> _showFlowSelector(
  BuildContext context,
) {
  return showModalBottomSheet<CompanyFlowTypeAfterProfile>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return AppBottomSheet(
        header: Text(
          "Pilih Alur Bisnis",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: CompanyFlowTypeAfterProfile.values.map((flow) {
            return _FlowOptionTile(
              flow: flow,
              onTap: () {
                Navigator.pop(context, flow);
              },
            );
          }).toList(),
        ),
      );
    },
  );
}

class _FlowOptionTile extends StatelessWidget {
  final CompanyFlowTypeAfterProfile flow;
  final VoidCallback onTap;

  const _FlowOptionTile({
    required this.flow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: IconBox.small(icon: _icon),
      title: Text(_label),
      subtitle: Text(_description),
    );
  }

  String get _label {
    return switch (flow) {
      CompanyFlowTypeAfterProfile.none => "Tidak ada",
      CompanyFlowTypeAfterProfile.serviceOnly => "Layanan saja",
      CompanyFlowTypeAfterProfile.faqOnly => "FAQ saja",
      CompanyFlowTypeAfterProfile.serviceFirst => "Layanan → FAQ",
      CompanyFlowTypeAfterProfile.faqFirst => "FAQ → Layanan",
      CompanyFlowTypeAfterProfile.serviceAndFaq => "Layanan & FAQ (bersamaan)",
    };
  }

  String get _description {
    return switch (flow) {
      CompanyFlowTypeAfterProfile.none => "Tidak ada alur bisnis yang dipilih",
      CompanyFlowTypeAfterProfile.serviceOnly =>
        "Hanya menyediakan layanan tanpa FAQ",
      CompanyFlowTypeAfterProfile.faqOnly =>
        "Hanya menyediakan FAQ tanpa layanan",
      CompanyFlowTypeAfterProfile.serviceFirst =>
        "User memilih layanan terlebih dahulu",
      CompanyFlowTypeAfterProfile.faqFirst =>
        "User melihat FAQ sebelum layanan",
      CompanyFlowTypeAfterProfile.serviceAndFaq =>
        "User bisa memilih layanan atau FAQ secara bebas",
    };
  }

  IconData get _icon {
    return switch (flow) {
      CompanyFlowTypeAfterProfile.none => Icons.close,
      CompanyFlowTypeAfterProfile.serviceOnly => AppIcon.service,
      CompanyFlowTypeAfterProfile.faqOnly => AppIcon.qna,
      CompanyFlowTypeAfterProfile.serviceFirst => Icons.arrow_downward,
      CompanyFlowTypeAfterProfile.faqFirst => Icons.arrow_upward,
      CompanyFlowTypeAfterProfile.serviceAndFaq => Icons.call_split,
    };
  }
}

class _FlowStep extends StatelessWidget {
  final String number;
  final Widget child;
  final bool showLine;
  final bool locked;

  const _FlowStep({
    required this.number,
    required this.child,
    this.showLine = false,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Text(
                number,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
            if (showLine)
              Container(
                height: 50,
                width: 1,
                color: color,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: CustomCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            margin: EdgeInsets.zero,
            child: Row(
              children: [
                Expanded(child: child),
                if (locked) const Icon(AppIcon.lock),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceAndFaqFlow extends StatelessWidget {
  const _ServiceAndFaqFlow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FlowStep(
            number: "2",
            child: PropertyTitle(
              label: "Layanan",
              icon: AppIcon.service,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: CustomCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            margin: EdgeInsets.zero,
            child: Row(
              children: [
                Expanded(
                    child: PropertyTitle(
                  label: "Tanya Jawab",
                  icon: AppIcon.qna,
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceFirstFlow extends StatelessWidget {
  const _ServiceFirstFlow();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FlowStep(
          number: "2",
          showLine: true,
          locked: false,
          child: PropertyTitle(
            label: "Layanan Perusahaan",
            icon: AppIcon.service,
          ),
        ),
        _FlowStep(
          number: "3",
          child: PropertyTitle(
            label: "Tanya jawab",
            icon: AppIcon.qna,
          ),
        ),
      ],
    );
  }
}

class _FaqFirstFlow extends StatelessWidget {
  const _FaqFirstFlow();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FlowStep(
          number: "2",
          showLine: true,
          locked: false,
          child: PropertyTitle(
            label: "Tanya jawab",
            icon: AppIcon.qna,
          ),
        ),
        _FlowStep(
          number: "3",
          child: PropertyTitle(
            label: "Layanan Perusahaan",
            icon: AppIcon.service,
          ),
        ),
      ],
    );
  }
}

class _ServiceOnlyFlow extends StatelessWidget {
  const _ServiceOnlyFlow();

  @override
  Widget build(BuildContext context) {
    return _FlowStep(
      number: "2",
      child: PropertyTitle(
        label: "Layanan Perusahaan",
        icon: AppIcon.service,
      ),
    );
  }
}

class _FaqOnlyFlow extends StatelessWidget {
  const _FaqOnlyFlow();

  @override
  Widget build(BuildContext context) {
    return _FlowStep(
      number: "2",
      child: PropertyTitle(
        label: "Tanya jawab",
        icon: AppIcon.qna,
      ),
    );
  }
}
