import 'package:da_sdoninja/app/constant/string/key_id.dart';
import 'package:da_sdoninja/app/constant/string/string_array.dart';
import 'package:da_sdoninja/app/constant/theme/app_colors.dart';
import 'package:da_sdoninja/app/constant/theme/app_images.dart';
import 'package:da_sdoninja/app/constant/theme/app_text_style.dart';
import 'package:da_sdoninja/app/controller/function_controller/cru_store_controller.dart';
import 'package:da_sdoninja/app/data/model/prediction.dart';
import 'package:da_sdoninja/app/data/model/store_model.dart';
import 'package:da_sdoninja/app/extension/geocoding_extension.dart';
import 'package:da_sdoninja/app/extension/image_assets_path_extension.dart';
import 'package:da_sdoninja/app/widgets/autocomplete_place_textfield.dart';
import 'package:da_sdoninja/app/widgets/button_widget.dart';
import 'package:da_sdoninja/app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../constant/theme/app_radius.dart';

class MyStoreScreen extends StatefulWidget {
  StoreModel? currentStore;
  final CrUStoreController controller;
  MyStoreScreen({Key? key, this.currentStore, required this.controller}) : super(key: key);

  @override
  State<MyStoreScreen> createState() => _MyStoreScreenState();
}

class _MyStoreScreenState extends State<MyStoreScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.getDataToDisplayOnMyStoreScreen(widget.currentStore!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        widget.controller.getLastPosition();
      },
      child: SingleChildScrollView(
        child: Obx(() => AbsorbPointer(
              absorbing: widget.currentStore!.id != null ? !widget.controller.isEdit : false,
              child: Form(
                key: widget.controller.formKey,
                child: Column(
                  children: [
                    _shopImageAva(),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoTextField(
                              textEditingController: widget.controller.nameTextFieldController,
                              lable: "store_name".tr,
                              hintText: "enter_store_name".tr,
                              imagePath: AppImages.icStoreSelected,
                              validate: (value) => widget.controller.validateStoreName(value!)),
                          _addressTextField(),
                          _infoTextField(
                              textEditingController: widget.controller.phoneTextFieldController,
                              lable: "phone_number".tr,
                              keyboardType: TextInputType.phone,
                              hintText: "enter_your_phone_number".tr,
                              imagePath: AppImages.icCall,
                              validate: (value) => widget.controller.validateStorePhone(value!)),
                          _autoEnterCurrentPhoneNumberButton(),
                          _storeTypeCheckBoxGridView(),
                          _introduce(),
                          _termAndPolicyCheckBox(),
                          _sendButton()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  TextButton _autoEnterCurrentPhoneNumberButton() {
    return TextButton(
        onPressed: () async => widget.controller.phoneTextFieldController.text = (await widget.controller.autoFill.hint)!,
        child: Text(
          "get_current_number".tr,
          style: AppTextStyle.tex16Regular(color: AppColors.green),
        ));
  }

  _addressTextField() {
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "address".tr,
            style: AppTextStyle.tex18Regular(),
          ),
          GooglePlaceAutoCompleteTextField(
              textEditingController: widget.controller.addressTextFieldController,
              googleAPIKey: googleMapAPIKey,
              textStyle: AppTextStyle.tex18Regular(),
              contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              hintText: "enter_address".tr,
              debounceTime: 800, // default 600 ms, optional by default null is set
              isLatLngRequired: true, // if you required coordinates from place detail
              iconHeight: 25.h,
              marginTop: 5.h,
              validator: (value) => widget.controller.validateStoreAddress(value!),
              suffixIcon: Container(
                margin: EdgeInsets.only(right: 15.w),
                child: SvgPicture.asset(
                  AppImages.icMapSelected.getSVGImageAssets,
                  width: 25.w,
                  height: 25.h,
                  color: Get.context!.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor,
                ),
              ),
              getPlaceDetailWithLatLng: (Prediction prediction) async {
                widget.controller.latitude = double.parse(prediction.lat!);
                widget.controller.longitude = double.parse(prediction.lng!);
                widget.controller.address = await GeocodingOnPosition.getAddressFromLatLng(widget.controller.latitude, widget.controller.longitude);
              }, // this callback is called when isLatLngRequired is true
              itmClick: (Prediction prediction) {
                widget.controller.addressTextFieldController.text = prediction.description!;
                widget.controller.addressTextFieldController.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description!.length));
                FocusManager.instance.primaryFocus?.unfocus();
              }),
        ],
      ),
    );
  }

  Widget _sendButton() {
    return Center(
      child: Visibility(
        visible: widget.currentStore!.id != null ? false : true,
        child: buttonWithRadius10(
            onPressed: () {
              widget.controller.submitWithInfo();
            },
            child: Text(
              "send".tr,
              style: AppTextStyle.tex18Medium(),
            ),
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
            margin: EdgeInsets.symmetric(vertical: 15.h)),
      ),
    );
  }

  Visibility _termAndPolicyCheckBox() {
    return Visibility(
      visible: widget.currentStore!.id != null ? false : true,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        child: InkWell(
          onTap: () => widget.controller.isDoneTermAndPolicyCheckBox.value = !widget.controller.isDoneTermAndPolicyCheckBox.value,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: widget.controller.isDoneTermAndPolicyCheckBox.value,
                onChanged: (value) => widget.controller.isDoneTermAndPolicyCheckBox.value = value!,
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 7.w),
                  child: Text.rich(
                    TextSpan(style: AppTextStyle.tex16Regular(), children: [
                      TextSpan(text: "i_agree_to".tr),
                      WidgetSpan(
                          child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          "the_terms_and_policies".tr,
                          style: AppTextStyle.tex16Regular(color: AppColors.blue2),
                        ),
                      )),
                      TextSpan(text: "of_sdoninja".tr),
                    ]),
                    textAlign: TextAlign.justify,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _introduce() {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _introduceTitle(),
          _introduceTextField(),
          _storeServiceCheckBoxGridView(),
        ],
      ),
    );
  }

  Container _introduceTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          textFormFieldApp(
            hintText: "enter_referrals".tr,
            controller: widget.controller.introduceTextFieldController,
            style: AppTextStyle.tex18Regular(),
            maxLines: 20,
            validator: (value) => widget.controller.validateStoreIntroduce(value!),
            contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
          ),
          GestureDetector(
            onTap: () {
              widget.controller.introduceTextFieldController.clear();
            },
            child: Padding(
              padding: EdgeInsets.only(top: 5.h, right: 5.w),
              child: Icon(
                Icons.clear,
                size: 25.h,
              ),
            ),
          )
        ],
      ),
    );
  }

  Text _introduceTitle() {
    return Text(
      "introduce".tr,
      style: AppTextStyle.tex18Regular(),
    );
  }

  _storeTypeCheckBoxGridView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "repair_store_type".tr,
              style: AppTextStyle.tex18Regular(),
            ),
            Text(
              "choose_at_least_1_type".tr,
              style: AppTextStyle.tex16Regular(color: AppColors.blue2),
            )
          ],
        ),
        GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 4,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
            storeTypesToRegister.length,
            (index) => InkWell(
              onTap: () => widget.controller.checkStoreType(storeTypesToRegister[index]),
              child: Row(
                children: [
                  Checkbox(
                      value: widget.controller.isStoreTypeChecked(storeTypesToRegister[index]),
                      onChanged: (value) => widget.controller.checkStoreType(storeTypesToRegister[index])),
                  Text(
                    storeTypesToRegister[index].tr,
                    style: AppTextStyle.tex16Regular(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _storeServiceCheckBoxGridView() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 4,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        storeServices.length,
        (index) => InkWell(
          onTap: () => widget.controller.checkStoreService(storeServices[index]),
          child: Row(
            children: [
              Checkbox(value: widget.controller.isStoreServiceChecked(storeServices[index]), onChanged: (value) => widget.controller.checkStoreService(storeServices[index])),
              Text(
                storeServices[index].tr,
                style: AppTextStyle.tex16Regular(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _infoTextField(
      {required TextEditingController textEditingController,
      required String lable,
      required String hintText,
      TextInputType? keyboardType,
      required String imagePath,
      required String? Function(String?)? validate}) {
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lable,
            style: AppTextStyle.tex18Regular(),
          ),
          textFormFieldApp(
            controller: textEditingController,
            hintText: hintText,
            style: AppTextStyle.tex18Regular(),
            contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            iconHeight: 25.h,
            marginTop: 5.h,
            keyboardType: keyboardType,
            suffixIcon: Container(
              margin: EdgeInsets.only(right: 15.w),
              child: SvgPicture.asset(
                imagePath.getSVGImageAssets,
                width: 25.w,
                height: 25.h,
                color: Get.context!.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor,
              ),
            ),
            validator: validate,
          )
        ],
      ),
    );
  }

  _shopImageAva() {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        widget.controller.didPickImage.value
            ? Image.file(
                widget.controller.imageStoreAva!,
                fit: BoxFit.cover,
                width: Get.width,
                height: 200.h,
              )
            : FadeInImage.assetNetwork(
                width: Get.width,
                height: 200.h,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) => SizedBox(
                      width: Get.width,
                      height: 200.h,
                      child: Image.asset(
                        AppImages.imageAvaShopDefault.getPNGImageAssets,
                        fit: BoxFit.cover,
                        width: Get.width,
                        height: 200.h,
                      ),
                    ),
                placeholder: AppImages.imageAvaShopDefault.getPNGImageAssets,
                image: "${widget.currentStore!.avaUrl}"),
        Card(
          shape: const CircleBorder(),
          margin: EdgeInsets.only(top: 5.h, right: 5.w),
          color: (context.isDarkMode ? AppColors.black : AppColors.white).withOpacity(0.5),
          child: IconButton(
            iconSize: 25.h,
            onPressed: _showHelpDialog,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minHeight: 35.h, minWidth: 35.w),
            icon: Icon(
              Icons.camera_enhance,
              color: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor,
            ),
          ),
        )
      ],
    );
  }

  Future<Object?> _showHelpDialog() {
    return showAnimatedDialog(
      context: Get.context!,
      animationType: DialogTransitionType.slideFromTopFade,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomDialogWidget(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            minWidth: 400,
            elevation: 7,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.camera_enhance,
                    color: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor,
                  ),
                  title: Text(
                    "take_a_photo".tr,
                    style: AppTextStyle.tex18Regular(),
                  ),
                  onTap: () => widget.controller.getImage(2),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.h),
                  child: ListTile(
                    leading: Icon(
                      Icons.photo_library_rounded,
                      color: context.isDarkMode ? AppColors.primaryDarkModeColor : AppColors.primaryLightModeColor,
                    ),
                    title: Text(
                      "choose_from_the_collection".tr,
                      style: AppTextStyle.tex18Regular(),
                    ),
                    onTap: () => widget.controller.getImage(1),
                  ),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.radius10)));
      },
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.controller.didPickImage.value = false;
  }
}
