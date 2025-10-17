import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/shimmer_placeholder.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';

class ServicesSkeleton extends StatelessWidget {
  const ServicesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Menampilkan list shimmer untuk beberapa card
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemCount: 5, // jumlah placeholder
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return const SmartShimmer(
          placeholders: [
            // Placeholder layout mirip tampilan form card asli
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bagian kiri: judul dan deskripsi
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerPlaceholder(height: 16, width: 150),
                        SizedBox(height: 12),
                        ShimmerPlaceholder(height: 14, width: 180),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  // Bagian kanan: chip kecil
                  ShimmerPlaceholder(
                    height: 20,
                    width: 60,
                    borderRadius: 20,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
