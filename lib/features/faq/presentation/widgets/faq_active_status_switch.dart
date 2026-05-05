import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/toggle_active/toggle_active_faq_cubit.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/toggle_active/toggle_active_faq_state.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_switch.dart';

class FaqActiveStatusSwitch extends StatelessWidget {
  const FaqActiveStatusSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToggleActiveFaqCubit, ToggleActiveFaqState>(
        buildWhen: (prev, curr) => prev.isActive != curr.isActive,
        builder: (context, state) {
          final isActive = state.isActive;

          return HorizontalSwitch(
            margin: EdgeInsets.only(
              bottom: AppSpacing.sm,
              left: AppSpacing.md,
              right: AppSpacing.md,
            ),
            leadingIcon: AppIcon.qna,
            title: "Aktifkan fitur tanya jawab",
            description:
                "Saat diaktifkan, pelanggan dapat menggunakan fitur tanya jawab untuk membantu menjawab pertanyaan mereka",
            value: isActive,
            onChanged: (_) {
              context.read<ToggleActiveFaqCubit>().toggleFaq();
            },
          );
        });
  }
}
