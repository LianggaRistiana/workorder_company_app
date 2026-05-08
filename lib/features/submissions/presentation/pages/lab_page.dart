import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/donut_data_entity.dart';
import 'package:workorder_company_app/features/dashboard/presentation/widgets/multi_donut_chart.dart';
import 'package:workorder_company_app/features/dashboard/presentation/widgets/toggleable_legend.dart';
import 'package:workorder_company_app/features/service_request/presentation/ui_mappers.dart/service_request_status_color_mapper.dart';
import 'package:workorder_company_app/features/work_order/presentation/ui_mappers/work_order_status_color_mapper.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class LabPage extends StatefulWidget {
  const LabPage({super.key});

  @override
  State<LabPage> createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

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
              CustomCard(
                  child: Column(
                children: [
                  PropertyTitle(
                    icon: AppIcon.workOrder,
                    label: "Perintah Kerja",
                  ),
                  MultiDonutChart(
                    data: [
                      ...WorkOrderStatus.values.map(
                        (e) {
                          return DonutDataEntity(
                              label: e.displayName, value: 40, color: e.color);
                        },
                      )
                    ],
                  ),
                  ToggleableLegend(data: [
                    ...WorkOrderStatus.values.map(
                      (e) {
                        return DonutDataEntity(
                            label: e.displayName, value: 40, color: e.color);
                      },
                    )
                  ])
                ],
              )),
              CustomCard(
                  child: Column(
                children: [
                  PropertyTitle(
                    icon: AppIcon.serviceRequestInbox,
                    label: "Permintaan Layanan",
                  ),
                  MultiDonutChart(
                    data: [
                      ...ServiceRequestStatus.values.map(
                        (e) {
                          return DonutDataEntity(
                              label: e.displayName, value: 20, color: e.color);
                        },
                      )
                    ],
                  ),
                  ToggleableLegend(data: [
                    ...ServiceRequestStatus.values.map(
                      (e) {
                        return DonutDataEntity(
                            label: e.displayName, value: 40, color: e.color);
                      },
                    )
                  ])
                ],
              )),
              CustomCard(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PropertyTitle(
                    icon: AppIcon.employee,
                    label: "Total Pegawai",
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "200",
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: const Text(
                      "Pegawai",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                        iconAlignment: IconAlignment.end,
                        icon: Icon(AppIcon.next),
                        onPressed: () {},
                        label: Text("Lihat Semua")),
                  )
                ],
              )),
              AppDatePickerField(
                label: 'Start Date',
                value: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                onChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
              AppTimePickerField(
                label: 'Start Time',
                value: _selectedTime,
                onChanged: (time) {
                  setState(() {
                    _selectedTime = time;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AppTimePickerField extends StatelessWidget {
  final String label;
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay?> onChanged;
  final String? Function(TimeOfDay?)? validator;

  const AppTimePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: value ?? TimeOfDay.now(),
    );

    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<TimeOfDay>(
      initialValue: value,
      validator: validator,
      builder: (field) {
        final text = value == null
            ? ''
            : '${value!.hour.toString().padLeft(2, '0')}:${value!.minute.toString().padLeft(2, '0')}';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              readOnly: true,
              controller: TextEditingController(text: text),
              decoration: InputDecoration(
                labelText: label,
                suffixIcon: const Icon(Icons.access_time),
                errorText: field.errorText,
              ),
              onTap: () async {
                await _pickTime(context);
                field.didChange(value);
              },
            ),
          ],
        );
      },
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
