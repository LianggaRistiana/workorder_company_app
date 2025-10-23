import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/services_bloc.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/presentation/pages/services/services_skeleton.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
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
              title: const Text('Services'),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
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
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: CustomList(
                                items: services,
                                emptyFooterHeight: 20,
                                scrollable: true,
                                isReorderable: false,
                                itemBuilder: (service, _) =>
                                    _buildServiceCard(service)),
                          );
                        }
                        return SizedBox.shrink();
                      }));
                },
              ),
            )));
  }

  Widget _buildServiceCard(ServiceEntity service) {
    return CustomCard(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        title: Text(
          service.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          service.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Chip(
          label: Text(service.accessType.toString()),
        ),
        onTap: () {
          context.push(AppRoutes.ownerServiceDetail(service.id));
        },
      ),
    );
  }
}
