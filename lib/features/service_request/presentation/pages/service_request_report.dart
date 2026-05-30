import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/get_service_request_report/get_service_request_report_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/get_service_request_report/get_service_request_report_state.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/filled_form_view.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/item_tile_lined.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';
import 'package:workorder_company_app/shared/widgets/shimmer_placeholder.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';

class ServiceRequestReport extends StatelessWidget {
  final String serviceRequestId;

  const ServiceRequestReport({
    super.key,
    required this.serviceRequestId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            sl<GetServiceRequestReportCubit>()..getReport(serviceRequestId),
        child: BlocBuilder<GetServiceRequestReportCubit,
            GetServiceRequestReportState>(builder: (context, state) {
          if (state.isLoading) {
            return SmartShimmer(
              key: const ValueKey('loading'),
              placeholders: [
                ShimmerPlaceholder(
                    height: 220, width: double.infinity, borderRadius: 24),
              ],
            );
          } else if (state.isError) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SectionTitle("Laporan"),
                  InformationBlock.error(
                      state.errorMessage ?? "Gagal mendapatkan laporan"),
                  TextButton(
                      onPressed: () => context
                          .read<GetServiceRequestReportCubit>()
                          .getReport(serviceRequestId),
                      child: Text("Muat ulang"))
                ]);
          }
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SectionTitle("Laporan"),
                CustomList(
                    items: state.reports.filledForms,
                    emptyWidget: InformationBlock.empty(
                        "Layanan ini tidak memiliki laporan untuk pemohon"),
                    itemBuilder: (item, _) {
                      return ClickableCustomCard(
                        child: ItemTileLined(child: Text(item.form.title)),
                        onTap: () {
                          showAppBottomSheet(
                            context,
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  PropertyTitle(
                                    icon: AppIcon.workReport,
                                    label: "Laporan",
                                  ),
                                  const SizedBox(
                                    height: AppSpacing.sm,
                                  ),
                                  FilledFormView(filledForm: item),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    })
              ]);
        }));
  }
}
