enum FaqDocsType {
  pdf,
  text;

  factory FaqDocsType.fromString(String value) {
    switch (value) {
      case 'pdf':
        return FaqDocsType.pdf;
      case 'Pdf':
        return FaqDocsType.pdf;
      case 'PDF':
        return FaqDocsType.pdf; 
      case 'text':
        return FaqDocsType.text;
      case 'TEXT':
        return FaqDocsType.text;
      default:
        throw Exception('Invalid FaqDocsType value: $value');
    }
  }
}
