import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            // Bisa pakai snackbar atau dialog loading
            debugPrint("Logging in...");
          } else if (state is Authenticated) {
            // Kalau login sukses, navigate ke halaman utama
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppRadius.large),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppRadius.large),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();

                            if (email.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Email dan password wajib diisi")),
                              );
                              return;
                            }

                            context.read<AuthBloc>().add(
                                  LoginRequested(
                                    email,
                                    password,
                                  ),
                                );
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          )
                        : const Text('Login'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:workorder_company_app/core/theme/app_radius.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(AppRadius.large))
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(AppRadius.large))
//                   ),
                  
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 32),
//               ElevatedButton(
//                 onPressed: () {
//                   // TODO: implement login logic
//                 },
//                 child: const Text('Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

