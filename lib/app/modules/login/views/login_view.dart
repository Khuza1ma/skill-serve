import 'package:flutter/gestures.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:skill_serve/app/utils/num_ext.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../ui/components/app_button.dart';
import '../../../ui/components/app_text_form_field.dart';
import '../../../constants/asset_constants.dart';
import '../controllers/login_controller.dart';
import '../../../constants/app_colors.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.k262837,
      body: Row(
        children: [
          Expanded(
            child: Container(
              height: double.maxFinite,
              decoration: BoxDecoration(color: AppColors.k1f1d2c, boxShadow: [
                BoxShadow(
                  color: AppColors.k806dff.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(10, 0),
                ),
              ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      Image.asset(AppAssets.logo, height: 80, width: 80),
                      Text(
                        'Skill Serve',
                        style: GoogleFonts.montserrat(
                          color: AppColors.kc6c6c8,
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SvgPicture.asset(
                    AppAssets.login,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: Get.height * 0.85,
                    width: Get.width * 0.35,
                    padding: const EdgeInsets.all(24),
                    margin: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.k1f1d2c,
                    ),
                    child: FormBuilder(
                      key: controller.formKey,
                      child: Obx(
                        () => Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.kFFFFFF,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: const TabBar(
                                physics: NeverScrollableScrollPhysics(),
                                labelColor: AppColors.kFFFFFF,
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicator: BoxDecoration(
                                  color: AppColors.k806dff,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                dividerHeight: 0,
                                tabs: <Widget>[
                                  Tab(
                                    child: Text('Login'),
                                  ),
                                  Tab(
                                    child: Text('Sign-up'),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                children: <Widget>[
                                  loginView(),
                                  signUpView(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Login to your account',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.k806dff,
            ),
          ),
        ),
        24.verticalSpace,
        AppTextField(
          prefix: const Icon(Icons.mail),
          name: 'username',
          label: 'Username',
          hintText: 'Username',
          validator: FormBuilderValidators.required(
            errorText: 'Please enter your username',
          ),
          isRequired: true,
          readOnly: controller.isLoading(),
        ),
        16.verticalSpace,
        AppTextField(
          prefix: const Icon(Icons.lock),
          name: 'password',
          label: 'Password',
          hintText: 'Password',
          isRequired: true,
          obscureText: controller.hidePassword(),
          keyboardType: TextInputType.visiblePassword,
          validator: FormBuilderValidators.required(
            errorText: 'Please enter your password',
          ),
          suffix: IconButton.filledTonal(
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
              ),
            ),
            iconSize: 24,
            onPressed: controller.hidePassword.toggle,
            padding: EdgeInsets.zero,
            icon: Icon(
              controller.hidePassword()
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: AppColors.k806dff,
            ),
          ),
          autoFillHints: const <String>[
            AutofillHints.password,
          ],
          readOnly: controller.isLoading(),
        ),
        30.verticalSpace,
        AppButton(
          onPressed: () {
            controller.loginUser();
          },
          buttonText: 'Login',
          fontSize: 20,
          isLoading: controller.isLoading(),
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget signUpView() {
    return Column(
      spacing: 15,
      children: [
        Expanded(
          child: ListView(
            children: [
              15.verticalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sign up your account',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.k806dff,
                  ),
                ),
              ),
              24.verticalSpace,
              AppTextField(
                prefix: const Icon(Icons.mail),
                name: 'username',
                label: 'Username',
                hintText: 'Username',
                validator: FormBuilderValidators.required(
                  errorText: 'Please enter your username',
                ),
                isRequired: true,
                readOnly: controller.isLoading(),
              ),
              16.verticalSpace,
              AppTextField(
                prefix: const Icon(Icons.mail),
                name: 'email',
                label: 'Email',
                hintText: 'Email',
                validator: FormBuilderValidators.email(
                  errorText: 'Please enter a valid email address',
                ),
                isRequired: true,
                readOnly: controller.isLoading(),
              ),
              16.verticalSpace,
              AppTextField(
                prefix: const Icon(Icons.lock),
                name: 'password',
                label: 'Password',
                hintText: 'Password',
                isRequired: true,
                obscureText: controller.hidePassword(),
                keyboardType: TextInputType.visiblePassword,
                validator: FormBuilderValidators.required(
                  errorText: 'Please enter your password',
                ),
                suffix: IconButton.filledTonal(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    )),
                  ),
                  iconSize: 24,
                  onPressed: controller.hidePassword.toggle,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    controller.hidePassword()
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.k806dff,
                  ),
                ),
                autoFillHints: const <String>[
                  AutofillHints.password,
                ],
                readOnly: controller.isLoading(),
              ),
              16.verticalSpace,
              AppTextField(
                prefix: const Icon(Icons.lock),
                name: 'confirm_password',
                label: 'Confirm Password',
                hintText: 'Confirm Password',
                isRequired: true,
                obscureText: controller.hidePassword(),
                keyboardType: TextInputType.visiblePassword,
                validator: FormBuilderValidators.required(
                  errorText: 'Please enter your password',
                ),
                suffix: IconButton.filledTonal(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    )),
                  ),
                  iconSize: 24,
                  onPressed: controller.hidePassword.toggle,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    controller.hidePassword()
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.k806dff,
                  ),
                ),
                autoFillHints: const <String>[
                  AutofillHints.password,
                ],
                readOnly: controller.isLoading(),
              ),
            ],
          ),
        ),
        AppButton(
          onPressed: () {
            controller.registerUser();
          },
          buttonText: 'Sign Up',
          fontSize: 20,
          isLoading: controller.isLoading(),
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
