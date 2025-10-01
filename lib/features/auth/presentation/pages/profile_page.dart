import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name: ${user.name}'),
                Text('Email: ${user.email}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        } else if (state is Unauthenticated) {
          // Navigasi ke login menggunakan GoRouter
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login'); // route login kamu
          });
          return const SizedBox.shrink(); // sementara tampil kosong
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
