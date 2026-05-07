import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/submissions/presentation/cubit/file_upload_progress_cubit.dart';
import 'package:workorder_company_app/features/submissions/presentation/cubit/file_upload_progress_state.dart';

// NOTE : UI for global state uploading state. remove it if there is no need
class UploadLoadingState extends StatelessWidget {
  const UploadLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileUploadProgressCubit, FileUploadProgressState>(
      buildWhen: (prev, curr) => prev.tasks != curr.tasks,
      builder: (context, state) {
        if (state.tasks.isEmpty) {
          return const SizedBox.shrink();
        }

        return _buildLoadingIndicator(context, state);
      },
    );
  }

  Widget _buildLoadingIndicator(
    BuildContext context,
    FileUploadProgressState state,
  ) {
    final progress = state.totalProgress;
    final isDone = state.isAllDone;
    final hasError = state.hasError;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: _buildIndicator(context, progress, isDone, hasError),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "${state.uploadState} ${state.progressMessage}",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(
    BuildContext context,
    double? progress,
    bool isDone,
    bool hasError,
  ) {
    if (hasError) {
      return Icon(
        Icons.error,
        size: 16,
        color: Theme.of(context).colorScheme.error,
      );
    }

    if (isDone) {
      return Icon(
        Icons.check,
        size: 16,
        color: Theme.of(context).colorScheme.primary,
      );
    }

    return CircularProgressIndicator(
      value: progress == 0 ? null : progress,
      strokeWidth: 2,
      valueColor: AlwaysStoppedAnimation(
        Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
