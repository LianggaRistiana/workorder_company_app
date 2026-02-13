import 'package:flutter_test/flutter_test.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';

void main() {
  const validJson = {
    "_id": "1",
    "name": "Test Company",
    "address": "Test Address",
    "description": "Test Description",
    "isActive": true,
  };

  group("CompanyModel.fromJson", () {
    test("Should parse valid JSON correctly", () {
      final result = CompanyModel.fromJson(validJson);

      expect(result.id, "1");
      expect(result.name, "Test Company");
      expect(result.address, "Test Address");
      expect(result.description, "Test Description");
      expect(result.isActive, true);
    });

    test("Should set default empty string when address is null", () {
      final json = {
        "_id": "1",
        "name": "Test Company",
        "address": null,
        "description": null,
        "isActive": true,
      };

      final result = CompanyModel.fromJson(json);

      expect(result.address, "");
      expect(result.description, "");
    });

    test("Should set default true when isActive is null", () {
      final json = {
        "_id": "1",
        "name": "Test Company",
        "address": "Address",
        "description": "Desc",
        "isActive": null,
      };

      final result = CompanyModel.fromJson(json);

      expect(result.isActive, true);
    });

    test("Should throw TypeError when required field missing", () {
      final invalidJson = {
        "wrong_key": "value"
      };

      expect(
        () => CompanyModel.fromJson(invalidJson),
        throwsA(isA<TypeError>()),
      );
    });

    test("Should throw TypeError when id type invalid", () {
      final invalidJson = {
        "_id": 123, // harusnya String
        "name": "Test Company",
        "isActive": true,
      };

      expect(
        () => CompanyModel.fromJson(invalidJson),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group("CompanyModel.toJson", () {
    test("Should convert model to JSON correctly", () {
      final model = CompanyModel(
        id: "1",
        name: "Test Company",
        address: "Test Address",
        description: "Desc",
        isActive: true,
      );

      final json = model.toJson();

      expect(json["id"], "1");
      expect(json["name"], "Test Company");
      expect(json["address"], "Test Address");
      expect(json["description"], "Desc");
      expect(json["isActive"], true);
    });
  });
}
