
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ChatbotMessage extends StatelessWidget {
//   final String text;
//   final bool isUserMessage;
//   final List<Map<String, String>>? sources;

//   const ChatbotMessage({
//     Key? key,
//     required this.text,
//     this.isUserMessage = false,
//     this.sources,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;

//     final messageBackgroundColor = isUserMessage ? colorScheme.primary : colorScheme.surface;
//     final messageTextColor = isUserMessage ? colorScheme.onPrimary : colorScheme.onSurface;

//     return Align(
//       alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
//         padding: const EdgeInsets.all(14.0),
//         decoration: BoxDecoration(
//           color: messageBackgroundColor,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(16.0),
//             topRight: const Radius.circular(16.0),
//             bottomLeft: isUserMessage ? const Radius.circular(16.0) : const Radius.circular(4.0),
//             bottomRight: isUserMessage ? const Radius.circular(4.0) : const Radius.circular(16.0),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 7,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               text,
//               style: TextStyle(
//                 fontSize: 16.0, 
//                 color: messageTextColor,
//               ),
//             ),
//             if (sources != null && sources!.isNotEmpty) ...[
//               const SizedBox(height: 10.0),
//               Text(
//                 'Sources:',
//                 style: TextStyle(
//                   fontSize: 12.0, 
//                   color: messageTextColor.withOpacity(0.7),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               ...sources!.map((source) {
//                 return InkWell(
//                   onTap: () async {
//                     final url = source['url'];
//                     if (url != null) {
//                       final uri = Uri.parse(url);
//                       try {
//                         if (await canLaunchUrl(uri)) {
//                           await launchUrl(uri, mode: LaunchMode.externalApplication);
//                         } else {
//                           if (context.mounted) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('Impossible d\'ouvrir l\'URL: $url')),
//                             );
//                           }
//                         }
//                       } catch (e) {
//                         if (context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Erreur: $e')),
//                           );
//                         }
//                       }
//                     }
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 3.0),
//                     child: Text(
//                       '- ${source['name'] ?? 'Source sans nom'}',
//                       style: TextStyle(
//                         fontSize: 12.0,
//                         color: colorScheme.secondary,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatbotMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;
  final List<Map<String, String>>? sources;
  final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'TND');

   ChatbotMessage({
    Key? key,
    required this.text,
    required this.isUserMessage,
    this.sources, String? userImageUrl,
  }) : super(key: key);

  // Afficher le prix dans un dialog
  void _showPriceDialog(BuildContext context, String competitor, String price, String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$competitor Price'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: ${currencyFormatter.format(double.parse(price))}'),
            const SizedBox(height: 8.0),
            InkWell(
              onTap: () async {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              child: Text(
                'View Product',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUserMessage) ...[
            CircleAvatar(
              radius: 35.0,
              backgroundImage: const AssetImage('assets/images/user_avatar.png'),
              backgroundColor: colorScheme.surface,
              child: const Icon(Icons.android, color: Colors.white), // Fallback icon
              onBackgroundImageError: (exception, stackTrace) {
                print('Erreur de chargement de l\'image bot_avatar.png: $exception');
              },
            ),
            const SizedBox(width: 12.0),
          ],
          Flexible(
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 300),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.70,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: isUserMessage
                        ? LinearGradient(
                            colors: [
                              colorScheme.primary,
                              colorScheme.primary.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isUserMessage ? null : colorScheme.surface,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                        offset: const Offset(0, 4),
                      ),
                      if (!isUserMessage)
                        BoxShadow(
                          color: Colors.white.withOpacity(0.8),
                          blurRadius: 10.0,
                          spreadRadius: -2.0,
                          offset: const Offset(0, -2),
                        ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: textTheme.bodyLarge?.copyWith(
                          color: isUserMessage
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          height: 1.5,
                        ),
                      ),
                      if (sources != null && sources!.isNotEmpty) ...[
                        const SizedBox(height: 12.0),
                        Text(
                          'Sources :',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: sources!.map((source) => ElevatedButton(
                                onPressed: () {
                                  _showPriceDialog(
                                    context,
                                    source['name']!,
                                    source['price']!,
                                    source['url']!,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary.withOpacity(0.1),
                                  foregroundColor: colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 8.0,
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  source['name']!,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.0,
                                  ),
                                ),
                              )).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isUserMessage) ...[
            const SizedBox(width: 12.0),
            CircleAvatar(
              radius: 20.0,
              backgroundImage: const AssetImage('assets/images/user_avatar.png'),
              backgroundColor: colorScheme.surface,
              child: const Icon(Icons.person, color: Colors.white), // Fallback icon
              onBackgroundImageError: (exception, stackTrace) {
                print('Erreur de chargement de l\'image user_avatar.png: $exception');
              },
            ),
          ],
        ],
      ),
    );
  }
}