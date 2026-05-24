import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';

class ServicePriceTag extends StatelessWidget {
  final int price;
  const ServicePriceTag({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(100)),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Icon(
          AppIcon.servicePrice,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(price > 0 ? "Rp$price" : "Harga belum ditentukan",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  )),
        )
      ]),
    );
  }
}
