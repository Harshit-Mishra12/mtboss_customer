import 'dart:developer';
import 'dart:io';

import 'package:fixit_user/helper/notification.dart';
import 'package:fixit_user/providers/app_pages_providers/audio_call_provider.dart';
import 'package:fixit_user/providers/app_pages_providers/job_request_providers/add_job_request_provider.dart';
import 'package:fixit_user/providers/app_pages_providers/job_request_providers/job_request_details_provider.dart';
import 'package:fixit_user/providers/app_pages_providers/video_call_provider.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'common/theme/app_theme.dart';
import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();
  if (Platform.isAndroid) {
    log("app android ");
    await Firebase.initializeApp(
        name: "Your Firebase Project Name",
        options: const FirebaseOptions(
            apiKey: "Your Firebase API Key",
            appId: "Your Firebase AndroidApp Id",
            messagingSenderId: "Your Firebase Messaging Sender Id",
            projectId: "Your Firebase Project Id"));
  } else {
    log("app IOS");
    await Firebase.initializeApp(
        name: "Mtboss",
        options: const FirebaseOptions(
            apiKey: "Your Firebase API Key",
            appId: "Your Firebase IOS App Id",
            messagingSenderId: "Your Firebase Messaging Sender Id",
            projectId: "Your Firebase Project Id"));
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    lockScreenPortrait();
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context1, AsyncSnapshot<SharedPreferences> snapData) {
          if (snapData.hasData) {
            return MultiProvider(providers: [
              ChangeNotifierProvider(
                  create: (_) => ThemeService(snapData.data!, context)),
              ChangeNotifierProvider(create: (_) => SplashProvider()),
              ChangeNotifierProvider(create: (_) => CommonApiProvider()),
              ChangeNotifierProvider(create: (_) => OnBoardingProvider()),
              ChangeNotifierProvider(create: (_) => LoginProvider()),
              ChangeNotifierProvider(create: (_) => LoginWithPhoneProvider()),
              ChangeNotifierProvider(create: (_) => VerifyOtpProvider()),
              ChangeNotifierProvider(create: (_) => ForgetPasswordProvider()),
              ChangeNotifierProvider(create: (_) => RegisterProvider()),
              ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
              ChangeNotifierProvider(create: (_) => LoadingProvider()),
              ChangeNotifierProvider(create: (_) => DashboardProvider()),
              ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
              ChangeNotifierProvider(create: (_) => ProfileProvider()),
              ChangeNotifierProvider(
                  create: (_) => AppSettingProvider(snapData.data!)),
              ChangeNotifierProvider(create: (_) => CurrencyProvider()),
              ChangeNotifierProvider(create: (_) => ProfileDetailProvider()),
              ChangeNotifierProvider(create: (_) => FavouriteListProvider()),
              ChangeNotifierProvider(create: (_) => CommonPermissionProvider()),
              ChangeNotifierProvider(create: (_) => LocationProvider()),
              ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
              ChangeNotifierProvider(create: (_) => MyReviewProvider()),
              ChangeNotifierProvider(create: (_) => EditReviewProvider()),
              ChangeNotifierProvider(create: (_) => AppDetailsProvider()),
              ChangeNotifierProvider(create: (_) => RateAppProvider()),
              ChangeNotifierProvider(create: (_) => ContactUsProvider()),
              ChangeNotifierProvider(create: (_) => NotificationProvider()),
              ChangeNotifierProvider(create: (_) => NewLocationProvider()),
              ChangeNotifierProvider(create: (_) => SearchProvider()),
              ChangeNotifierProvider(
                  create: (_) => LatestBLogDetailsProvider()),
              ChangeNotifierProvider(create: (_) => NoInternetProvider()),
              ChangeNotifierProvider(create: (_) => CategoriesListProvider()),
              ChangeNotifierProvider(
                  create: (_) => CategoriesDetailsProvider()),
              ChangeNotifierProvider(create: (_) => ServicesDetailsProvider()),
              ChangeNotifierProvider(create: (_) => ServiceReviewProvider()),
              ChangeNotifierProvider(create: (_) => ProviderDetailsProvider()),
              ChangeNotifierProvider(create: (_) => SlotBookingProvider()),
              ChangeNotifierProvider(create: (_) => CartProvider()),
              ChangeNotifierProvider(create: (_) => PaymentProvider()),
              ChangeNotifierProvider(create: (_) => WalletProvider()),
              ChangeNotifierProvider(create: (_) => ServicemanListProvider()),
              ChangeNotifierProvider(create: (_) => ServiceSelectProvider()),
              ChangeNotifierProvider(create: (_) => SelectServicemanProvider()),
              ChangeNotifierProvider(create: (_) => BookingProvider()),
              ChangeNotifierProvider(create: (_) => PendingBookingProvider()),
              ChangeNotifierProvider(create: (_) => AcceptedBookingProvider()),
              ChangeNotifierProvider(create: (_) => ChatProvider()),
              ChangeNotifierProvider(create: (_) => OngoingBookingProvider()),
              ChangeNotifierProvider(create: (_) => CompletedServiceProvider()),
              ChangeNotifierProvider(
                  create: (_) => ServicesPackageDetailsProvider()),
              ChangeNotifierProvider(create: (_) => CheckoutWebViewProvider()),
              ChangeNotifierProvider(create: (_) => CancelledBookingProvider()),
              ChangeNotifierProvider(create: (_) => PackageBookingProvider()),
              ChangeNotifierProvider(create: (_) => ServicemanDetailProvider()),
              ChangeNotifierProvider(create: (_) => FeaturedServiceProvider()),
              ChangeNotifierProvider(create: (_) => ExpertServiceProvider()),
              ChangeNotifierProvider(create: (_) => ChatHistoryProvider()),
              ChangeNotifierProvider(create: (_) => DeleteDialogProvider()),
              ChangeNotifierProvider(create: (_) => JobRequestListProvider()),
              ChangeNotifierProvider(create: (_) => AddJobRequestProvider()),
              ChangeNotifierProvider(create: (_) => AudioCallProvider()),
              ChangeNotifierProvider(create: (_) => VideoCallProvider()),
              ChangeNotifierProvider(
                  create: (_) => JobRequestDetailsProvider()),
              ChangeNotifierProvider(
                  create: (_) => LanguageProvider(snapData.data!)),
              ChangeNotifierProvider(
                  create: (_) => ServicePackageAllListProvider()),
            ], child: const RouteToPage());
          } else {
            return MaterialApp(
                theme: AppTheme.fromType(ThemeType.light).themeData,
                darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
                themeMode: ThemeMode.light,
                debugShowCheckedModeBanner: false,
                home: const SplashLayout());
          }
        });
  }

  lockScreenPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}

class RouteToPage extends StatefulWidget {
  const RouteToPage({super.key});

  @override
  State<RouteToPage> createState() => _RouteToPageState();
}

class _RouteToPageState extends State<RouteToPage> {
  @override
  void initState() {
    // TODO: implement initState
    CustomNotificationController().initNotification(context);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(builder: (context, theme, child) {
      return Consumer<LanguageProvider>(builder: (context, lang, child) {
        return Consumer<CurrencyProvider>(builder: (context, currency, child) {
          return MaterialApp(
              title: 'Fixit User',
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.fromType(ThemeType.light).themeData,
              darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
              locale: lang.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                AppLocalizationDelagate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              supportedLocales: appArray.localList,
              themeMode: theme.theme,
              initialRoute: "/",
              routes: appRoute.route);
        });
      });
    });
  }
}
