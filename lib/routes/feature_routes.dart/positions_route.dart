import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/pages/position_create_page.dart';
import 'package:workorder_company_app/features/positions/presentation/pages/position_detail_page.dart';
import 'package:workorder_company_app/features/positions/presentation/pages/position_update_page.dart';
import 'package:workorder_company_app/features/positions/presentation/pages/positions_list_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/wrapper/position_wrapper.dart';

final positionsRouter = [
  ShellRoute(
      builder: (context, state, child) {
        return PositionWrapper(child: child);
      },
      routes: [
        GoRoute(
            path: AppRoutes.positions,
            builder: (_, __) => const PositionsListPage()),
        GoRoute(
            path: AppRoutes.positionsCreate,
            builder: (_, __) => const PositionCreatePage()),
        GoRoute(
            path: AppRoutes.positionsUpdate,
            builder: (_, state) {
              debugPrint(state.extra.toString());
              return PositionUpdatePage(
                intitialPosition: state.extra as PositionEntity,
              );
            }),
        GoRoute(
            path: AppRoutes.positionsDetail,
            builder: (_, state) {
              final positionId = state.pathParameters['id']!;
              return PositionDetailPage(positionId: positionId);
            }),
      ])
];
