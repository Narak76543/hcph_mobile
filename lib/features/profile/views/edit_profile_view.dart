import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_assgn/features/profile/controllers/edit_profile_controller.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';
import 'package:school_assgn/widget/input_field.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBgColor,
      appBar: AppBar(
        title: const AppText(
          'Edit Profile',
          variant: AppTextVariant.title,
          fontSize: 18,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => _showImagePickerOptions(context),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Obx(() {
                        final profileCtrl = Get.find<ProfileController>();
                        final bool hasNewImage =
                            controller.selectedImagePath.value.isNotEmpty;
                        final bool hasNetworkImage =
                            profileCtrl.userAvatarUrl.value.isNotEmpty;

                        return Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.kAuthSurface,
                            border: Border.all(
                              color: AppColor.kAuthBorder,
                              width: 2,
                            ),
                            image: hasNewImage
                                ? DecorationImage(
                                    image: FileImage(
                                      File(
                                        controller.selectedImagePath.value,
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : (hasNetworkImage
                                      ? DecorationImage(
                                          image:
                                              profileCtrl.userAvatarUrl.value
                                                  .startsWith('assets/')
                                              ? AssetImage(
                                                      profileCtrl
                                                          .userAvatarUrl
                                                          .value,
                                                    )
                                                    as ImageProvider
                                              : NetworkImage(
                                                  profileCtrl
                                                      .userAvatarUrl
                                                      .value,
                                                ),
                                          fit: BoxFit.cover,
                                        )
                                      : null),
                          ),
                          child: (!hasNewImage && !hasNetworkImage)
                              ? Icon(
                                  Icons.person_rounded,
                                  size: 50,
                                  color: AppColor.kAuthTextSecondary,
                                )
                              : null,
                        );
                      }),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.kAuthAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: AppColor.kTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: AppInputField(
                      controller: controller.firstnameCtrl,
                      label: 'First Name',
                      hint: 'e.g. Sarat',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppInputField(
                      controller: controller.lastnameCtrl,
                      label: 'Last Name',
                      hint: 'e.g. Narak',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: AppInputField(
                      controller: controller.firstnameLcCtrl,
                      label: 'Local FirstName',
                      hint: 'e.g. សារ៉ាត',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppInputField(
                      controller: controller.lastnameLcCtrl,
                      label: 'Local LastName',
                      hint: 'e.g. នរ',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              AppInputField(
                controller: controller.usernameCtrl,
                label: 'Username',
                hint: '@username...',
              ),
              const SizedBox(height: 10),

              AppInputField(
                controller: controller.phoneCtrl,
                label: 'Phone Number',
                hint: 'e.g. 012 345 678',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.kAuthAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: AppColor.kTextColor,
                              strokeWidth: 2,
                            ),
                          )
                        : AppText(
                            'Save Changes',
                            variant: AppTextVariant.body,
                            color: AppColor.kTextColor,
                            fontSize: 16,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.kBgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppText(
                  'Change Profile Photo',
                  variant: AppTextVariant.body,
                  fontSize: 13,
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Image.asset(
                    "assets/images/gallery.png",
                    height: 20,
                    color: AppColor.kAccent,
                  ),
                  title: const AppText(
                    'Choose from Gallery',
                    variant: AppTextVariant.body,
                    fontSize: 13,
                  ),
                  onTap: () {
                    Get.back();
                    controller.pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/images/camera.png",
                    height: 20,
                    color: AppColor.kAccent,
                  ),
                  title: const AppText(
                    'Take a Photo',
                    variant: AppTextVariant.body,
                    fontSize: 13,
                  ),
                  onTap: () {
                    Get.back();
                    controller.pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
