part of 'forms_bloc.dart';

sealed class FormsState extends Equatable {
  const FormsState();

  @override
  List<Object?> get props => [];
}

/// State awal ketika belum ada data sama sekali
class FormsInitial extends FormsState {}

/// Loading penuh (biasanya saat halaman pertama kali dibuka)
class FormsLoading extends FormsState {}

/// State utama yang menyimpan list forms dan detail form
class FormsLoaded extends FormsState {
  final List<FormEntity> forms;
  final FormEntity? selectedForm;

  /// Loading tambahan (misalnya sedang ambil detail form, tapi list tetap ada)
  final bool isSubLoading;

  /// Error ringan (misal gagal ambil form detail, tapi list tetap ada)
  final String? errorMessage;

  const FormsLoaded({
    required this.forms,
    this.selectedForm,
    this.isSubLoading = false,
    this.errorMessage,
  });

  FormsLoaded copyWith({
    List<FormEntity>? forms,
    FormEntity? selectedForm,
    bool? isSubLoading,
    String? errorMessage,
  }) {
    return FormsLoaded(
      forms: forms ?? this.forms,
      selectedForm: selectedForm ?? this.selectedForm,
      isSubLoading: isSubLoading ?? this.isSubLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [forms, selectedForm, isSubLoading, errorMessage];
}

/// Error fatal (biasanya untuk initial fetch gagal total)
class FormsError extends FormsState {
  final String message;
  const FormsError(this.message);

  @override
  List<Object?> get props => [message];
}
