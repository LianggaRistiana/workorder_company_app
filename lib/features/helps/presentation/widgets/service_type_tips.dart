import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/info_item.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class ServiceAccessTypeTips extends StatelessWidget {
  const ServiceAccessTypeTips({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Akses Layanan",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tentukan siapa saja yang dapat mengakses layanan ini. "
            "Pengaturan ini membantu mengontrol visibilitas dan penggunaan layanan.",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          InfoItem(
            icon: Icons.public_rounded,
            title: "Public",
            description:
                "Layanan dapat diakses oleh semua pengguna tanpa batasan khusus. "
                "Cocok untuk layanan umum yang terbuka bagi seluruh pelanggan.",
          ),

          InfoItem(
            icon: Icons.workspace_premium_rounded,
            title: "Member Only",
            description:
                "Layanan hanya dapat diakses oleh pelanggan yang telah terdaftar "
                "atau memiliki status langganan di perusahaan.",
          ),

          InfoItem(
            icon: Icons.business_center_rounded,
            title: "Internal",
            description:
                "Layanan hanya dapat diakses oleh pihak internal perusahaan, "
                "seperti admin, supervisor, atau tim operasional.",
          ),

          const SizedBox(height: 16),

          InformationBlock.info(
            "Tips: Gunakan Public untuk layanan umum, "
            "Member Only untuk layanan eksklusif pelanggan berlangganan, "
            "dan Internal untuk kebutuhan operasional internal perusahaan.",
          ),
        ],
      ),
    );
  }
}