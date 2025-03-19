import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'utils/themes.dart';  // Fix: Use relative path instead of package path

import 'controllers/auth_controller.dart';
import 'views/auth/login_screen.dart';
import 'views/bhub/bhub_list_screen.dart';
import 'views/bhub/bhub_detail_screen.dart';
import 'views/payment/payment_screen.dart';
import 'views/payment/payment_history_screen.dart';
import 'views/profile/profile_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GoogleSignIn().signInSilently();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,  // Added dark theme
        themeMode: ThemeMode.light,    // System default theme
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/bhubs': (context) => const BHubListScreen(),
          '/bhub_detail': (context) => const BHubDetailScreen(),
          '/payment': (context) => Builder(builder: (context) {
                final args = ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>;
                return PaymentScreen(
                  bhubId: args['bhubId'],
                  amount: args['amount'],
                );
              }),
          '/payment_history': (context) => const PaymentHistoryScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
