import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';

class FormsSkeleton extends StatelessWidget {
  const FormsSkeleton({super.key});

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title shimmer
                  ShimmerPlaceholder(height: 16, width: 150),
                  SizedBox(height: 12),
                  // Description shimmer
                  ShimmerPlaceholder(height: 14, width: double.infinity),
                  SizedBox(height: 6),
                  ShimmerPlaceholder(height: 14, width: 180),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Helper kecil untuk membuat shimmer rectangle
class ShimmerPlaceholder extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const ShimmerPlaceholder({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
