import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/detail/position_detail_cubit.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/detail/position_detail_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/active_status_chip.dart';
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
      child: const PositionDetailView(),
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
          switch (state.status) {
            case PositionDetailStatus.initial:
              return const SizedBox();

            case PositionDetailStatus.loading:
              return const Center(
                child: AppLoading(),
              );

            case PositionDetailStatus.error:
              return Center(
                child: Text(
                  state.errorMessages ?? "Terjadi kesalahan",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              );

            case PositionDetailStatus.loaded:
              final position = state.position;

              if (position == null) {
                return const Center(
                  child: Text("Data tidak ditemukan"),
                );
              }

              return _DetailContent(position: position);
          }
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          HeaderOfPage(
            title: position.name,
            icon: Icons.badge_outlined,
          ),

          /// ===== SECTION: INFORMASI =====
          CustomCard(
              margin: const EdgeInsets.only(
                  top: AppSpacing.md, bottom: AppSpacing.sm),
              child: PropertyDisplay(
                properties: [
                  PropertyItem.text(
                    label: "Nama Departemen",
                    value: position.name,
                    icon: Icons.badge_outlined,
                  ),
                  PropertyItem.text(
                    label: "Deskripsi",
                    value: position.description ?? "-",
                    icon: Icons.info_outline,
                  ),
                  PropertyItem.widget(
                      label: "Status Aktif",
                      icon: Icons.verified,
                      child: ActiveStatusChip(
                        isActive: position.isActive,
                      )),
                ],
              )),

          /// ===== ACTION BUTTON =====
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                final result = await context.push<PositionEntity?>(
                    AppRoutes.positionsUpdate,
                    extra: position);

                if (result != null) {
                  if (!context.mounted) return;
                  context.read<PositionDetailCubit>().replaceData(result);
                }
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Departemen"),
            ),
          ),

          const Divider(),

          const SizedBox(height: AppSpacing.lg),

          /// ===== SECTION: DAFTAR PEGAWAI =====
          PropertyTitle(
            label: "Daftar Pegawai",
            icon: Icons.people_outline,
          ),

          const SizedBox(height: AppSpacing.md),

          /// Placeholder
          const Text("Belum ada pegawai."),
        ],
      ),
    );
  }
}
