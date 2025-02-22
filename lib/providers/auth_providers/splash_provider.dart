import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixit_user/models/app_setting_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../config.dart';

class SplashProvider extends ChangeNotifier {
  double size = 10;
  double roundSize = 10;
  double roundSizeWidth = 10;
  AnimationController? controller;
  Animation<double>? animation;

  AnimationController? controller2;
  Animation<double>? animation2;

  AnimationController? controller3;
  Animation<double>? animation3;

  AnimationController? controllerSlide;
  Animation<Offset>? offsetAnimation;

  AnimationController? popUpAnimationController;

  onReady(TickerProvider sync, context) async {
    bool isAvailable = await isNetworkConnection();
    if (isAvailable) {
      getAppSettingList(context);
      getPaymentMethodList(context);
      getAllCategory();
      SharedPreferences pref = await SharedPreferences.getInstance();
      dynamic userData = pref.getString(session.user);
      final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
      bool isAuthenticate = false;
      if (userData != null) {
        isAuthenticate = await commonApi.checkForAuthenticate();
      }

      log("isAuthenticate :$isAuthenticate");
      controller = controller =
          AnimationController(vsync: sync, duration: const Duration(seconds: 1))
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                controller!.stop();
                notifyListeners();
              }
              if (status == AnimationStatus.dismissed) {
                controller!.forward();
                notifyListeners();
              }
            });

      animation = CurvedAnimation(parent: controller!, curve: Curves.easeIn);
      controller!.forward();

      controller2 = AnimationController(
          vsync: sync, duration: const Duration(seconds: 1));
      animation2 = CurvedAnimation(parent: controller2!, curve: Curves.easeIn);

      if (controller2!.status == AnimationStatus.forward ||
          controller2!.status == AnimationStatus.completed) {
        controller2!.reverse();
        notifyListeners();
      } else if (controller2!.status == AnimationStatus.dismissed) {
        Timer(const Duration(seconds: 1), () {
          controller2!.forward();
          notifyListeners();
        });
      }

      controllerSlide = AnimationController(
          vsync: sync, duration: const Duration(seconds: 1));

      offsetAnimation =
          Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
              .animate(controllerSlide!);

      controller3 =
          AnimationController(duration: const Duration(seconds: 1), vsync: sync)
            ..repeat();
      animation3 = CurvedAnimation(parent: controller3!, curve: Curves.easeIn);

      popUpAnimationController = AnimationController(
          vsync: sync, duration: const Duration(seconds: 1));

      Timer(const Duration(seconds: 1), () {
        popUpAnimationController!.forward();
        notifyListeners();
      });

      log("ANIMATION CON ${popUpAnimationController!.status}");
      final dashCtrl = Provider.of<DashboardProvider>(context, listen: false);

      dashCtrl.getCurrency();
      dashCtrl.getBanner();
      dashCtrl.getOffer();
      dashCtrl.getCoupons();
      dashCtrl.getBookingStatus();
      dashCtrl.getProvider();

      dashCtrl.getFeaturedPackage(1);
      dashCtrl.getHighestRate();
      dashCtrl.getBlog();
      final locationCtrl =
          Provider.of<LocationProvider>(context, listen: false);
      locationCtrl.getCountryState();
      await locationCtrl.getUserCurrentLocation(context);
      final search = Provider.of<SearchProvider>(context, listen: false);
      search.loadImage1();

      if (userData != null) {
        pref.remove(session.isContinueAsGuest);
        final commonApi =
            Provider.of<CommonApiProvider>(context, listen: false);
        await commonApi.selfApi(context);

        await locationCtrl.getLocationList(context);

        final favCtrl =
            Provider.of<FavouriteListProvider>(context, listen: false);
        favCtrl.getFavourite();
        dashCtrl.getBookingHistory(context);
        //dashCtrl.getServicePackage();
        final cartCtrl = Provider.of<CartProvider>(context, listen: false);
        cartCtrl.onReady(context);
        final notifyCtrl =
            Provider.of<NotificationProvider>(context, listen: false);
        notifyCtrl.getNotificationList(context);

        final wallet = Provider.of<WalletProvider>(context, listen: false);
        wallet.getWalletList(context);
        final review = Provider.of<MyReviewProvider>(context, listen: false);
        review.getMyReview(context);
      }

      Timer(const Duration(seconds: 2), () async {
        await locationCtrl.getZoneId();
        bool? isIntro = pref.getBool(session.isIntro) ?? false;

        log("userData :: $userData");

        Provider.of<SplashProvider>(context, listen: false).dispose();
        onDispose();

        dashCtrl.getCategory();
        dashCtrl.getServicePackage();
        dashCtrl.getJobRequest();
        if (appSettingModel != null && appSettingModel!.activation!.maintenanceMode == "1") {
          route.pushReplacementNamed(context, routeName.maintenanceMode);
        } else {
          if (isIntro) {
            if (userData != null) {
              if (isAuthenticate) {
                route.pushReplacementNamed(context, routeName.dashboard);
              } else {
                userModel = null;
                setPrimaryAddress = null;
                userPrimaryAddress = null;
                final dash =
                    Provider.of<DashboardProvider>(context, listen: false);
                dash.selectIndex = 0;
                dash.notifyListeners();
                pref.remove(session.user);
                pref.remove(session.accessToken);
                pref.remove(session.isContinueAsGuest);
                pref.remove(session.isLogin);
                pref.remove(session.cart);
                pref.remove(session.recentSearch);

                final auth = FirebaseAuth.instance.currentUser;
                if (auth != null) {
                  FirebaseAuth.instance.signOut();
                  GoogleSignIn().disconnect();
                }
                route.pushReplacementNamed(context, routeName.login);
              }
            } else {
              route.pushReplacementNamed(context, routeName.login);
            }
          } else {
            route.pushReplacementNamed(context, routeName.onBoarding);
          }
        }
      });
    } else {
      onDispose();
      Provider.of<SplashProvider>(context, listen: false).dispose();
      route.pushReplacementNamed(context, routeName.noInternet);
    }
  }

