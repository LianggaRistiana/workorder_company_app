import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/detail/position_detail_cubit.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/detail/position_detail_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/active_status_chip.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/header_of_page.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class PositionDetailPage extends StatelessWidget {
  final String positionId;

  const PositionDetailPage({
    super.key,
    required this.positionId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PositionDetailCubit>()..getPositionById(positionId),
      child: const PositionDetailView(), // nanti kita ganti const
    );
  }
}

class PositionDetailView extends StatelessWidget {
  const PositionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<PositionDetailCubit, PositionDetailState>(
        listener: (context, state) {
          if (state.status == PositionDetailStatus.error) {
            context.showError(state.errorMessages ?? "Terjadi kesalahan");
          }
        },
        builder: (context, state) {
          final position = state.position;

          // Loading
          if (state.status == PositionDetailStatus.loading &&
              position == null) {
            return const Center(
              child: AppLoading(),
            );
          }

          // Error
          if (state.status == PositionDetailStatus.error) {
            return Center(
              child: Text(
                state.errorMessages ?? "Terjadi kesalahan",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            );
          }

          // Loaded
          if ((state.status == PositionDetailStatus.loaded) ||
              state.status == PositionDetailStatus.loading) {
            if (position == null) {
              return const Center(
                child: Text("Data tidak ditemukan"),
              );
            }
            return _DetailContent(position: position);
          }

          // Initial / fallback
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final PositionEntity position;

  const _DetailContent({required this.position});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async => await context
            .read<PositionDetailCubit>()
            .getPositionById(position.id),
        child: AdaptiveSplitColumn(leftChildren: [
          HeaderOfPage(
            title: position.name,
            icon: AppIcon.department,
          ),

          CustomCard(
              margin: const EdgeInsets.only(
                  top: AppSpacing.md, bottom: AppSpacing.sm),
              child: PropertyDisplay(
                properties: [
                  PropertyItem.text(
                    label: "Nama Departemen",
                    value: position.name,
                    icon: AppIcon.department,
                  ),
                  PropertyItem.text(
                    label: "Deskripsi",
                    value: position.description ?? "-",
                    icon: AppIcon.desc,
                  ),
                  PropertyItem.widget(
                      label: "Status Aktif",
                      icon: AppIcon.activeState,
                      child: ActiveStatusChip(
                        isActive: position.isActive,
                      )),
                ],
              )),

          /// ===== ACTION BUTTON =====
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () async {
                final result = await context.push<PositionEntity?>(
                    AppRoutes.positionsUpdate,
                    extra: position);

                if (result != null) {
                  if (!context.mounted) return;
                  context.read<PositionDetailCubit>().replaceData(result);
                }
              },
              icon: const Icon(AppIcon.edit),
              label: const Text("Edit Departemen"),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
        ], rightChildren: [
          PropertyTitle(
            label: "Daftar Pegawai",
            icon: AppIcon.employee,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text("Belum ada pegawai."),
        ]),
      ),
    );
  }
}
