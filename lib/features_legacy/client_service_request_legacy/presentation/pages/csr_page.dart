import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features_legacy/client_service_request_legacy/presentation/bloc/internal_client_service_request/internal_csr_bloc.dart';
import 'package:workorder_company_app/features_legacy/client_service_request_legacy/presentation/widgets/service_request_content.dart';
// import 'package:workorder_company_app/shared/widgets/custom_back_buttom.dart';
// import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/core/di/injection.dart'; // getIt

class CsrPage extends StatefulWidget {
  const CsrPage({super.key});

  @override
  State<CsrPage> createState() => _CsrPageState();
}

class _CsrPageState extends State<CsrPage> {
  late final InternalCsrBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<InternalCsrBloc>();
    _bloc.add(GetClientServiceRequestsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child : const ServiceRequestContent(),
      // child: Scaffold(
      //   appBar: AppBar(
      //     title: const Text("Pengajuan Layanan"),
      //     leading: context.canPop() ? const CustomBackButton() : null,
      //     bottom: PreferredSize(
      //       preferredSize: const Size.fromHeight(50),
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      //         child: CustomInputField(
      //           label: "Cari Pengajuan",
      //           prefixIcon: const Icon(Icons.search),
      //         ),
      //       ),
      //     ),
      //   ),
        // body: const ServiceRequestContent(),
      // ),
    );
  }
}
