import 'package:flutter/material.dart';
import 'package:freegig_app/common_widgets/build_profile_image.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:freegig_app/data/services/user_data_service.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/change_profile_image.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/dialog_ads.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/dialog_delete_account.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/dialog_report.dart';
import 'package:freegig_app/features/feature_0/widgets/profile/profile_update_form.dart';
import 'package:iconsax/iconsax.dart';

class ProfileSettings extends StatefulWidget {
  final String profileImageUrl;
  final String publicName;
  const ProfileSettings(
      {super.key, required this.profileImageUrl, required this.publicName});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurações',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 19.0,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ///Perfil header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    BuildProfileImage(
                        profileImageUrl: widget.profileImageUrl, imageSize: 60),
                    SizedBox(width: 15),
                    Expanded(
                        child: Text(
                      widget.publicName,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                      ),
                    ))
                  ],
                ),
              ),

              ///Lista de servicos
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfileUpdateForm()));
                },
                leading: Icon(Iconsax.user_edit),
                title: Text('Editar perfil'),
                trailing: Icon(Iconsax.arrow_right_3),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChangeProfileImage()));
                },
                leading: Icon(Iconsax.camera),
                title: Text('Alterar foto'),
                trailing: Icon(Iconsax.arrow_right_3),
              ),
              ListTile(
                onTap: () {
                  showDialog(
                      context: context, builder: (context) => AdsDialog());
                },
                leading: Icon(Iconsax.shop),
                title: Text('Anúncios'),
                trailing: Icon(Iconsax.arrow_right_3),
              ),
              ListTile(
                onTap: () {
                  showDialog(
                      context: context, builder: (context) => ReportDialog());
                },
                leading: Icon(Iconsax.warning_2),
                title: Text('Reportar algo'),
                trailing: Icon(Iconsax.arrow_right_3),
              ),
              ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => DeleteAccountConfirm());
                },
                leading: Icon(Iconsax.user_remove),
                title: Text('Excluir conta'),
                trailing: Icon(Iconsax.arrow_right_3),
              ),
              ListTile(
                onTap: () {
                  UserDataService().logOut(context);
                },
                leading: Icon(Iconsax.logout_1),
                title: Text('Sair'),
                trailing: Icon(Iconsax.arrow_right_3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
