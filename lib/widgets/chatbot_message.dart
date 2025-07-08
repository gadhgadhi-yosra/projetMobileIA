
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatbotMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;
  final List<Map<String, String>>? sources;

  const ChatbotMessage({
    Key? key,
    required this.text,
    this.isUserMessage = false,
    this.sources,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final messageBackgroundColor = isUserMessage ? colorScheme.primary : colorScheme.surface;
    final messageTextColor = isUserMessage ? colorScheme.onPrimary : colorScheme.onSurface;

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: messageBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
            bottomLeft: isUserMessage ? const Radius.circular(16.0) : const Radius.circular(4.0),
            bottomRight: isUserMessage ? const Radius.circular(4.0) : const Radius.circular(16.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16.0, 
                color: messageTextColor,
              ),
            ),
            if (sources != null && sources!.isNotEmpty) ...[
              const SizedBox(height: 10.0),
              Text(
                'Sources:',
                style: TextStyle(
                  fontSize: 12.0, 
                  color: messageTextColor.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...sources!.map((source) {
                return InkWell(
                  onTap: () async {
                    final url = source['url'];
                    if (url != null) {
                      final uri = Uri.parse(url);
                      try {
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Impossible d\'ouvrir l\'URL: $url')),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur: $e')),
                          );
                        }
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Text(
                      '- ${source['name'] ?? 'Source sans nom'}',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: colorScheme.secondary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }
}