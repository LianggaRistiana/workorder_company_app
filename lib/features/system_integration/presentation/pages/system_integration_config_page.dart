import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/system_integration_config.dart/system_integration_config_cubit.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/system_integration_config.dart/system_integration_config_state.dart';
import 'package:workorder_company_app/features/system_integration/presentation/controller/system_integration_config_controllers.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/custom_switch_tile.dart';
import 'package:workorder_company_app/shared/widgets/header_of_page.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class SystemIntegrationConfigPage extends StatefulWidget {
  const SystemIntegrationConfigPage({super.key});

  @override
  State<SystemIntegrationConfigPage> createState() =>
      _SystemIntegrationConfigPageState();
}

class _SystemIntegrationConfigPageState
    extends State<SystemIntegrationConfigPage> {
  late final SystemIntegrationConfigControllers _controllers;
  bool _isInitialized = false;
  bool _showSecretKey = false;

  @override
  void initState() {
    super.initState();
    _controllers = SystemIntegrationConfigControllers.create();
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<SystemIntegrationConfigCubit>()..loadProviderIntegrationData(),
      child: BlocConsumer<SystemIntegrationConfigCubit,
          SystemIntegrationConfigState>(
        listener: (context, state) {
          final data = state.providerIntegrationData;

          if (!_isInitialized && state.isLoaded && data != null) {
            _controllers.initValues(data);
            _isInitialized = true;
          }

          if (state.hasAnyError) {
            context.showError(state.errorMessage ?? "Terjadi kesalahan");
          } else if (state.isUpdateSuccess) {
            context.showSuccess("Berhasil menyimpan data");
          }
        },
        builder: (context, state) {
          final data = state.providerIntegrationData;

          return Scaffold(
              appBar: AppBar(),
              body: SafeArea(
                  child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    children: [
                      HeaderOfPage(
                          title: 'Konfigurasi Integrasi sistem',
                          icon: AppIcon.systemIntegration),
                      Text(
                          "Hubungkan sistem internal perusahaan anda dengan platform kami agar pelanggan dapat mengaitkan akun mereka dan memperoleh akses ke layanan khusus pelanggan secara otomatis."),
                      const SizedBox(height: AppSpacing.md),
                      const Divider(),
                      const SizedBox(height: AppSpacing.md),
                      if (state.isLoading)
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 120),
                            child: AppLoading())
                      else ...[
                        ..._buildFormView(),
                        const SizedBox(height: AppSpacing.md),
                        InformationBlock.info(
                            "Pastikan URL dan secret key yang dimasukkan valid dan dapat diakses oleh sistem kami untuk memastikan proses integrasi berjalan dengan aman dan lancar.")
                      ],
                      const SizedBox(height: AppSpacing.md),
                      const Divider(),
                      TextButton(
                          onPressed: () {},
                          child: Text("Dokumentasi Pengembang")),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
              )),
              bottomNavigationBar: state.isLoading
                  ? null
                  : SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md),
                        child: ButtonWithLoadingState(
                          icon: AppIcon.submit,
                          onPressed: () {
                            if (data == null) {
                              context.showError("Data tidak ditemukan");
                              return;
                            }
                            if (!_controllers.isDirty(data)) {
                              context.showWarning("Data belum berubah");
                              return;
                            }
                            context
                                .read<SystemIntegrationConfigCubit>()
                                .updateProviderIntegrationData(
                                  _controllers.buildData,
                                );
                          },
                          isLoading: state.isUpdateLoading,
                          label: "Simpan data",
                        ),
                      ),
                    ));
        },
      ),
    );
  }

  List<Widget> _buildFormView() {
    return [
      ValueListenableBuilder<bool>(
        valueListenable: _controllers.isIntegrationActive,
        builder: (context, isActive, child) {
          return CustomSwitchTile(
            title: "Integrasi Sistem",
            description:
                "Saat diaktifkan, kustomer anda dapat menghubungkan akun mereka ke akun di sistem anda",
            value: isActive,
            onChanged: (value) {
              _controllers.isIntegrationActive.value = value;
            },
          );
        },
      ),
      const SizedBox(height: AppSpacing.md),
      CustomInputField(
        label: "Eksternal Login Url",
        controller: _controllers.externalLoginUrl,
        description:
            "URL halaman login sistem perusahaan yang akan digunakan pelanggan saat menghubungkan akun mereka.",
      ),
      const SizedBox(height: AppSpacing.md),
      CustomInputField(
        label: "Eksternal Verify Account Url",
        controller: _controllers.externalVerifyUrl,
        description:
            "URL yang digunakan sistem kami untuk memverifikasi akun pelanggan pada sistem perusahaan anda.",
      ),
      const SizedBox(height: AppSpacing.md),
      CustomInputField(
        label: "Eksternal Check Status Memberships Url",
        controller: _controllers.externalCheckStatusMembershipsUrl,
        description:
            "URL yang digunakan untuk memeriksa status membership atau keanggotaan pelanggan pada sistem perusahaan anda.",
      ),
      const SizedBox(height: AppSpacing.md),
      CustomInputField(
        label: "Secret Key",
        controller: _controllers.secretKey,
        description:
            "Kunci rahasia yang digunakan untuk mengamankan komunikasi antara sistem perusahaan anda dan platform kami.",
        obscureText: !_showSecretKey,
        suffixIcon: IconButton(
          icon: Icon(
            _showSecretKey ? LucideIcons.eye : LucideIcons.eyeOff,
          ),
          onPressed: () {
            setState(() {
              _showSecretKey = !_showSecretKey;
            });
          },
        ),
      ),
    ];
  }
}
