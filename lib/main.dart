import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_cask/src/core/di/service_locator.dart';
import 'package:one_cask/src/core/router/app_router.dart';
import 'package:one_cask/src/features/auth/bloc/auth_bloc.dart';
import 'package:one_cask/src/features/collection/bloc/collection_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc();
    _appRouter = AppRouter(authBloc: _authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    _appRouter.router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme(
      displayLarge: const TextStyle(
        fontFamily: 'EBGaramond',
        fontWeight: FontWeight.w300,
        color: Colors.white,
        fontSize: 40,
      ),
      displayMedium: const TextStyle(
        fontFamily: 'EBGaramond',
        fontWeight: FontWeight.w300,
        color: Colors.white,
        fontSize: 32,
      ),
      titleLarge: const TextStyle(
        fontFamily: 'EBGaramond',
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
      titleMedium: const TextStyle(
        fontFamily: 'Lato',
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      bodyLarge: const TextStyle(
        fontFamily: 'Lato',
        color: Colors.white,
        fontSize: 16,
      ),
      bodyMedium: const TextStyle(
        fontFamily: 'Lato',
        color: Colors.white70,
        fontSize: 16,
      ),
      labelLarge: const TextStyle(
        fontFamily: 'Lato',
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider(
          create: (context) => getIt<CollectionBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'One Cask',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFDE9A1F),
            primary: const Color(0xFFDE9A1F),
            secondary: const Color(0xFF83A9B8),
            background: const Color(0xFF001A2C),
            surface: const Color(0xFF0A1F2E),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF001A2C),
            foregroundColor: Color(0xFFDE9A1F),
            elevation: 0,
            titleTextStyle: TextStyle(
              fontFamily: 'EBGaramond',
              color: Color(0xFFDE9A1F),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDE9A1F),
              foregroundColor: Colors.black87,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          tabBarTheme: const TabBarTheme(
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.white,
            indicatorColor: Color(0xFFDE9A1F),
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(
              fontFamily: 'Lato',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Lato',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFDE9A1F), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            labelStyle: const TextStyle(fontFamily: 'Lato', color: Colors.white70),
            hintStyle: const TextStyle(fontFamily: 'Lato', color: Colors.white54),
          ),
          textTheme: textTheme,
          fontFamily: 'Lato',
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
