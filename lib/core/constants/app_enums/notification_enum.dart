enum ResourceType {
  invitation,
  serviceRequest,
  workOrder,
  workReport;

  static ResourceType fromString(String value) {
    switch (value) {
      case 'invitation':
        return ResourceType.invitation;
      case 'service_request':
        return ResourceType.serviceRequest;
      case 'work_order':
        return ResourceType.workOrder;
      case 'work_report':
        return ResourceType.workReport;
      default:
        throw Exception('Unknown ResourceType: $value');
    }
  }
}
