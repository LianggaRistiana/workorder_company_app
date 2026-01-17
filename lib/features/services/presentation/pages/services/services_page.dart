import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/services_bloc.dart';
import 'package:workorder_company_app/features/services/presentation/pages/services/services_skeleton.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_item.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late final ServicesBloc _servicesBloc;

  @override
  void initState() {
    super.initState();
    _servicesBloc = sl<ServicesBloc>()..add(GetServicesRequested());
  }

  @override
  void dispose() {
    _servicesBloc.close();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _servicesBloc.add(GetServicesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value:
            _servicesBloc, // <-- ini yang bikin BlocBuilder bisa menemukan bloc-nya
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Layanan'),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                final result = await context.push(AppRoutes.ownerNewService);
                if (result == true && context.mounted) {
                  // TODO: pindahkan bloc ke multi prov global agar bisa auto refresh
                  // context.read<ServicesBloc>().add(GetServicesRequested());
                }
              },
              label: const Text("Tambah Layanan"),
              icon: const Icon(Icons.add),
            ),
            body: BlocListener<ServicesBloc, ServicesState>(
              listener: (context, state) {
                if (state is ServicesError) {
                  context.showError(state.message);
                }
              },
              child: BlocBuilder<ServicesBloc, ServicesState>(
                builder: (context, state) {
                  return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: Builder(builder: (context) {
                        if (state is ServicesLoading) {
                          return ServicesSkeleton();
                        }

                        if (state is ServicesError) {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  0.8, // biar cukup untuk scroll gesture
                              child: const Center(
                                child: EmptyStateWidget(
                                  icon: Icons.warning_rounded,
                                  text: "Ada Kesalahan",
                                ),
                              ),
                            ),
                          );
                        }

                        if (state is ServicesLoaded) {
                          final services = state.services;
                          if (services == null || services.isEmpty) {
                            return SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: const Center(
                                  child: EmptyStateWidget(
                                    icon: Icons.warning_rounded,
                                    text: "Tidak ada Layanan",
                                  ),
                                ),
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md),
                            child: CustomList(
                                items: services,
                                emptyFooterHeight: 20,
                                separatorHeight: AppSpacing.sm,
                                scrollable: true,
                                isReorderable: false,
                                itemBuilder: (service, _) => ServiceItem(
                                    service: service,
                                    isPublic: false,
                                    onTap: () {
                                      context.push(AppRoutes.ownerServiceDetail(
                                          service.id));
                                    })),
                          );
                        }
                        return SizedBox.shrink();
                      }));
                },
              ),
            )));
  }
}
