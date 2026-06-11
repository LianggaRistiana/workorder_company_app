import 'package:flutter_test/flutter_test.dart';
import 'package:workorder_company_app/core/error/exceptions.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/faq/data/model/faq_doc_model.dart';
import 'package:workorder_company_app/features/faq/data/model/faq_response_model.dart';
import 'package:workorder_company_app/features/faq/data/model/pdf_faq_doc_model.dart';
import 'package:workorder_company_app/features/faq/data/model/text_faq_doc_model.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/pdf_faq_doc_draft.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/text_faq_doc_draft.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════
  // FaqDocModel.fromJson  │  Cyclomatic Complexity = 1
  //                       │  Paths: parsing success | default mapping
  // ═══════════════════════════════════════════════════════════════════════
  group('FaqDocModel.fromJson —', () {
    /// M1 | Branch: happy path
    /// Expected: parses all fields correctly
    test('M1: fromJson parses all fields correctly from valid JSON', () {
      final json = {
        'id': 101,
        'title': 'How to pair account',
        'content': 'Go to settings and scan QR code',
        'type': 'text',
        'file_url': 'http://company.com/file.pdf',
        'created_at': '2026-06-12T03:00:00.000Z',
      };

      final model = FaqDocModel.fromJson(json);

      expect(model.id, '101');
      expect(model.title, 'How to pair account');
      expect(model.content, 'Go to settings and scan QR code');
      expect(model.type, FaqDocsType.text);
      expect(model.url, 'http://company.com/file.pdf');
      expect(model.createdAt, DateTime.parse('2026-06-12T03:00:00.000Z'));
    });

    /// M2 | Branch: missing required parameter
    /// Expected: throws ParsingException during parsing
    test('M2: fromJson throws ParsingException when required fields are missing', () {
      final json = {
        'id': 101,
        'title': null,
      };

      expect(() => FaqDocModel.fromJson(json), throwsA(isA<ParsingException>()));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // FaqResponseModel.fromJson  │  Cyclomatic Complexity = 1
  //                            │  Paths: parsing success
  // ═══════════════════════════════════════════════════════════════════════
  group('FaqResponseModel.fromJson —', () {
    /// M3 | Branch: happy path
    /// Expected: parses answer correctly
    test('M3: fromJson parses answer correctly from valid JSON', () {
      final json = {'answer': 'Yes, you can kick them.'};

      final model = FaqResponseModel.fromJson(json);

      expect(model.answer, 'Yes, you can kick them.');
    });

    /// M4 | Branch: missing answer key
    /// Expected: throws ParsingException during parsing
    test('M4: fromJson throws ParsingException when answer is missing', () {
      final json = <String, dynamic>{};

      expect(() => FaqResponseModel.fromJson(json), throwsA(isA<ParsingException>()));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // PdfFaqDocModel  │  Cyclomatic Complexity = 1
  //                 │  Paths: toJson | fromDraft
  // ═══════════════════════════════════════════════════════════════════════
  group('PdfFaqDocModel —', () {
    /// M5 | Branch: toJson mapping
    /// Expected: serializes titles and filePath correctly
    test('M5: toJson serializes PDF model fields to correct key names', () {
      final model = PdfFaqDocModel(title: 'PDF Doc', filePath: '/path/to/pdf');

      final json = model.toJson();

      expect(json['title'], 'PDF Doc');
      expect(json['file'], '/path/to/pdf');
    });

    /// M6 | Branch: fromDraft mapping
    /// Expected: maps draft properties directly to model
    test('M6: fromDraft constructs correct model from draft entity', () {
      final draft = PdfFaqDocDraft(title: 'PDF Draft', filePath: '/path/to/pdf/draft');

      final model = PdfFaqDocModel.fromDraft(draft);

      expect(model.title, 'PDF Draft');
      expect(model.filePath, '/path/to/pdf/draft');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // TextFaqDocModel  │  Cyclomatic Complexity = 1
  //                  │  Paths: toJson | fromDraft
  // ═══════════════════════════════════════════════════════════════════════
  group('TextFaqDocModel —', () {
    /// M7 | Branch: toJson mapping
    /// Expected: serializes title and content correctly
    test('M7: toJson serializes Text model fields to correct key names', () {
      final model = const TextFaqDocModel(title: 'Text Doc', content: 'Doc content info');

      final json = model.toJson();

      expect(json['title'], 'Text Doc');
      expect(json['content'], 'Doc content info');
    });

    /// M8 | Branch: fromDraft mapping
    /// Expected: maps draft properties directly to model
    test('M8: fromDraft constructs correct model from draft entity', () {
      final draft = const TextFaqDocDraft(title: 'Text Draft', content: 'Draft content info');

      final model = TextFaqDocModel.fromDraft(draft);

      expect(model.title, 'Text Draft');
      expect(model.content, 'Draft content info');
    });
  });
}
