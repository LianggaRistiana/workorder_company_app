import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/code_list/membership_code_list_bloc.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/code_list/membership_code_list_event.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/code_list/membership_code_list_state.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/delete/delete_membership_code_cubit.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/delete/delete_membership_code_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';
import 'package:workorder_company_app/shared/widgets/shimmer_placeholder.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';

class MembershipCodesListPage extends StatelessWidget {
  const MembershipCodesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MembershipCodeListBloc>(
          create: (_) => sl<MembershipCodeListBloc>()
            ..add(GetMembershipCodeListRequested()),
        ),
        BlocProvider<DeleteMembershipCodeCubit>(
          create: (_) => sl<DeleteMembershipCodeCubit>(),
        ),
      ],
      child: const _MembershipCodesListView(),
    );
  }
}

class _MembershipCodesListView extends StatelessWidget {
  const _MembershipCodesListView();

  Future<void> _onRefresh(BuildContext context) async {
    context.read<MembershipCodeListBloc>().add(
          GetMembershipCodeListRequested(),
        );
  }

  Future<void> _copyToClipboard(
    BuildContext context,
    String text,
  ) async {
    await Clipboard.setData(
      ClipboardData(text: text),
    );

    if (!context.mounted) return;

    context.showSuccess('Kode berhasil disalin');
  }

  void _showAction(
    BuildContext context, {
    required MembershipCodeEntity item,
  }) {
    showAppBottomSheet(
      context,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TokenInfo(token: item, onTap: null),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  await _copyToClipboard(context, item.token);

                  if (!context.mounted) return;

                  context.pop();
                },
                icon: const Icon(Icons.copy_outlined),
                label: const Text('Salin Kode'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  context.pop();
                  context.read<DeleteMembershipCodeCubit>().delete(item);
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                label: Text(
                  'Hapus',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MembershipCodeListBloc, MembershipCodeListState>(
          listener: (context, state) {
            if (state.status == MemberShipCodeListStatus.error) {
              context.showError(
                state.errorMessage ?? "Terjadi Kesalahan",
              );
            }
          },
        ),
        BlocListener<DeleteMembershipCodeCubit, DeleteMembershipCodeState>(
          listener: (context, state) {
            final deletedCode = state.deletedCode;

            if (state.status == DeleteMembershipCodeStatus.success &&
                deletedCode != null) {
              context.showSuccess('Kode berhasil dihapus');

              context.read<MembershipCodeListBloc>().add(
                    DeleteMembershipCodeRequested(deletedCode.id),
                  );
            }

            if (state.status == DeleteMembershipCodeStatus.failure) {
              context.showError(
                state.errorMessage ?? 'Gagal menghapus kode',
              );
            }
          },
        ),
      ],
      child: BlocBuilder<MembershipCodeListBloc, MembershipCodeListState>(
        builder: (context, state) {
          final isLoading = state.status == MemberShipCodeListStatus.loading;

          final items = state.codes;

          return ListPageScaffold(
            title: "Kode Langganan",
            isLoading: isLoading,
            items: items,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final codes = await context.push<List<MembershipCodeEntity>?>(
                  AppRoutes.uploadMemberCode,
                );

                if (codes == null) return;
                if (!context.mounted) return;

                context.read<MembershipCodeListBloc>().add(
                      AddMembershipCodeRequested(codes),
                    );
              },
              child: const Icon(AppIcon.add),
            ),
            header: _InfoToConfig(),
            errorMessage: state.errorMessage,
            onRefresh: () => _onRefresh(context),
            loadingMessage: "Memuat Kode Langganan...",
            emptyWidget: const EmptyStateWidget(
              text: "Tidak ada kode langganan",
            ),
            itemBuilder: (item) => BlocBuilder<DeleteMembershipCodeCubit,
                DeleteMembershipCodeState>(
              buildWhen: (previous, current) {
                final prevId = previous.deletingCode?.id;
                final currId = current.deletingCode?.id;

                return prevId == item.id || currId == item.id;
              },
              builder: (context, deleteState) {
                final isDeleting =
                    deleteState.status == DeleteMembershipCodeStatus.loading &&
                        deleteState.deletingCode?.id == item.id;

                if (isDeleting) {
                  return const Padding(
                    padding: EdgeInsets.all(8),
                    child: SmartShimmer(
                      placeholders: [
                        ShimmerPlaceholder(height: 90, width: double.infinity)
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _TokenInfo(
                    token: item,
                    onTap: () {
                      _showAction(context, item: item);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _InfoToConfig extends StatelessWidget {
  const _InfoToConfig();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        InformationBlock(
          message:
              "Pastikan Integrasi sistem aktif dan dalam mode klaim kode, agar kustomer anda dapat menautkan akun mereka ke sistem kami melalui token anda",
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          iconAlignment: IconAlignment.end,
          icon: const Icon(AppIcon.next),
          label: const Text("Konfigurasi"),
          onPressed: () {
            context.push(AppRoutes.systemIntegrationConfig);
          },
        ),
      ]),
    );
  }
}

class _TokenInfo extends StatelessWidget {
  final MembershipCodeEntity token;
  final VoidCallback? onTap;

  const _TokenInfo({
    required this.token,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClickableCustomCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(token.token,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, fontFamily: "monospace")),
            const Divider(
              thickness: 0.4,
              height: 20,
            ),
            Row(children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(token.externalCustomerName.substring(0, 1)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(token.externalCustomerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(token.externalCustomerEmail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontStyle: FontStyle.italic,
                            )),
                  ],
                ),
              )
            ]),
          ],
        ));
  }
}
