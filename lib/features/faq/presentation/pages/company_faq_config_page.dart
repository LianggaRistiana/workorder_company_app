import 'dart:async';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/delete_docs/delete_doc_cubit.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/delete_docs/delete_doc_state.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/get_docs/get_faq_docs_cubit.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/get_docs/get_faq_docs_state.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/toggle_active/toggle_active_faq_cubit.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/toggle_active/toggle_active_faq_state.dart';
import 'package:workorder_company_app/features/faq/presentation/widgets/faq_active_status_switch.dart';
import 'package:workorder_company_app/features/faq/presentation/widgets/faq_doc_item.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class CompanyFaqConfigPage extends StatelessWidget {
  const CompanyFaqConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<GetFaqDocsCubit>()..getDocs(),
          ),
          BlocProvider(
            create: (context) => sl<DeleteDocCubit>(),
          ),
          BlocProvider(
            create: (context) => sl<ToggleActiveFaqCubit>()
              ..initActiveStatus(
                  isActive: false), // TODO : connect to company bloc
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<GetFaqDocsCubit, GetFaqDocsState>(
                listener: (context, state) {
              if (state.status == GetFaqDocsStatus.error) {
                context.showError(state.errorMessage ?? "Terjadi Kesalahan");
              }
            }),
            BlocListener<DeleteDocCubit, DeleteDocState>(
                listener: (context, state) {
              if (state.status == DeleteDocStats.success) {
                context.showSuccess("Berhasil Menghapus Dokumen");
              } else if (state.status == DeleteDocStats.error) {
                context.showError(state.errorMessage ?? "Terjadi Kesalahan");
              }
            }),
            BlocListener<ToggleActiveFaqCubit, ToggleActiveFaqState>(
                listener: (context, state) {
              if (state.errorMessage != null) {
                context.showError(state.errorMessage ??
                    "Terjadi kesalahan saat mengubah status faq");
              }
              // TODO : Update company data here
            }),
          ],
          child: BlocBuilder<GetFaqDocsCubit, GetFaqDocsState>(
              builder: (context, state) {
            final theme = Theme.of(context);
            return ListPageScaffold(
                title: "Fitur Faq",
                floatingActionButtonLocation: ExpandableFab.location,
                floatingActionButton: ExpandableFab(
                  distance: 70,
                  childrenAnimation: ExpandableFabAnimation.none,
                  overlayStyle: ExpandableFabOverlayStyle(
                    color: theme.colorScheme.surface.withAlpha(90),
                  ),
                  openButtonBuilder: RotateFloatingActionButtonBuilder(
                    child: const Icon(AppIcon.add),
                    fabSize: ExpandableFabSize.regular,
                  ),
                  closeButtonBuilder: DefaultFloatingActionButtonBuilder(
                    child: const Icon(Icons.close),
                    fabSize: ExpandableFabSize.small,
                    foregroundColor: theme.colorScheme.onPrimary,
                    backgroundColor: theme.colorScheme.secondary,
                    shape: const CircleBorder(),
                  ),
                  type: ExpandableFabType.up,
                  children: [
                    FloatingActionButton.extended(
                      heroTag: null,
                      onPressed: () => context.push(AppRoutes.addTextFaqDoc),
                      label: Text('Dengan Teks'),
                      icon: Icon(AppIcon.text),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    FloatingActionButton.extended(
                      heroTag: null,
                      onPressed: () => context.push(AppRoutes.addPdfFaqDoc),
                      label: Text('Dengan Pdf'),
                      icon: Icon(AppIcon.file),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ],
                ),
                header: FaqActiveStatusSwitch(),
                isLoading: state.status == GetFaqDocsStatus.loading,
                items: state.docs,
                onRefresh: () async => unawaited(context
                    .read<GetFaqDocsCubit>()
                    .getDocs(forceRefresh: true)),
                itemBuilder: (item) => FaqDocItem(doc: item));
          }),
        ));
  }
}
