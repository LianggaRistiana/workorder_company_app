import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/shared/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class NavConfig {
  static List<NavItem> byRole(UserRole role) {
    switch (role) {
      case UserRole.ownerCompany:
        return const [
          NavItem('Utama', Icons.home_rounded, AppRoutes.home),
          NavItem(
              'Perusahaan', Icons.home_work_rounded, AppRoutes.ownerCompany),
        ];

      case UserRole.managerCompany:
        return const [
          NavItem('Utama', Icons.home_rounded, AppRoutes.home),
          NavItem(
              'Pengajuan Layanan', Icons.inbox_rounded, AppRoutes.serviceRequest),
          NavItem('Perintah Kerja', Icons.assignment_rounded,
              AppRoutes.workorders),
        ];

      case UserRole.staffCompany:
        return const [
          NavItem('Utama', Icons.home_rounded, AppRoutes.home),
          // NavItem('Tugas', Icons.task_rounded, AppRoutes.staffWorkorder),
          NavItem('Perintah Kerja', Icons.assignment_rounded, AppRoutes.workorders),
        ];

      case UserRole.client:
        return const [
          NavItem('Utama', Icons.home_rounded, AppRoutes.home),
          NavItem('Daftar Perusahaan', Icons.home_work_rounded,
              AppRoutes.clientCompanyPortal),
        ];

      default:
        return const [];
    }
  }
}
