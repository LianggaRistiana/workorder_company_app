import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/positions_bloc.dart';

class PositionWrapper extends StatelessWidget {
  final Widget child;
  const PositionWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<PositionsBloc>()),
      ],
      child: child,
    );
  }
}
