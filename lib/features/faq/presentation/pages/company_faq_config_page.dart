import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/get_docs/get_faq_docs_cubit.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/get_docs/get_faq_docs_state.dart';
import 'package:workorder_company_app/features/faq/presentation/widgets/faq_doc_item.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_switch.dart';
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
        ],
        child: BlocConsumer<GetFaqDocsCubit, GetFaqDocsState>(
            listener: (context, state) {},
            builder: (context, state) {
              return ListPageScaffold(
                  title: "Fitur Faq",
                  header: HorizontalSwitch(
                      margin: EdgeInsets.only(
                        bottom: AppSpacing.sm,
                        left: AppSpacing.md,
                        right: AppSpacing.md,
                      ),
                      leadingIcon: AppIcon.qna,
                      title: "Aktifkan fitur tanya jawab",
                      description:
                          "Saat diaktifkan, pelanggan dapat menggunakan fitur tanya jawab untuk membantu menjawab pertanyaan mereka",
                      value: false,
                      onChanged: (_) {}),
                  isLoading: state.status == GetFaqDocsStatus.loading,
                  items: state.docs,
                  onRefresh: () async => unawaited(context
                      .read<GetFaqDocsCubit>()
                      .getDocs(forceRefresh: true)),
                  itemBuilder: (item) => FaqDocItem(doc: item));
            }));
  }
}
