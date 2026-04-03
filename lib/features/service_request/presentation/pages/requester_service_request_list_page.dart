import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/requester_service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/service_request_item.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';
import 'package:workorder_company_app/shared/utils/todo_strings_helper.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class RequesterServiceRequestListPage extends StatelessWidget {
  const RequesterServiceRequestListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListPageScaffold<RequesterServiceRequestEntity>(
      title: 'Daftar Permintaan Layanan',
      isLoading: false,
      onRefresh: () async {},
      items: dummyRequesterServiceRequests,
      itemBuilder: (item) {
        return ServiceRequestItem.requester(
            serviceRequest: item, onTap: () {}, toCompany: item.company);
      },
    );
  }
}

// FIXME : Remove this dummy
final dummyRequesterServiceRequests = List.generate(
  5,
  (index) => RequesterServiceRequestEntity(
    id: "req-00$index",
    code: "SR-2026-000$index",
    status: ServiceRequestStatus.rejected,
    service: ServiceSummaryEntity(
      id: "svc-00$index",
      title: TodoText.title("SR-$index"),
      description: "Dummy service $index",
      accessType: ServiceAccessType.public,
      isActive: true,
    ),
    requestedBy: UserEntity(
      name: "Johm due $index",
      email: "user$index@example.com",
      role: UserRole.client,
    ),
    intakeForm: null,
    reviewForm: null,
    company: CompanyEntity(
      id: "comp-00$index",
      name: "Company katanya $index",
      address: "Denpasar",
      description: "Dummy company $index",
      isActive: true,
    ),
    createdAt: DateTime.now().subtract(Duration(days: index)),
  ),
);
