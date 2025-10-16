part of 'service_detail_page.dart';

extension ServiceDetailWidgetBuilder on ServiceDetailPageState {
  Widget _buildFormsTab(List<ServiceFormEntity>? serviceForms, String title) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CustomList(
        items: serviceForms ?? [],
        separatorHeight: 8,
        emptyWidget: EmptyStateWidget(
          text: "Tidak ada $title",
        ),
        itemBuilder: (serviceForm, _) =>
            ServiceFormCard(serviceForm: serviceForm),
      ),
    );
  }

  Widget _buildOverviewTab(ServiceEntity service) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            _buildAccessTypeChip(service.accessType),
            const SizedBox(width: 8),
            Chip(
              label: Text(service.isActive ? "Active" : "Inactive"),
              backgroundColor: service.isActive
                  ? Colors.green.shade50
                  : Colors.grey.shade200,
              avatar: Icon(
                service.isActive ? Icons.check_circle : Icons.cancel,
                color: service.isActive ? Colors.green : Colors.grey.shade600,
              ),
            ),
          ],
        ),
        _buildSectionTitle("Description"),
        CustomCard(
          elevation: 0,
          child: Text(
            service.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        ),
        const SizedBox(height: 8),
        _buildSectionTitle("Required Staff"),
        CustomList(
          items: service.requiredStaff,
          separatorHeight: 8,
          itemBuilder: (staff, _) => CustomCard(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(4),
            elevation: 0,
              child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person_outline, color: Colors.blueAccent),
            ),
            title: Text(
              staff.position.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Min: ${staff.minimumStaff}, Max: ${staff.maximumStaff}',
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildAccessTypeChip(String accessType) {
    IconData icon;
    Color bgColor;

    switch (accessType.toLowerCase()) {
      case "public":
        icon = Icons.public;
        bgColor = Colors.blue.shade50;
        break;
      case "member-only":
        icon = Icons.group;
        bgColor = Colors.orange.shade50;
        break;
      case "internal":
        icon = Icons.business;
        bgColor = Colors.purple.shade50;
        break;
      default:
        icon = Icons.lock;
        bgColor = Colors.grey.shade200;
    }

    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(accessType),
      backgroundColor: bgColor,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
