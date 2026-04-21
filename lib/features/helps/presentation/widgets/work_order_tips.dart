import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/work_order/presentation/ui_mappers/work_order_status_color_mapper.dart';
import 'package:workorder_company_app/features/work_order/presentation/ui_mappers/work_order_status_icon_mapper.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class WorkOrderTips extends StatelessWidget {
  const WorkOrderTips({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Perintah Kerja",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                const TextSpan(
                  text:
                      "Perintah kerja adalah instruksi resmi untuk menugaskan suatu pekerjaan kepada pegawai ",
                ),
                const TextSpan(
                  text:
                      "sesuai konfigurasi yang telah ditetapkan dalam suatu layanan.",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const TextSpan(text: "\n\n"),
                const TextSpan(
                  text:
                      "Perintah kerja dapat dibuat berdasarkan permintaan layanan yang diajukan, ",
                ),
                const TextSpan(
                  text:
                      "atau dibuat secara mandiri sesuai kebutuhan operasional.",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Status Perintah Kerja",
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          _statusItem(
            context,
            WorkOrderStatus.drafted,
            [
              "Perintah kerja masih dalam tahap penyusunan.",
              "Instruksi pekerjaan dan penugasan pegawai dilakukan pada tahap ini.",
            ],
          ),
          _statusItem(
            context,
            WorkOrderStatus.sent,
            [
              "Perintah kerja telah dikirim kepada pegawai yang ditugaskan.",
              "Persetujuan diperlukan apabila tipe persetujuan tidak otomatis.",
            ],
          ),
          _statusItem(
            context,
            WorkOrderStatus.approved,
            [
              "Perintah kerja telah disetujui dan siap untuk dikerjakan.",
            ],
          ),
          _statusItem(
            context,
            WorkOrderStatus.rejected,
            [
              "Perintah kerja ditolak dan dikembalikan untuk peninjauan ulang.",
            ],
          ),
          _statusItem(
            context,
            WorkOrderStatus.onProgress,
            [
              "Perintah kerja sedang dalam proses pengerjaan.",
              "Pegawai dapat mulai mengisi laporan kerja pada tahap ini.",
            ],
          ),
          _statusItem(
            context,
            WorkOrderStatus.completed,
            [
              "Perintah kerja telah selesai.",
              "Pekerjaan dapat diselesaikan dengan atau tanpa kendala.",
            ],
          ),
          _statusItem(
            context,
            WorkOrderStatus.failed,
            [
              "Perintah kerja dinyatakan gagal dan tidak dapat dilanjutkan.",
            ],
          ),
          _statusItem(
            context,
            WorkOrderStatus.cancelled,
            [
              "Perintah kerja dibatalkan.",
              "Permintaan layanan akan ditandai sebagai tidak dapat dilanjutkan.",
            ],
          ),
        ]));
  }

  Widget _statusItem(
    BuildContext context,
    WorkOrderStatus status,
    List<String> descriptions,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBox.small(
            icon: status.icon,
            iconColor: status.color,
            backgroundColor: status.color.withAlpha(20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.displayName,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                ...descriptions.map(
                  (text) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
