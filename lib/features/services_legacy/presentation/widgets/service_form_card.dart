import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/service_form_entity.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/info_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

@Deprecated("Don't Use This")
class ServiceFormCard extends StatelessWidget {
  final ServiceFormEntity serviceForm;

  const ServiceFormCard({
    super.key,
    required this.serviceForm,
  });

  final selectableRoles = const [
    UserRole.managerCompany,
    UserRole.staffCompany,
    UserRole.client,
  ];

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.all(0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onLongPress: () {
          context.push(AppRoutes.formsDetail.fillId(serviceForm.form.id));
        },
        onTap: () {
          showAppBottomSheet(context,
              header: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.assignment_turned_in_outlined,
                      size: 28,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    serviceForm.form.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRoleSection(
                    title: 'Diisi Oleh',
                    icon: Icons.edit,
                    context: context,
                    selectedRoles: serviceForm.fillableByRoles,
                    selectedPositions: serviceForm.fillableByPositions,
                  ),
                  const SizedBox(height: 24),
                  _buildRoleSection(
                    title: 'Dilihat Oleh',
                    icon: Icons.visibility,
                    context: context,
                    selectedRoles: serviceForm.viewableByRoles,
                    selectedPositions: serviceForm.viewableByPositions,
                  ),
                ],
              ),
              footer: Column(
                children: [
                  HorizontalButton(
                    title: "Detail Formulir",
                    leadingIcon: Icons.assignment_turned_in_outlined,
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        AppRoutes.formsDetail.fillId(serviceForm.form.id),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tutup'),
                  ),
                ],
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(12), // beri padding manual
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.assignment_turned_in_outlined,
                      size: 28,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    serviceForm.form.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<UserRole> selectedRoles,
    required List<PositionEntity> selectedPositions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),

        /// ===== ROLES =====
        ...selectedRoles.map((role) {
          // STAFF COMPANY (punya nested posisi)
          if (role == UserRole.staffCompany) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildRoleCard(
                context,
                title: role.displayName,
                child: CustomList(
                  emptyWidget: InformationBlock.empty("Semua Pegawai Terpilih"),
                  separatorHeight: 8,
                  items: selectedPositions,
                  itemBuilder: (item, _) => _buildPositionItem(context, item),
                ),
              ),
            );
          }

          // ROLE BIASA
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildRoleCard(
              context,
              title: role.displayName,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPositionItem(BuildContext context, PositionEntity position) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: CustomCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 0,
        child: Row(
          children: [
            IconBox(
                icon: Icons.badge_outlined,
                iconSize: 12,
                paddingSize: 8,
                borderRadius: 8),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                position.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    Widget? child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).disabledColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          if (child != null) ...[
            const SizedBox(height: 8),
            child,
          ],
        ],
      ),
    );
  }
}
