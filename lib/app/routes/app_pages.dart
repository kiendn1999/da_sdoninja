import 'package:da_sdoninja/app/bindings/common/conversation_binding.dart';
import 'package:da_sdoninja/app/bindings/common/login_phone_binding.dart';
import 'package:da_sdoninja/app/bindings/common/profile_binding.dart';
import 'package:da_sdoninja/app/bindings/customer/customer_navigate_binding.dart';
import 'package:da_sdoninja/app/bindings/customer/customer_review_binding.dart';
import 'package:da_sdoninja/app/bindings/customer/store_detail_binding.dart';
import 'package:da_sdoninja/app/bindings/customer/write_review_binding.dart';
import 'package:da_sdoninja/app/bindings/partner/add_store_binding.dart';
import 'package:da_sdoninja/app/bindings/partner/manage_binding.dart';
import 'package:da_sdoninja/app/bindings/partner/partner_navigate_binding.dart';
import 'package:da_sdoninja/app/screen/conversation/conversation_screen.dart';
import 'package:da_sdoninja/app/screen/introduce/introduce_screen.dart';
import 'package:da_sdoninja/app/screen/login/login_screen.dart';
import 'package:da_sdoninja/app/screen/login/login_with_phone_number_screen.dart';
import 'package:da_sdoninja/app/screen/login/otp_screen.dart';
import 'package:da_sdoninja/app/screen/manage_store/manage_store_screen.dart';
import 'package:da_sdoninja/app/screen/navigation/customer_navigation_frame.dart';
import 'package:da_sdoninja/app/screen/navigation/partner_navigation_frame.dart';
import 'package:da_sdoninja/app/screen/profile/profile_screen.dart';
import 'package:da_sdoninja/app/screen/reviews/review_rating_screen.dart';
import 'package:da_sdoninja/app/screen/reviews/write_review_screen.dart';
import 'package:da_sdoninja/app/screen/store_info/add_store_screen.dart';
import 'package:da_sdoninja/app/screen/store_info/store_detail_screen.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.introduce, page: () => const IntroduceScreeen()),
    GetPage(name: Routes.login, page: () =>  LoginScreen()),
    GetPage(name: Routes.loginWithPhoneNumber, page: () => const LoginWithPhoneNumberScreen(), binding: LoginWithPhoneBinding()),
    GetPage(name: Routes.otpVerification, page: () =>  OtpVerificationScreen()),
    GetPage(name: Routes.customerNavigation, page: () =>  CustomerNavigationFrame(), binding: CustomerNavigationBinding()),
    GetPage(name: Routes.partnerNavigation, page: () =>   PartnerNavigationFrame(), binding: PartnerNavigationBinding()),
    GetPage(name: Routes.storeDetail, page: () =>   StoreDetailScreen(), binding: StoreDetailBinding()),
    GetPage(name: Routes.customerReview, page: () =>   CustomerReviewScreen(), binding: CustomerReviewBinding()),
    GetPage(name: Routes.manageStore, page: () =>   ManageStoreScreen(), binding: ManageStoreBinding()),
    GetPage(name: Routes.conversation, page: () => const  ConversationScreen(), binding: ConversationBinding()),
    GetPage(name: Routes.profile, page: () =>   ProfileScreen(), binding: ProfileBinding()),
    GetPage(name: Routes.writeReview, page: () =>   WriteReviewScreen(), binding: WriteReviewBinding()),
    GetPage(name: Routes.addNewStore, page: () =>   AddStoreScreen(), binding: AddStoreBinding()),
  ];
}
