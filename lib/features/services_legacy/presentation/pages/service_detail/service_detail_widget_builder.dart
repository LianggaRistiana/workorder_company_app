part of 'service_detail_page.dart';

extension ServiceDetailWidgetBuilder on ServiceDetailPageState {
  Widget _buildFormsTab(List<ServiceFormEntity>? serviceForms, String title) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            if (serviceForms?.isNotEmpty ?? false)
              InformationBlock(
                  message:
                      "Tekan dan tahan formulir yang dipilih untuk melihat detail formulir"),
            const SizedBox(height: 8),
            // CustomList(
            //   items: serviceForms ?? [],
            //   separatorHeight: AppSpacing.sm,
            //   emptyWidget: EmptyStateWidget(
            //     text: "Tidak ada $title",
            //   ),
            //   itemBuilder: (serviceForm, _) =>
            //       ServiceFormCard(serviceForm: serviceForm),
            // ),
          ],
        ));
  }

  Widget _buildOverviewTab(ServiceEntity service) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            ServiceAccessChip(access: service.accessType),
            const SizedBox(width: 8),
            ActiveStatusChip(label: "Layanan", isActive: service.isActive)
          ],
        ),
        _buildSectionTitle("Deskripsi"),
        CustomCard(
          elevation: 0,
          child: Text(
            service.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        ),
        const SizedBox(height: 8),
        _buildSectionTitle("Pegawai yang Diperlukan"),
        CustomList(
          items: service.requiredStaff,
          separatorHeight: 8,
          emptyWidget: InformationBlock.empty(
            "Tidak ada pegawai yang diperlukan",
          ),
          itemBuilder: (staff, _) => CustomCard(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(4),
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
        const SizedBox(height: 12),
        if (service.accessType != ServiceAccessType.internal) ...{
          _buildSectionTitle("Formulir Pengajuan"),
          InformationBlock(
            message:
                "Formulir ini akan diisi oleh kustomer yang ingin mengajukan layanan ini, dan hanya bisa dilihat hasilnya oleh manager",
          ),
          const SizedBox(height: 8),
          CustomList<OrderedFormEntity>(
            items: service.clientIntakeForms ?? [],
            separatorHeight: 8,
            itemBuilder: (intake, _) => CustomCard(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: ListTile(
                  onTap: () {
                    context.push(AppRoutes.formsDetail.fillId(intake.form.id));
                  },
                  leading: IconBox(icon: Icons.assignment_turned_in_outlined),
                  title: Text(
                    intake.form.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
          ),
        }
      ],
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
