import '../../../config.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (loginContext, value, child) {
      return LoadingComponent(
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          eImageAssets.appLogo,
                          height: Sizes.s34,
                          width: Sizes.s34,
                        ),
                        const SizedBox(width: Sizes.s5),
                        Text(
                          language(context, appFonts.fixit),
                          style: appCss.outfitBold38.textColor(
                            appColor(context).darkText,
                          ),
                        ),
                        const SizedBox(height: Sizes.s30),
                      ],
                    ),
                    Form(
                      key: value.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Sizes.s35),
                          Text(
                            language(context, appFonts.login),
                            style: appCss.dmDenseBold20.textColor(
                              appColor(context).darkText,
                            ),
                          ),
                          const SizedBox(height: Sizes.s15),
                          const LoginLayout(),
                          const SizedBox(height: Sizes.s35),
                          if (appSettingModel != null &&
                              appSettingModel!.activation!.socialLoginEnable ==
                                  "1")
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const ContinueWithContainer(),
                                Text(
                                  language(context, appFonts.orContinue),
                                  style: appCss.dmDenseMedium14.textColor(
                                    appColor(context).lightText,
                                  ),
                                ).paddingSymmetric(horizontal: Insets.i10),
                                const ContinueWithContainer(),
                              ],
                            ).inkWell(
                              onTap: () => route.pushNamed(
                                context,
                                routeName.appSetting,
                              ),
                            ),
                          if (appSettingModel?.activation?.socialLoginEnable ==
                              "1")
                            const SizedBox(height: Sizes.s20),
                          if (appSettingModel?.activation?.socialLoginEnable ==
                              "1")
                            Row(
                              children: [
                                AuthButtonCommon(
                                  title: appFonts.google,
                                  onTap: () => value.signInWithGoogle(context),
                                  logo: eImageAssets.google,
                                ),
                                const SizedBox(width: Sizes.s25),
                                AuthButtonCommon(
                                  title: appFonts.phone,
                                  logo: eImageAssets.mobile,
                                  onTap: () => route.pushNamed(
                                    context,
                                    routeName.loginWithPhone,
                                  ),
                                ),
                              ],
                            ),
                          if (appSettingModel?.activation?.socialLoginEnable ==
                              "1")
                            const SizedBox(height: Sizes.s25),
                          ContinueGuestLayout(
                            onTap: () => value.continueAsGuestTap(context),
                          ),
                        ],
                      ).alignment(Alignment.centerLeft),
                    )
                  ],
                ).paddingSymmetric(horizontal: Insets.i20),
              ),
            ),
          ),
        ),
      );
    });
  }
}
