import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';
import 'package:workorder_company_app/features/system_integration/presentation/widgets/paired_account_view.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

class LabPage extends StatefulWidget {
  const LabPage({super.key});

  @override
  State<LabPage> createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab Page"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PairedAccountView(
                  companyId: "companyId",
                  isPaired: false,
                  onConnect: () => context
                      .push(AppRoutes.pairAccount.fillId("asdasdasdasd")),
                  externalUser: ExternalUserEntity(
                      id: "id",
                      externalEmail: "externalEmail",
                      externalName: "externalName",
                      company: CompanyEntity(
                          id: "id",
                          name: "name",
                          isActive: true,
                          isFaqActive: true),
                      pairedAt: DateTime.now()),
                  onDetach: () {}),
              const SizedBox(height: 20),
              FilledButton(
                  onPressed: () => context
                      .push(AppRoutes.pairAccount.fillId("asdasdasdasd")),
                  child: Text("Pairing account")),
              FilledButton(
                  onPressed: () => context
                      .push(AppRoutes.pairAccount.fillId("asdasdasdasd")),
                  child: Text("Pairing account Company Home UI")),
              FilledButton(
                  onPressed: () async {
                    final uri = Uri.parse("https://google.com");

                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Text("Open Google")),
              FilledButton(
                  onPressed: () =>
                      context.push(AppRoutes.systemIntegrationConfig),
                  child: Text("System Integrate Config")),
            ],
          ),
        ),
      ),
    );
  }
}

class AppDatePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? Function(DateTime?)? validator;

  const AppDatePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.validator,
  });

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: value,
      validator: validator,
      builder: (field) {
        final text = value == null
            ? ''
            : '${value!.year}-${value!.month.toString().padLeft(2, '0')}-${value!.day.toString().padLeft(2, '0')}';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              readOnly: true,
              controller: TextEditingController(text: text),
              decoration: InputDecoration(
                labelText: label,
                suffixIcon: const Icon(Icons.calendar_today),
                errorText: field.errorText,
              ),
              onTap: () async {
                await _pickDate(context);
                field.didChange(value);
              },
            ),
          ],
        );
      },
    );
  }
}
