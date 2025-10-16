import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';

class ServiceDetailSkeleton extends StatelessWidget {
  const ServiceDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [

        // === Chips Section ===
        SmartShimmer(
          isLoading: true,
          placeholders: [
            Row(
              children: List.generate(2, (index) {
                return Container(
                  height: 32,
                  width: 100,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),
          ],
          child: const SizedBox(),
        ),
        const SizedBox(height: 24),

        // === Description Section ===
        SmartShimmer(
          isLoading: true,
          placeholders: [
            Container(height: 20, width: 120, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            CustomCard(
              elevation: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(3, (index) {
                  return Container(
                    height: 14,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    color: Colors.grey.shade300,
                  );
                }),
              ),
            ),
          ],
          child: const SizedBox(),
        ),

        const SizedBox(height: 32),

        // === Required Staff Section ===
        SmartShimmer(
          isLoading: true,
          placeholders: [
            Container(height: 20, width: 150, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Column(
              children: List.generate(2, (index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Container(
                      height: 14,
                      width: 120,
                      color: Colors.grey.shade300,
                    ),
                    subtitle: Container(
                      height: 12,
                      width: 80,
                      margin: const EdgeInsets.only(top: 6),
                      color: Colors.grey.shade200,
                    ),
                  ),
                );
              }),
            ),
          ],
          child: const SizedBox(),
        ),
      ],
    );
  }
}
