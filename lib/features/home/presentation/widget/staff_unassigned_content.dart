import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class StaffUnassignedContent extends StatelessWidget {
  const StaffUnassignedContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.md),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 150,
              child: SvgPicture.asset(
                "assets/images/jobless.svg",
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
              ),
            ),
          ),
          const SizedBox(
            height: AppSpacing.md,
          ),
          InformationBlock.warning(
              "Saat ini anda belum tergabung ke perusahaan manapun"),
          Row(
            children: [
              Spacer(),
              TextButton.icon(
                onPressed: () {
                  context.go(AppRoutes.invitationsPending);
                },
                iconAlignment: IconAlignment.end,
                label: Text("Pantau Undangan Masuk"),
                icon: Icon(AppIcon.next),
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          HorizontalButton(
            leadingIcon: AppIcon.memberCode,
            title: "Bergabung dengan kode",
            description:
                "Anda bisa menggunakan kode yang disediakan oleh provider untuk bergabung ke perusahaan",
                onTap: () => context.push(AppRoutes.claimInvitationCode),
          )
        ]);
  }
}
