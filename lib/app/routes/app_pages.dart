import 'package:da_sdoninja/app/bindings/customer/customer_navigate_binding.dart';
import 'package:da_sdoninja/app/bindings/customer/customer_review_binding.dart';
import 'package:da_sdoninja/app/bindings/customer/store_detail_binding.dart';
import 'package:da_sdoninja/app/bindings/login_binding.dart';
import 'package:da_sdoninja/app/bindings/partner/partner_navigate_binding.dart';
import 'package:da_sdoninja/app/screen/introduce/introduce_screen.dart';
import 'package:da_sdoninja/app/screen/login/login_screen.dart';
import 'package:da_sdoninja/app/screen/login/login_with_phone_number.dart';
import 'package:da_sdoninja/app/screen/login/otp_screen.dart';
import 'package:da_sdoninja/app/screen/navigation/customer_navigation_frame.dart';
import 'package:da_sdoninja/app/screen/navigation/partner_navigation_frame.dart';
import 'package:da_sdoninja/app/screen/reviews/review_rating_screen.dart';
import 'package:da_sdoninja/app/screen/store_info/store_detail_screen.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.introduce, page: () => const IntroduceScreeen()),
    GetPage(name: Routes.login, page: () => const LoginScreen(), binding: LoginBinding()),
    GetPage(name: Routes.loginWithPhoneNumber, page: () => const LoginWithPhoneNumber(), binding: LoginBinding()),
    GetPage(name: Routes.otpVerification, page: () => const OtpVerificationScreen()),
    GetPage(name: Routes.customerNavigation, page: () =>  CustomerNavigationFrame(), binding: CustomerNavigationBinding()),
    GetPage(name: Routes.partnerNavigation, page: () =>   PartnerNavigationFrame(), binding: PartnerNavigationBinding()),
    GetPage(name: Routes.storeDetail, page: () =>   StoreDetailScreen(), binding: StoreDetailBinding()),
    GetPage(name: Routes.customerReview, page: () =>   CustomerReviewScreen(), binding: CustomerReviewBinding()),
  ];
}
