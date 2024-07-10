import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/data/utils/constants/app_routes.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_states.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final AuthCubit authCubit;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    authCubit = BlocProvider.of<AuthCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        leading: GestureDetector(
          onTap: () {
            Navigator.popAndPushNamed(context, AppRoutes.login);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32
                    )
                  ),
                ),
              ),
              const SizedBox(height: 80),
        
              // ==================================
              // ========== Email Field ===========
              // ==================================
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email Address',
                    style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16
                      )
                    ),
                  ),
                  const SizedBox(height: 16,),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'email@test.com',
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)
                      )
                    ),
                  )
                ],
              ),
              // ==================================
              // ==================================
              // ==================================
        
              const SizedBox(height: 20),
        
              // ==================================
              // ========= Password Field =========
              // ==================================
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password',
                    style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16
                      )
                    ),
                  ),
                  const SizedBox(height: 16,),
                  TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)
                      )
                    ),
                  )
                ],
              ),
              // ==================================
              // ==================================
              // ==================================
        
              const SizedBox(height: 50),
        
              // ==================================
              // ========== Login Button ==========
              // ==================================
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is LoadingAuthState) {
                    // Show a loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is ErrorAuthState) {
                    // Show an error message
                    Navigator.pop(context); 
                    Fluttertoast.showToast(
                      msg: state.message,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                      fontSize: 14.0,
                    );
                  } else if (state is LoggedInAuthState) {
                    // Navigate to the home screen
                    Navigator.pop(context); 
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  }
                },
                builder: (context, state) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    minimumSize: const Size(double.infinity, 60),
                    elevation: 0,
                  ),
                  onPressed: () {
                    authCubit.register(
                      _emailController.text,
                      _passwordController.text,
                    );
                  },
                  child: Text(
                    "Register", 
                      style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      )
                    ),
                  ),
                ),
              ),
              // ==================================
              // ==================================
              // ==================================
            ],
          ),
        ),
      ),
    );
  }
}
