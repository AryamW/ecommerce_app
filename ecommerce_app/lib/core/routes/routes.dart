import 'package:ecommerce_app/presentation/pages/ErrorPage.dart';
import 'package:ecommerce_app/presentation/pages/admin/admin_orders.dart';
import 'package:ecommerce_app/presentation/pages/admin/admin_products.dart';
import 'package:ecommerce_app/presentation/pages/admin/admin_reviews.dart';
import 'package:ecommerce_app/presentation/pages/admin/create_staff.dart';
import 'package:ecommerce_app/presentation/pages/admin/edit_product.dart';
import 'package:ecommerce_app/presentation/pages/admin/store_page.dart';
import 'package:ecommerce_app/presentation/pages/admin/view_product.dart';
import 'package:ecommerce_app/presentation/pages/auth/forgotPassword.dart';
import 'package:ecommerce_app/presentation/pages/auth/login.dart';
import 'package:ecommerce_app/presentation/pages/auth/register.dart';
import 'package:ecommerce_app/presentation/pages/cart/Cart.dart';
import 'package:ecommerce_app/presentation/pages/cart/emptyCart.dart';
import 'package:ecommerce_app/presentation/pages/checkout/addCheckout.dart';
import 'package:ecommerce_app/presentation/pages/checkout/checkout.dart';
import 'package:ecommerce_app/presentation/pages/confirmPage.dart';
import 'package:ecommerce_app/presentation/pages/entry_page.dart';
import 'package:ecommerce_app/presentation/pages/home/components/categories_page.dart';
import 'package:ecommerce_app/presentation/pages/home/components/selected_category_page.dart';
import 'package:ecommerce_app/presentation/pages/home/home.dart';
import 'package:ecommerce_app/presentation/pages/order/history.dart';
// import 'package:ecommerce_app/presentation/pages/products/productDetail.dart';
import 'package:ecommerce_app/presentation/pages/products/product_detail.dart';
import 'package:ecommerce_app/presentation/pages/search/search_page.dart';
import 'package:ecommerce_app/presentation/pages/settings/address_page.dart';
import 'package:ecommerce_app/presentation/pages/settings/edit_address_page.dart';
import 'package:ecommerce_app/presentation/pages/settings/edit_profile_page.dart';
import 'package:ecommerce_app/presentation/pages/settings/settings_page.dart';
import 'package:ecommerce_app/presentation/widgets/route_guard.dart';
import 'package:get/get.dart';

final routes = [
// admin
  GetPage(name: "/admin-home", page: () => StorePage(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/add-staff", page: () => RegisterAdminPage(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/admin-recent-reviews", page: () => AdminReviews(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/admin-recent-orders", page: () => AdminOrders(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/admin-most-products", page: () => MostProductsEntry(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/admin-out-of-stock", page: () => OutOfStockProductEntry(), middlewares: [RouteGuardMiddelware(priority: 1)]),
// admin

  GetPage(name: "/home", page: () => EntryPage(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/login", page: () => LoginPage(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/register", page: () => RegisterPage(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/forgot-password", page: () => ForgotPassword(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/email-sent", page: () => EmailSent(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/cart", page: () => Cart_cart(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  // to be modified to conditional rendering for empty cart.
  GetPage(name: "/emptyCart", page: () => EmptyCart(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/add-checkout", page: () => AddCheckout(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/checkout", page: () => CheckoutPage(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/productDetail", page: () => ProductDetails(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/search", page: () => SearchPage(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/settings", page: () => SettingsPage(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/address", page: () => AddressPage(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/confirm", page: () => ConfirmPage(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/confirmed-email", page: () => ConfirmedEmail(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(
      name: "/addAddress",
      page: () => EditAddressPage(
            createNewAddress: true,
          ), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/error", page: () => ErrorPage(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/category", page: () => CategoriesPage(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/selectedCategory", page: () => SelectedCategoryPage(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/editProfile", page: () => EditProfilePage(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(
      name: "/editAddress",
      page: () => EditAddressPage(
            createNewAddress: false,
          ), middlewares: [RouteGuardMiddelware(priority: 1)]),
  // GetPage(name: "/search", page: () => HomePage(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/adminProducts", page: () => MyProducts(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/adminEditProducts", page: () => EditProduct(), middlewares: [RouteGuardMiddelware(priority: 1)]),

  GetPage(name: "/orders", page: () => OrderHistory(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: "/order-detail", page: () => OrderDetailScreen(), middlewares: [RouteGuardMiddelware(priority: 1)]),
  GetPage(name: '/*', page: () => LoginPage(), middlewares: [RouteGuardMiddelware(priority: 1)]),
];

final List<String> loginRoutes = [
  "/login",
  "/register",
  "/forgot-password",
  "/email-sent",
  "/confirm",
  "/confirmed-email",
];


final List<String> homeRoutes = [
"/admin-home", 
"/add-staff", 
"/admin-recent-reviews", 
"/admin-recent-orders", 
"/admin-most-products", 
"/admin-out-of-stock", 
"/home",
"/cart", 
"/emptyCart", 
"/add-checkout", 
"/checkout", 
"/productDetail", 
"/search", 
"/settings", 
"/address", 
"/addAddress",
"/category", 
"/selectedCategory", 
"/editProfile", 
"/editAddress",
"/search", 
"/adminProducts", 
"/adminEditProducts", 
"/orders", 
"/order-detail", 

];