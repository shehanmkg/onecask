import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:one_cask/src/core/router/app_router.dart'; // Import AppRouter
import 'package:one_cask/src/data/collection_repository.dart'; // Import CollectionRepository
import 'package:one_cask/src/features/auth/bloc/auth_bloc.dart'; // Import AuthBloc
import 'package:one_cask/src/features/collection/bloc/collection_bloc.dart'; // Import CollectionBloc

void main() {
  // Ensure bindings are initialized before using plugins like shared_preferences
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc;
  late final CollectionRepository _collectionRepository; // Added
  late final CollectionBloc _collectionBloc; // Added
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(); // Create the AuthBloc instance
    _collectionRepository = CollectionRepository(); // Create Repository instance
    _collectionBloc = CollectionBloc(collectionRepository: _collectionRepository); // Create CollectionBloc
    _appRouter = AppRouter(authBloc: _authBloc); // Create the AppRouter instance
  }

  @override
  void dispose() {
    _authBloc.close(); // Close the auth bloc
    _collectionBloc.close(); // Close the collection bloc
    _appRouter.router.dispose(); // Dispose the router resources (like the listener)
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Create text themes with EB Garamond and Lato
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

    // Use MultiBlocProvider to provide all necessary Blocs
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        // Provide CollectionBloc using its repository dependency
        BlocProvider(
          create: (context) => _collectionBloc,
          // Optionally set lazy: false if you need it to load immediately
        ),
      ],
      child: MaterialApp.router(
        title: 'One Cask', // Updated app title
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFDE9A1F), // Updated to exact gold color from screenshots
            primary: const Color(0xFFDE9A1F), // Gold
            secondary: const Color(0xFF83A9B8), // Teal/blue accent
            background: const Color(0xFF001A2C), // Dark blue background
            surface: const Color(0xFF0A1F2E), // Slightly lighter blue for cards
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF001A2C), // Dark blue/teal
            foregroundColor: Color(0xFFDE9A1F), // Gold text
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
              backgroundColor: const Color(0xFFDE9A1F), // Gold
              foregroundColor: Colors.black87, // Dark text on gold buttons
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded corners matching design
              ),
              textStyle: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          tabBarTheme: const TabBarTheme(
            labelColor: Colors.black87, // Selected tab text color
            unselectedLabelColor: Colors.white, // Unselected tab text color
            indicatorColor: Color(0xFFDE9A1F), // Gold indicator
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
              borderSide: const BorderSide(color: Color(0xFFDE9A1F), width: 2), // Updated gold color
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            labelStyle: const TextStyle(fontFamily: 'Lato', color: Colors.white70),
            hintStyle: const TextStyle(fontFamily: 'Lato', color: Colors.white54),
          ),
          textTheme: textTheme,
          fontFamily: 'Lato', // Default font for the app
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false, // Optional: hide debug banner
        routerConfig: _appRouter.router, // Use the go_router configuration
      ),
    );
  }
}
