part of 'positions_bloc.dart';

sealed class PositionsState extends Equatable {
  const PositionsState();

  @override
  List<Object?> get props => [];
}

class PositionsIntial extends PositionsState {}

class PositionsLoading extends PositionsState {}

class PositionsError extends PositionsState {
  final String message;

  const PositionsError(this.message);

  @override
  List<Object?> get props => [message];
}

class PositionsLoaded extends PositionsState {
  final List<PositionEntity> positions;

  const PositionsLoaded(this.positions);

  @override
  List<Object?> get props => [positions];
}
// class PositionsIntial extends PositionsState {}
