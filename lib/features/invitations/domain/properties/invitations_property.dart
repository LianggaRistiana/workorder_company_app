import 'package:workorder_company_app/core/model/property_key.dart';

enum InvitationProperty implements PropertyKey {
  email('email'),
  role('role'),
  position("positionId");

  @override
  final String key;

  const InvitationProperty(this.key);
}

extension InvitationPropertyExtension on InvitationProperty {
  PropertyKey byIndex(int index) {
    return IndexedPropertyKey('invites[$index].$key');
  }
}