//setting list
  getAppSettingList(context) async {
    try {
      await apiServices.getApi(api.settings, [], isData: true).then((value) {
        if (value.isSuccess!) {
          appSettingModel = AppSettingModel.fromJson(value.data['values']);

          notifyListeners();
        }
        onUpdate(context, appSettingModel!.general!.defaultCurrency!);
        notifyListeners();
      });
    } catch (e) {
      log("EEEE getAppSettingList $e");
      notifyListeners();
    }
  }

  //all category list
  getAllCategory({search}) async {
    // notifyListeners();
    try {
      await apiServices.getApi(api.categoryList, []).then((value) {
        if (value.isSuccess!) {
          allCategoryList = [];
          List category = value.data;
          log("DD :${category.length}");
          for (var data in category.reversed.toList()) {
            if (!allCategoryList.contains(CategoryModel.fromJson(data))) {
              allCategoryList.add(CategoryModel.fromJson(data));
            }
            notifyListeners();
          }
        }
      });
    } catch (e) {
      log("EEEE AllCategory:::$e");
      notifyListeners();
    }
  }

  //setting list
  getPaymentMethodList(context) async {
    try {
      await apiServices.getApi(api.paymentMethod, []).then((value) {
        log("VALUE :${value.data}");
        if (value.isSuccess!) {
          for (var d in value.data) {
            paymentMethods.add(PaymentMethods.fromJson(d));
          }
          notifyListeners();
        }

        notifyListeners();
      });
    } catch (e) {
      log("EEEE getPaymentMethodList:$e");
      notifyListeners();
    }
  }

  onUpdate(context, CurrencyModel data) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final currencyData = Provider.of<CurrencyProvider>(context, listen: false);
    double? currencyVal = pref.getDouble(session.currencyVal);
    if (currencyVal != null) {
      final prefCurrency = pref.getString(session.currency);

      currencyData.currencyVal = currencyVal;
      currencyData.currency = CurrencyModel.fromJson(jsonDecode(prefCurrency!));
      currencyData.priceSymbol = pref.getString(session.priceSymbol)!;
      currencyData.notifyListeners();
    } else {
      currency(context).priceSymbol = data.symbol.toString();

      currencyData.currency = data;
      currencyData.currencyVal = data.exchangeRate!;
      currencyData.notifyListeners();
    }

    await pref.setString(session.priceSymbol, currency(context).priceSymbol);
    Map<String, dynamic> cc = await currencyData.currency!.toJson();
    await pref.setString(
        session.currency, jsonEncode(cc));
    await pref.setDouble(session.currencyVal, currencyData.currencyVal);
    notifyListeners();
    log("currency(context).priceSymbol : ${currency(context).priceSymbol}");
  }

  onDispose() async {
    bool isAvailable = await isNetworkConnection();
    if (!isAvailable) {
      controller2!.dispose();
      controller3!.dispose();
      animation3!.isDismissed;
      controller!.dispose();
      controllerSlide!.dispose();
      popUpAnimationController!.dispose();
    }
  }

  onChangeSize() {
    size = size == 10 ? 115 : 115;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    onDispose();
    super.dispose();
  }
}
