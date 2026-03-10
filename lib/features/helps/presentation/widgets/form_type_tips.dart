import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'info_item.dart';

class FormTypeTips extends StatelessWidget {
  const FormTypeTips({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jenis Formulir",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Jenis formulir menentukan tujuan dan alur proses data di sistem. "
              "Pilih jenis formulir sesuai dengan fungsi utama yang ingin Anda buat.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            InfoItem(
              icon: Icons.inbox_outlined,
              title: "Pengajuan",
              description:
                  "Digunakan untuk membuat formulir permintaan dari pengguna. "
                  "Formulir ini biasanya akan diproses atau ditindaklanjuti oleh manajer perusahaan",
            ),
            InfoItem(
              icon: Icons.assignment_outlined,
              title: "Perintah Kerja",
              description:
                  "Digunakan untuk membuat formulir penugasan pekerjaan. "
                  "Formulir ini akan diisi oleh manajer.",
            ),
            InfoItem(
              icon: Icons.description_outlined,
              title: "Laporan",
              description:
                  "Digunakan untuk membuat formulir dokumentasi hasil pekerjaan atau aktivitas. "
                  "Cocok untuk laporan hasil maintenance, inspeksi, atau hasil perintah kerja lainnya.",
            ),
            InfoItem(
              icon: Icons.rate_review_outlined,
              title: "Review (Permintaan Layanan)",
              description:
                  "Digunakan untuk membuat formulir evaluasi terhadap layanan atau pekerjaan yang telah dilakukan. "
                  "Biasanya berisi penilaian, komentar, atau feedback untuk meningkatkan kualitas layanan.",
            ),
            const SizedBox(height: 16),
            InformationBlock.info(
                "Pilih Jenis Formulir sesuai kebutuhan"),
           
          ],
        ),
      ),
    );
  }
}
