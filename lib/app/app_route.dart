import 'package:auto_route/auto_route.dart';
import 'package:infinity_box/app/app.dart';
import 'package:infinity_box/features/auth/auth_view.dart';
import 'package:infinity_box/features/cart/cart_view.dart';
import 'package:infinity_box/features/home/home_view.dart';
import 'package:infinity_box/features/home/home_wrapper.dart';
import 'package:infinity_box/features/product_details/product_details_view.dart';
import 'package:infinity_box/features/splash/splash_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page|Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(page: App, initial: true, path: '/', children: [
      AutoRoute(initial: true, page: SplashScreen, path: 'splash'),
      AutoRoute(page: AuthScreen, path: 'auth'),
      AutoRoute(
        page: HomeWrapperScreen,
        path: 'home',
        children: [
          AutoRoute(page: HomeScreen, initial: true),
          AutoRoute(
            page: CartScreen,
            path: 'cart',
          ),
          AutoRoute(page: ProductDetailsScreen, path: 'productDetails'),
        ],
      ),
    ]),
  ],
)
class $AppRouter {}
