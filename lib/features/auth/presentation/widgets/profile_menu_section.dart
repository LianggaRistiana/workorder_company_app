import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/notification/presentation/widgets/notification_toggle.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_switch.dart';
import 'package:workorder_company_app/shared/widgets/info_bottom_sheet.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const NotificationToggle(),

        HorizontalSwitch(
          title: "Petunjuk",
          leadingIcon: Icons.info_outline,
          description:
              "Tampilkan petunjuk penggunaan aplikasi Anda",
          value: false,
          onChanged: (_) {},
        ),

        HorizontalButton(
          title: "Coba versi website",
          leadingIcon: Icons.public,
          description:
              "Versi website disarankan untuk penggunaan desktop",
          onTap: () {
            showAppBottomSheet(
              context,
              content: const SizedBox(
                height: 200,
                child: Center(
                  child: Text("Fitur ini belum tersedia"),
                ),
              ),
            );
          },
        ),

        HorizontalButton(
          title: "Bantuan",
          leadingIcon: Icons.help_outline,
          description:
              "Cari bantuan Anda di sini mengenai cara menggunakan aplikasi",
          onTap: () {
            showAppBottomSheet(
              context,
              content: const SizedBox(
                height: 200,
                child: Center(
                  child: Text("Fitur ini belum tersedia"),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}