import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/code_list/membership_code_list_bloc.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/code_list/membership_code_list_event.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/code_list/membership_code_list_state.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/generate_code/generate_membership_code_cubit.dart';
import 'package:workorder_company_app/features/memberships/presentation/widgets/generate_code_widget.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

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
        BlocProvider<GenerateMembershipCodeCubit>(
          create: (_) => sl<GenerateMembershipCodeCubit>(),
        ),
      ],
      child: const _MembershipCodesListView(),
    );
  }
}

class _MembershipCodesListView extends StatelessWidget {
  const _MembershipCodesListView();

  Future<void> _onRefresh(BuildContext context) async {
    context
        .read<MembershipCodeListBloc>()
        .add(GetMembershipCodeListRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MembershipCodeListBloc, MembershipCodeListState>(
        listener: (context, state) {
      if (state.status == MemberShipCodeListStatus.error) {
        context.showError(state.errorMessage ?? "Terjadi Kesalahan");
      }
    }, builder: (context, state) {
      final isLoading = state.status == MemberShipCodeListStatus.loading;
      final items = state.codes;
      final grouped = groupByPrefix(items);
      final groupedList = grouped.entries.toList();

      return ListPageScaffold(
        title: "Kode Langganan",
        isLoading: isLoading,
        items: groupedList,
        header: GenerateCodeWidget(),
        errorMessage: state.errorMessage,
        onRefresh: () => _onRefresh(context),
        loadingMessage: "Memuat Kode Langganan...",
        emptyWidget: EmptyStateWidget(
          text: "Tidak ada kode langganan",
        ),
        itemBuilder: (entry) => MembershipCodeGroupView(
          prefix: entry.key,
          codes: entry.value,
        ),
      );
    });
  }
}

class MembershipCodeGroupView extends StatelessWidget {
  final String prefix;
  final List<MembershipCodeEntity> codes;

  const MembershipCodeGroupView({
    super.key,
    required this.prefix,
    required this.codes,
  });

  Future<void> _copyToClipboard(
    BuildContext context,
    String value,
  ) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    context.showSuccess("Kode berhasil disalin");
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Row(
            children: [
              Expanded(
                child: Text(
                  prefix,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                "${codes.length} kode",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              )
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),

          /// LIST CODES
          ...List.generate(codes.length, (index) {
            final code = codes[index];
            final isLast = index == codes.length - 1;

            return Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _copyToClipboard(context, code.code),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            code.code,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              code.isClaimed
                                  ? "Sudah diklaim"
                                  : "Belum diklaim",
                              style: TextStyle(
                                color: code.isClaimed
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.copy_rounded,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isLast) const Divider(height: 1),
              ],
            );
          }),
        ],
      ),
    );
  }
}

Map<String, List<MembershipCodeEntity>> groupByPrefix(
  List<MembershipCodeEntity> codes,
) {
  final Map<String, List<MembershipCodeEntity>> grouped = {};

  for (final code in codes) {
    final prefix = code.code.split('-').first;

    grouped.putIfAbsent(prefix, () => []);
    grouped[prefix]!.add(code);
  }

  return grouped;
}
