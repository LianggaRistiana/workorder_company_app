import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';

// TODO : Test with all type of field
class FilledFormView extends StatelessWidget {
  final FilledFormEntity filledForm;

  const FilledFormView({
    super.key,
    required this.filledForm,
  });

  Map<String, dynamic> get _answersMap {
    final submission = filledForm.submission;

    if (submission?.fieldsData == null) {
      return {};
    }

    return {
      for (final item in submission!.fieldsData!) item.order: item.value,
    };
  }

  @override
  Widget build(BuildContext context) {
    final fields = filledForm.form.fields ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FormHeader(filledForm: filledForm),
        const SizedBox(height: 8),
        if (fields.isNotEmpty)
          CustomCard(
            margin: const EdgeInsets.all(0),
            child: Column(
              children: List.generate(
                fields.length,
                (index) {
                  final field = fields[index];

                  return Column(
                    children: [
                      _FieldSection(
                        field: field,
                        answer: _answersMap[field.order.toString()],
                      ),
                      if (index != fields.length - 1) const Divider(height: 1),
                    ],
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _FormHeader extends StatelessWidget {
  final FilledFormEntity filledForm;

  const _FormHeader({
    required this.filledForm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.center,
                colors: [
                  theme.colorScheme.primaryFixedDim,
                  theme.colorScheme.primary,
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const SizedBox(height: 1),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  filledForm.form.title,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  filledForm.form.description,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldSection extends StatelessWidget {
  final FieldEntity field;
  final dynamic answer;

  const _FieldSection({
    required this.field,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          _FieldAnswer(
            field: field,
            answer: answer,
          ),
        ],
      ),
    );
  }
}

class _FieldAnswer extends StatelessWidget {
  final FieldEntity field;
  final dynamic answer;

  const _FieldAnswer({
    required this.field,
    required this.answer,
  });

  bool _isEmpty(dynamic value) {
    return value == null || value.toString().trim().isEmpty;
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }

  Widget _textAnswer(String answer) {
    return SizedBox(
      width: double.infinity,
      child: Text(answer.isEmpty ? '-' : answer),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (field.type) {
      case FieldType.text:
      case FieldType.textarea:
      case FieldType.number:
        return _textAnswer(
          _isEmpty(answer) ? '-' : answer.toString(),
        );

      case FieldType.email:
        if (_isEmpty(answer)) {
          return _textAnswer('-');
        }

        return GestureDetector(
          onTap: () {},
          child: Text(
            answer.toString(),
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        );

      case FieldType.date:
        final date = _parseDate(answer);

        if (date == null) {
          return _textAnswer(answer?.toString() ?? '-');
        }

        return _textAnswer(
          DateFormat(
            'd MMMM yyyy',
            'id_ID',
          ).format(date.toLocal()),
        );

      case FieldType.time:
        final date = _parseDate(answer);

        if (date == null) {
          return _textAnswer(answer?.toString() ?? '-');
        }

        final time = TimeOfDay.fromDateTime(date);

        return _textAnswer(
          time.format(context),
        );

      case FieldType.singleSelect:
        return _OptionAnswer(
          options: field.options ?? [],
          answers: <String>[answer.toString()],
        );

      case FieldType.multiSelect:
        final answers = answer is List
            ? answer
                .where((e) => e != null)
                .map<String>((e) => e.toString())
                .toList()
            : <String>[];

        return _OptionAnswer(
          options: field.options ?? [],
          answers: answers,
        );

      case FieldType.image:
        return _ImageAnswer(
          path: answer is String ? answer : null,
        );
    }
  }
}

class _OptionAnswer extends StatelessWidget {
  final List<OptionEntity> options;
  final List<String> answers;

  const _OptionAnswer({
    required this.options,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return const Text('-');
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((opt) {
        final isSelected = answers.contains(opt.key);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                size: 20,
                color: isSelected ? theme.colorScheme.primary : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(opt.value),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// class _ImageAnswer extends StatelessWidget {
//   final String? path;

//   const _ImageAnswer({
//     required this.path,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: AspectRatio(
//         aspectRatio: 1,
//         child: path == null || path!.isEmpty
//             ? Center(
//                 child: Icon(
//                   Icons.broken_image_rounded,
//                   color: theme.disabledColor,
//                 ),
//               )
//             : Image.network(
//                 path!,
//                 fit: BoxFit.cover,
//                 loadingBuilder: (
//                   context,
//                   child,
//                   loadingProgress,
//                 ) {
//                   if (loadingProgress == null) {
//                     return child;
//                   }

//                   return const SmartShimmer();
//                 },
//                 errorBuilder: (_, __, ___) {
//                   return const Center(
//                     child: Icon(Icons.broken_image),
//                   );
//                 },
//               ),
//       ),
//     );
//   }

// TODO : Test This Image Field Viewer
class _ImageAnswer extends StatelessWidget {
  final String? path;

  const _ImageAnswer({
    required this.path,
  });

  void _showFullscreenImage(BuildContext context) {
    if (path == null || path!.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: InteractiveViewer(
                      minScale: 0.8,
                      maxScale: 5,
                      child: Image.network(
                        path!,
                        fit: BoxFit.contain,
                        loadingBuilder: (
                          context,
                          child,
                          loadingProgress,
                        ) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return const SmartShimmer();
                        },
                        errorBuilder: (_, __, ___) {
                          return const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.white,
                              size: 48,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  /// Close button
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 12,
                    right: 12,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isInvalid = path == null || path!.isEmpty;

    return GestureDetector(
      onTap: isInvalid ? null : () => _showFullscreenImage(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 1,
          child: isInvalid
              ? Center(
                  child: Icon(
                    Icons.broken_image_rounded,
                    color: theme.disabledColor,
                  ),
                )
              : Hero(
                  tag: path!,
                  child: Image.network(
                    path!,
                    fit: BoxFit.cover,
                    loadingBuilder: (
                      context,
                      child,
                      loadingProgress,
                    ) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return const SmartShimmer();
                    },
                    errorBuilder: (_, __, ___) {
                      return const Center(
                        child: Icon(Icons.broken_image),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
