import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/faq_config_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/constants/app_enums/faq_enum.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/pdf_item.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/delete_docs/delete_doc_cubit.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/delete_docs/delete_doc_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/confirm_dialog.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

class FaqDocItem extends StatelessWidget {
  final FaqDocEntity doc;

  const FaqDocItem({
    super.key,
    required this.doc,
  });

  void _showDetail(BuildContext context, FaqDocEntity doc) {
    showAppBottomSheet(context,
        content: _DocDetailContent(doc: doc),
        footer: BlocProvider.value(
          value: context.read<DeleteDocCubit>(),
          child: BlocConsumer<DeleteDocCubit, DeleteDocState>(
              listener: (context, state) {
            if (state.status == DeleteDocStats.success) {
              context.pop();
            }
          }, builder: (context, state) {
            final isLoading = state.status == DeleteDocStats.loading;

            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () async {
                    final shouldDelete = await showConfirmDialog(
                        type: ConfirmDialogType.danger,
                        context: context,
                        title: "Anda yakin menghapus berkas ini? ",
                        message: "Aksi ini tidak dapat dikembalikan");
                    if (shouldDelete != true) return;
                    if (!context.mounted) return;
                    context.read<DeleteDocCubit>().deleteDoc(doc);
                  },
                  icon: Icon(
                    AppIcon.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ).require(roleCan(
                  FaqConfigPermission.deleteDocs,
                )),
                if (doc.url != null &&
                    doc.url!.isNotEmpty &&
                    doc.type == FaqDocsType.pdf) ...[
                  Expanded(
                    child: FilledButton(
                        onPressed: () {
                          context.pop();

                          context.push(
                            AppRoutes.previewPdf,
                            extra: PdfItem(
                                filePath: doc.url!,
                                fileName: doc.title,
                                isNetwork: true),
                          );
                        },
                        child: Text("Lihat Berkas")),
                  )
                ],
              ],
            ).withInlineLoading(
              isLoading,
            );
          }),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClickableCustomCard(
        margin: EdgeInsets.only(
          bottom: AppSpacing.sm,
          left: AppSpacing.md,
          right: AppSpacing.md,
        ),
        onTap: () {
          _showDetail(context, doc);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              IconBox.small(
                  icon: doc.type == FaqDocsType.text
                      ? AppIcon.text
                      : AppIcon.file),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                  child: Text(
                doc.title,
                style: theme.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Text(
              doc.content,
              style: theme.textTheme.bodySmall,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ));
  }
}

class _DocDetailContent extends StatelessWidget {
  final FaqDocEntity doc;

  const _DocDetailContent({
    required this.doc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            IconBox.small(
              icon: doc.type == FaqDocsType.text ? AppIcon.text : AppIcon.file,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
                child: Text(
              doc.title,
              style: theme.textTheme.titleMedium,
            )),
          ]),
          const SizedBox(height: AppSpacing.sm),
          Text(
            doc.content,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
