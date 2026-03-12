import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/create/position_create_cubit.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/create/position_create_state.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/Position_form_view.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

// Inject Cubit here
class PositionCreatePage extends StatelessWidget {
  const PositionCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PositionCreateCubit>(),
      child: BlocListener<PositionCreateCubit, PositionCreateState>(
        listener: (context, state) {
          if (state.status == PositionCreateStatus.success) {
            context.showSuccess("Departemen berhasil dibuat");
            context.pop(state.createdPosition);
          }

          if (state.status == PositionCreateStatus.error) {
            context.showError(state.errorMessage ?? 'Terjadi kesalahan');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Buat Departemen'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<PositionCreateCubit, PositionCreateState>(
              builder: (context, state) {
                return PositionFormView(
                  submitLabel: "Simpan Departemen",
                  isLoading: state.status == PositionCreateStatus.loading,
                  onSubmit: (entity) {
                    context.read<PositionCreateCubit>().createPosition(entity);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
