import 'package:flutter/material.dart';

class CompanyDetailPage extends StatelessWidget {
  final String companyId;
  const CompanyDetailPage({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(companyId),);
  }
}