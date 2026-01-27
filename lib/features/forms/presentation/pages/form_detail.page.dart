import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/forms_bloc.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/form_field_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_back_buttom.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class FormDetailPage extends StatefulWidget {
  final String formId;

  const FormDetailPage({super.key, required this.formId});

  @override
  State<FormDetailPage> createState() => _FormDetailPageState();
}

class _FormDetailPageState extends State<FormDetailPage> {
  late final FormsBloc _formsBloc;

  @override
  void initState() {
    super.initState();
    _formsBloc = GetIt.I<FormsBloc>()..add(GetFormByIdRequested(widget.formId));
  }

  @override
  void dispose() {
    _formsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormsBloc, FormsState>(
      bloc: _formsBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            // title: Text(appBarTitle),
            centerTitle: true,
            leading: CustomBackButton(),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, FormsState state) {
    if (state is FormsLoading || state is FormsInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is FormsError) {
      return _buildErrorState(state.message);
    }

    if (state is FormsLoaded) {
      if (state.isSubLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final form = state.selectedForm;
      if (form == null) {
        return _buildErrorState(state.errorMessage ?? "Form not found");
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon
                IconBox(icon: Icons.assignment_turned_in_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        form.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ---- Description ----
            CustomCard(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InformationBlock(
                    message: 'Formulir ${form.formType.displayName}'),
                const SizedBox(height: 12),
                Text(
                  form.description.isEmpty
                      ? 'Tidak ada deskripsi'
                      : form.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            )),
            Text(
              'Pertanyaan',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const Divider(thickness: 1),

            // TODO : refactor using custom list
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: form.fields?.length ?? 0,
              itemBuilder: (context, index) {
                final field = form.fields![index];
                return FormFieldCard(field: field);
              },
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
