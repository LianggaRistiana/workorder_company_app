import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/update/position_update_cubit.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/update/position_update_state.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/position_form_view.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

class PositionUpdatePage extends StatelessWidget {
  final PositionEntity intitialPosition;

  const PositionUpdatePage({super.key, required this.intitialPosition});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PositionUpdateCubit>(),
      child: PositionUpdateView(
        intitialPosition: intitialPosition,
      ),
    );
  }
}

class PositionUpdateView extends StatelessWidget {
  final PositionEntity intitialPosition;
  const PositionUpdateView({super.key, required this.intitialPosition});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PositionUpdateCubit, PositionUpdateState>(
        listener: (context, state) {
      if (state.status == PositionUpdateStatus.success) {
        context.showSuccess("Departemen berhasil dibuat");
        context.pop(state.updatedPosition);
      }

      if (state.status == PositionUpdateStatus.error) {
        context.showError(state.errorMessage ?? 'Terjadi kesalahan');
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Departemen'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: PositionFormView(
            submitLabel: "Perbaharui Departemen",
            isLoading: state.status == PositionUpdateStatus.loading,
            initialData: intitialPosition,
            onSubmit: (entity) {
              context.read<PositionUpdateCubit>().updateEntity(entity);
            },
          ),
        ),
      );
    });
  }
}
