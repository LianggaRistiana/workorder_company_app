import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/positions_selector.dart';
import 'package:workorder_company_app/features/services/domain/entities/required_staff_entity.dart';

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
    return PositionsSelector(
      selectedPositions: requiredStaff.map((s) => s.position).toList(),
      onAdd: onAdd,
      onRemove: onRemove,
      itemBuilder: (position) {
        final staff = requiredStaff.firstWhere((s) => s.position.id == position.id);

        final minController = TextEditingController(text: staff.minimumStaff.toString());
        final maxController = TextEditingController(text: staff.maximumStaff.toString());

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
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
                  child: TextField(
                    controller: minController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(labelText: 'Min', isDense: true),
                    onChanged: (val) {
                      final parsed = int.tryParse(val);
                      if (parsed != null) onMinChange(staff, parsed);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: maxController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(labelText: 'Max', isDense: true),
                    onChanged: (val) {
                      final parsed = int.tryParse(val);
                      if (parsed != null) onMaxChange(staff, parsed);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => onRemove(position),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
