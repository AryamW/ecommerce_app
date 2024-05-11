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
import 'package:get/get.dart';

final routes = [
// admin
  GetPage(name: "/admin-home", page: () => StorePage()),
  GetPage(name: "/add-staff", page: () => RegisterAdminPage()),
  GetPage(name: "/admin-recent-reviews", page: () => AdminReviews()),
  GetPage(name: "/admin-recent-orders", page: () => AdminOrders()),
  GetPage(name: "/admin-most-products", page: () => MostProductsEntry()),
  GetPage(name: "/admin-out-of-stock", page: () => OutOfStockProductEntry()),
// admin

  GetPage(name: "/home", page: () => EntryPage()),
  GetPage(name: "/login", page: () => LoginPage()),
  GetPage(name: "/register", page: () => RegisterPage()),
  GetPage(name: "/forgot-password", page: () => ForgotPassword()),
  GetPage(name: "/email-sent", page: () => EmailSent()),
  GetPage(name: "/cart", page: () => Cart_cart()),
  // to be modified to conditional rendering for empty cart.
  GetPage(name: "/emptyCart", page: () => EmptyCart()),
  GetPage(name: "/add-checkout", page: () => AddCheckout()),
  GetPage(name: "/checkout", page: () => CheckoutPage()),
  GetPage(name: "/productDetail", page: () => ProductDetails()),
  GetPage(name: "/search", page: () => SearchPage()),
  GetPage(name: "/settings", page: () => SettingsPage()),
  GetPage(name: "/address", page: () => AddressPage()),
  GetPage(name: "/confirm", page: () => ConfirmPage()),
  GetPage(name: "/confirmed-email", page: () => ConfirmedEmail()),
  GetPage(
      name: "/addAddress",
      page: () => EditAddressPage(
            createNewAddress: true,
          )),
  GetPage(name: "/error", page: () => ErrorPage()),
  GetPage(name: "/category", page: () => CategoriesPage()),
  GetPage(name: "/selectedCategory", page: () => SelectedCategoryPage()),
  GetPage(name: "/editProfile", page: () => EditProfilePage()),
  GetPage(
      name: "/editAddress",
      page: () => EditAddressPage(
            createNewAddress: false,
          )),
  // GetPage(name: "/search", page: () => HomePage()),
  GetPage(name: "/adminProducts", page: () => MyProducts()),
  GetPage(name: "/adminEditProducts", page: () => EditProduct()),

  GetPage(name: "/orders", page: () => OrderHistory()),
  GetPage(name: "/order-detail", page: () => OrderDetailScreen()),
  
];
