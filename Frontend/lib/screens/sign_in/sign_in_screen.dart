// import 'package:flutter/material.dart';
// import 'package:nariii_new/services/api_service.dart';
// // import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Not used with ApiService

// class SignInScreen extends StatefulWidget {
//   const SignInScreen({super.key});
//   static const String routeName = '/sign-in';

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _email = TextEditingController();
//   final _password = TextEditingController();
//   // final storage = const FlutterSecureStorage(); // Not used with ApiService

//   static const String _connectionError = 'Something went wrong. Check your connection.';
//   bool isLoading = false;
//   String? error;

//   Future<void> _submitLogin() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       isLoading = true;
//       error = null;
//     });

//     try {
//       bool success = await ApiService.login(_email.text.trim(), _password.text.trim());
//       if (success) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Login successful!")),
//         );
//         Navigator.pushReplacementNamed(context, '/home'); // TODO: Define '/home' route
//       }
//       // ApiService.login throws an exception on failure, so no 'else' block is needed here for success=false.
//     } on Exception catch (e) {
//       // Display the error message from the exception
//       setState(() {
//         error = e.toString().replaceFirst('Exception: ', ''); // Clean up the exception message
//       });
//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign In'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (error != null)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: Text(error!, style: const TextStyle(color: Colors.red, fontSize: 16)),
//                 ),
//               TextFormField(
//                 controller: _email,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   hintText: "Enter your email",
//                   border: OutlineInputBorder(),
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty || !value.contains('@')) {
//                     return "Enter a valid email";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _password,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: "Password",
//                   hintText: "Enter your password",
//                   border: OutlineInputBorder(),
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty || value.length < 6) {
//                     return "Password must be at least 6 characters";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: const Size(double.infinity, 48), // Make button wider
//                       ),
//                       onPressed: _submitLogin,
//                       child: const Text("Continue"),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import '../../components/no_account_text.dart';
import '../../components/socal_card.dart';
import 'components/sign_form.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";

  const SignInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Sign in with your email and password  \nor continue with social media",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const SignForm(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocalCard(
                        icon: "assets/icons/google-icon.svg",
                        press: () {},
                      ),
                      SocalCard(
                        icon: "assets/icons/facebook-2.svg",
                        press: () {},
                      ),
                      SocalCard(
                        icon: "assets/icons/twitter.svg",
                        press: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
