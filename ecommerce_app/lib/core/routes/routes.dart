import 'package:ecommerce_app/presentation/pages/auth/forgotPassword.dart';
import 'package:ecommerce_app/presentation/pages/auth/login.dart';
import 'package:ecommerce_app/presentation/pages/auth/register.dart';
import 'package:ecommerce_app/presentation/pages/cart/cart.dart';
import 'package:ecommerce_app/presentation/pages/cart/emptyCart.dart';
import 'package:ecommerce_app/presentation/pages/checkout/addCheckout.dart';
import 'package:ecommerce_app/presentation/pages/checkout/checkout.dart';
import 'package:ecommerce_app/presentation/pages/home/home.dart';
import 'package:ecommerce_app/presentation/pages/products/productDetail.dart';
import 'package:ecommerce_app/presentation/pages/search/search_page.dart';
import 'package:ecommerce_app/presentation/pages/settings/address_page.dart';
import 'package:ecommerce_app/presentation/pages/settings/edit_address_page.dart';
import 'package:ecommerce_app/presentation/pages/settings/settings_page.dart';
import 'package:get/get.dart';

final routes = [
  GetPage(name: "/home", page: () => HomePage()),
  GetPage(name: "/login", page: () => LoginPage()),
  GetPage(name: "/register", page: () => RegisterPage()),
  GetPage(name: "/forgotPassword", page: () => ForgotPassword()),
  GetPage(name: "/emailSent", page: () => EmailSent()),
  GetPage(name: "/cart", page: () => Cart()),
  // to be modified to conditional rendering for empty cart.
  GetPage(name: "/emptyCart", page: () => EmptyCart()),
  GetPage(name: "/addCheckout", page: () => AddCheckout()),
  GetPage(name: "/checkout", page: () => CheckoutPage()),
  GetPage(name: "/productDetail", page: () => ProductDetail()),
  GetPage(name: "/search", page: () => SearchPage(keyWord: "PlaceHolder")),
  GetPage(name: "/settings", page: () => SettingsPage()),
  GetPage(name: "/address", page: () => AddressPage()),
  GetPage(name: "/addAddress", page: () => EditAddressPage(createNewAddress: true,)),
  // GetPage(name: "/search", page: () => HomePage()),
];