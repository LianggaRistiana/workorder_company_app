import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/positions_selector.dart';
import 'package:workorder_company_app/features/services/domain/entities/required_staff_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';

class RequiredPositionsSetting extends StatelessWidget {
  final List<RequiredStaffEntity> requiredStaff;
  final ValueChanged<PositionEntity> onAdd;
  final ValueChanged<PositionEntity> onRemove;
  final Function(RequiredStaffEntity staff, int newMin) onMinChange;
  final Function(RequiredStaffEntity staff, int newMax) onMaxChange;
  final VoidCallback? onChanged;

  const RequiredPositionsSetting({
    super.key,
    required this.requiredStaff,
    required this.onAdd,
    required this.onRemove,
    required this.onMinChange,
    required this.onMaxChange,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Posisi diperlukan", style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                // PositionsSelector(
                //   onAdd: onAdd,
                //   useBloc: true,
                //   selectedPositions:
                //       requiredStaff.map((s) => s.position).toList(),
                // ),
              ],
            ),
            const SizedBox(height: 12),
            CustomList(
              separatorHeight: 8,
              items: requiredStaff,
              itemBuilder: (requiredStaff, _) =>
                  _buildPositonOptionItem(requiredStaff),
              emptyWidget: EmptyStateWidget(
                text: 'Tidak ada posisi Ditugaskan',
                size: 40,
                icon: Icons.warning_amber_rounded,
                // backgroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
            ),
          ],
        ));
  }

  Widget _buildPositonOptionItem(RequiredStaffEntity staff) {
    final minController =
        TextEditingController(text: staff.minimumStaff.toString());
    final maxController =
        TextEditingController(text: staff.maximumStaff.toString());

    return CustomCard(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                staff.position.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: CustomInputField(
                label: "Min",
                controller: minController,
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null) onMinChange(staff, parsed);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomInputField(
                label: "Max",
                controller: maxController,
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null) onMaxChange(staff, parsed);
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => onRemove(staff.position),
            ),
          ],
        ),
      ),
    );
  }
}
