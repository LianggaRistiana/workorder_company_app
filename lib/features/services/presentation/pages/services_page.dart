import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/services_bloc.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';

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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          // TODO: Aksi ketika service ditekan (misal ke halaman detail)
          // context.read<ServicesBloc>().add(GetServiceByIdRequested(service.id));
        },
      ),
    );
  }
}
