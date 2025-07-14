// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:nariii_new/data/remote/auth_api.dart';

// class SignUpForm extends StatefulWidget {
//   const SignUpForm({super.key});
//   static const String routeName = '/sign-up';

//   @override
//   State<SignUpForm> createState() => _SignUpFormState();
// }

// class _SignUpFormState extends State<SignUpForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _fullName = TextEditingController();
//   final _email = TextEditingController();
//   final _phone = TextEditingController();
//   final _password = TextEditingController();

//   bool isLoading = false;
//   String? error;

//   Future<void> _submitRegistration() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       isLoading = true;
//       error = null;
//     });

//     try {
//       final response = await AuthAPI.registerUser(
//         fullName: _fullName.text.trim(),
//         email: _email.text.trim(),
//         phone: _phone.text.trim(),
//         password: _password.text.trim(),
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Registration successful!")),
//         );
//         Navigator.pop(context); // Go back to login
//       } else {
//         setState(() {
//           error = data['message'] ?? 'Registration failed';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         error = 'Something went wrong. Check your internet.';
//       });
//     }

//     setState(() => isLoading = false);
//   }

//   @override
//   void dispose() {
//     _fullName.dispose();
//     _email.dispose();
//     _phone.dispose();
//     _password.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           if (error != null)
//             Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: Text(error!, style: const TextStyle(color: Colors.red)),
//             ),
//           TextFormField(
//             controller: _fullName,
//             decoration: const InputDecoration(labelText: "Full Name"),
//             validator: (val) =>
//                 val == null || val.trim().isEmpty ? "Enter full name" : null,
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: _email,
//             keyboardType: TextInputType.emailAddress,
//             decoration: const InputDecoration(labelText: "Email"),
//             validator: (val) =>
//                 val == null || !val.contains('@') ? "Enter valid email" : null,
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: _phone,
//             keyboardType: TextInputType.phone,
//             decoration: const InputDecoration(labelText: "Phone"),
//             validator: (val) => val == null || val.length != 10
//                 ? "Phone must be 10 digits"
//                 : null,
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: _password,
//             obscureText: true,
//             decoration: const InputDecoration(labelText: "Password"),
//             validator: (val) => val == null || val.length < 6
//                 ? "Min 6 characters required"
//                 : null,
//           ),
//           const SizedBox(height: 20),
//           isLoading
//               ? const CircularProgressIndicator()
//               : ElevatedButton(
//                   onPressed: _submitRegistration,
//                   child: const Text("Register"),
//                 ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import '../../components/socal_card.dart';
import '../../constants.dart';
import 'components/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";

  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
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
                  const Text("Register Account", style: headingStyle),
                  const Text(
                    "Complete your details or continue \nwith social media",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const SignUpForm(),
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
                  const SizedBox(height: 16),
                  Text(
                    'By continuing your confirm that you agree \nwith our Term and Condition',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
