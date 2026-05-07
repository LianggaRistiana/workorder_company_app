import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/item_tile_lined.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class PositionRequiredView extends StatelessWidget {
  final List<PositionEntity> positions;
  const PositionRequiredView({
    super.key,
    required this.positions,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        child: Column(
      children: [
        PropertyTile(
          label: "Departemen dibutuhkan untuk layanan ini",
          icon: AppIcon.department,
          value: "${positions.length} Departement",
        ),
        Divider(),
        CustomList(
            items: positions,
            separatorHeight: 8,
            itemBuilder: (item, _) => ItemTileLined(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      item.description ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                )))
      ],
    ));
  }
}
