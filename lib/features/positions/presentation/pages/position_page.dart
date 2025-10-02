import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/positions_bloc.dart';

class PositionsPage extends StatelessWidget {
  const PositionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PositionsBloc>()..add(GetPositionsRequested()),
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
      ),
      body: BlocBuilder<PositionsBloc, PositionsState>(
        builder: (context, state) {
          if (state is PositionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PositionsLoaded) {
            final positions = state.positions;
            if (positions.isEmpty) {
              return const Center(child: Text('No positions found.'));
            }
            return ListView.builder(
              itemCount: positions.length,
              itemBuilder: (context, index) {
                final position = positions[index];
                return ListTile(
                  title: Text(position.name),
                );
              },
            );
          } else if (state is PositionsError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
