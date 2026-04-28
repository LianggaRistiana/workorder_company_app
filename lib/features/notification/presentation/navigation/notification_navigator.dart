import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/invitation_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/service_request_permission.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

abstract class NotificationNavigator {
  void openWorkOrderDetailPage(String woId);
  void openServiceRequestPage(String srId);
  void openInvitationsPage();
  void openNotificationList();
}

class NotificationNavigatorImpl implements NotificationNavigator {
  final GoRouter router;
  final AuthRepository auth;

  NotificationNavigatorImpl(this.router, this.auth);

  void _safePush(String location, {Object? extra}) {
    final currentLocation =
        router.routerDelegate.currentConfiguration.uri.toString();

    if (currentLocation == location) return;

    router.push(location, extra: extra);
  }

  @override
  void openNotificationList() {
    _safePush(AppRoutes.notFound);
  }

  @override
  void openInvitationsPage() {
    final user = auth.currentUser;
    if (user == null) return;
    if (user.role.canAll(InvitationPermission.receiver)) {
      _safePush(AppRoutes.invitationsPending);
    }
    if (user.role.canAll(InvitationPermission.sender)) {
      _safePush(AppRoutes.invitationsHistory);
    } else {
      return;
    }
  }

  @override
  void openServiceRequestPage(String srId) {
    final user = auth.currentUser;
    if (user == null) return;
    final route = AppRoutes.serviceRequestDetail.fillId(srId);
    final extra = user.role.canAll(ServiceRequestPermission.provider)
        ? ServiceRequestSide.provider
        : ServiceRequestSide.requester;

    _safePush(route, extra: extra);
  }

  @override
  void openWorkOrderDetailPage(String woId) {
    final route = AppRoutes.workOrdersDetail.fillId(woId);

    _safePush(route);
  }
}
