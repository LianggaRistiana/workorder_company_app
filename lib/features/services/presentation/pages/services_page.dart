import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/services_bloc.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';

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
        body: BlocBuilder<ServicesBloc, ServicesState>(
          builder: (context, state) {
            if (state is ServicesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ServicesError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is ServicesLoaded) {
              final services = state.services;
              if (services == null || services.isEmpty) {
                return const Center(child: Text('No services available'));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: services.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final service = services[index];
                  return _buildServiceCard(context, service);
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, ServiceEntity service) {
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
          label: Text(service.accessType),
        ),
        onTap: () {
          context.push(AppRoutes.ownerServiceDetail(service.id));
        },
      ),
    );
  }
}
