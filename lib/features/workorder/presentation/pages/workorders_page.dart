import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_bloc.dart';
import 'package:workorder_company_app/features/workorder/presentation/widgets/workorder_item.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';

class WorkordersPage extends StatefulWidget {
  const WorkordersPage({super.key});

  @override
  State<WorkordersPage> createState() => _WorkordersPageState();
}

class _WorkordersPageState extends State<WorkordersPage> {
  @override
  void initState() {
    super.initState();
    context.read<WorkorderBloc>().add(GetWorkordersRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workorders'),
      ),
      body: BlocBuilder<WorkorderBloc, WorkorderState>(
        builder: (context, state) {
          // LOADING
          if (state.status == WorkorderStateStatus.loading &&
              state.workorders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // ERROR
          if (state.status == WorkorderStateStatus.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? "Terjadi kesalahan"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<WorkorderBloc>()
                          .add(GetWorkordersRequested());
                    },
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          }

          // EMPTY
          if (state.workorders.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<WorkorderBloc>().add(GetWorkordersRequested());
              },
              child: ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text("Belum ada pengajuan layanan.")),
                ],
              ),
            );
          }

          // LOADED — WITH PULL TO REFRESH
          return RefreshIndicator(
              onRefresh: () async {
                context.read<WorkorderBloc>().add(GetWorkordersRequested());
              },
              child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: AppSpacing.md,
                          right: AppSpacing.md,
                        ),
                        child: CustomInputField(
                          label: "Cari Workorder",
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),

                      // CustomCard(child: Column(
                      //   children: [
                      //     CustomInputField(
                      //       label: "Cari Workorder",
                      //       prefixIcon: const Icon(Icons.search),
                      //     ),
                      //     const SizedBox(height: 12),
                      //   ]
                      // )),
                      HorizontalButton(
                        margin: const EdgeInsets.all(AppSpacing.md),
                        title: "Riwayat Workorder",
                        description:
                            "Lihat Workorder yang dibatalkan dan telah selesai",
                        leadingIcon: Icons.history,
                        onTap: () {},
                      ),
                      CustomList(
                        scrollable: true,
                        separatorHeight: 0,
                        items: state.workorders,
                        itemBuilder: (item, _) => WorkorderItem(
                          workorder: item,
                          onTap: () {},
                        ),
                      ),
                    ],
                  )));
        },
      ),
    );
  }
}
