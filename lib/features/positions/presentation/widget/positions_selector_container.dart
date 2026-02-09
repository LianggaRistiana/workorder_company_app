import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/positions_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/positions_selector.dart';

class PositionsSelectorContainer extends StatelessWidget {
  const PositionsSelectorContainer({
    super.key,
    required this.selectedPositions,
    required this.onAdd,
    required this.buttonBuilder,
  });

  final List<PositionEntity> selectedPositions;
  final void Function(PositionEntity) onAdd;
  final Widget Function(
    BuildContext context,
    VoidCallback onPressed,
    bool isLoading,
  ) buttonBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PositionsBloc, PositionsState>(
      builder: (context, state) {
        final isLoading = state is PositionsLoading;
        final availablePositions =
            state is PositionsLoaded ? state.positions : <PositionEntity>[];

        return PositionsSelector(
          selectedPositions: selectedPositions,
          availablePositions: availablePositions,
          isLoading: isLoading,
          onAdd: onAdd,
          buttonBuilder: buttonBuilder,
        );
      },
    );
  }
}
