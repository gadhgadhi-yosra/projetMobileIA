
// import 'package:flutter/material.dart';


// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final IconData? leading;
//   final VoidCallback? onLeadingPressed;

//   const CustomAppBar({
//     super.key,
//     required this.title,
//     this.leading,
//     this.onLeadingPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

//     return AppBar(
//       title: Text(
//         title,
//         style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
//       ),
//       backgroundColor: colorScheme.primary,
//       elevation: 0,
//       leading: leading != null
//           ? IconButton(
//               icon: Icon(leading, color: colorScheme.onPrimary),
//               onPressed: onLeadingPressed ?? () => Navigator.pop(context),
//             )
//           : null,
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }

import 'package:flutter/material.dart';
import 'package:supermarket_app_03072025/utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leading;
  final VoidCallback? onLeadingPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.onLeadingPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      title: Text(
        title,
        style: textTheme.titleLarge?.copyWith(color: AppColors.white),
      ),
      elevation: 0,
      leading: leading != null
          ? IconButton(
              icon: Icon(leading, color: AppColors.white),
              onPressed: onLeadingPressed ?? () => Navigator.pop(context),
            )
          : null,
      // Ici on remplace la couleur de fond par un dégradé via flexibleSpace
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      backgroundColor: Colors.transparent, // pour éviter que backgroundColor cache le dégradé
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
