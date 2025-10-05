import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/positions_bloc.dart';

class PositionsPage extends StatelessWidget {
  const PositionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PositionsBloc>()..add(GetPositionsRequested()),
      child: const _PositionsView(),
    );
  }
}

class _PositionsView extends StatelessWidget {
  const _PositionsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Positions'),
        centerTitle: true,
      ),
      body: BlocBuilder<PositionsBloc, PositionsState>(
        builder: (context, state) {
          if (state is PositionsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PositionsLoaded) {
            final positions = state.positions;

            if (positions.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada posisi.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return Stack(
              children: [
                ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: positions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final position = positions[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade50,
                          child: const Icon(
                            Icons.work_outline,
                            color: Colors.blueAccent,
                          ),
                        ),
                        title: Text(
                          position.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          // nanti arahkan ke detail/edit posisi
                        },
                      ),
                    );
                  },
                ),

                if (state is PositionsLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }

          if (state is PositionsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // nanti arahkan ke halaman tambah posisi
        },
        label: const Text('Tambah Posisi'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
