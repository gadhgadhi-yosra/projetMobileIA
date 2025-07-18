
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/product.dart';
// import '../widgets/chatbot_message.dart';

// class ChatbotScreen extends StatefulWidget {
//   const ChatbotScreen({Key? key}) : super(key: key);

//   @override
//   State<ChatbotScreen> createState() => _ChatbotScreenState();
// }

// class _ChatbotScreenState extends State<ChatbotScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<Map<String, dynamic>> _messages = [];
//   final currencyFormatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _addBotMessage("Bonjour ! Je suis votre assistant de prix. Quel article souhaitez-vous comparer ?");
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _addBotMessage(String text, {List<Map<String, String>>? sources}) {
//     setState(() {
//       _messages.add({'text': text, 'isUser': false, 'sources': sources});
//     });
//     _scrollToBottom();
//   }

//   void _addUserMessage(String text) {
//     setState(() {
//       _messages.add({'text': text, 'isUser': true});
//     });
//     _scrollToBottom();
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   void _handleSubmitted(String text) {
//     if (text.trim().isEmpty) return;

//     _controller.clear();
//     _addUserMessage(text);

//     Future.delayed(const Duration(seconds: 1), () {
//       final query = text.toLowerCase();
//       final matchingProducts = Product.dummyProducts.where((p) =>
//         p.name.toLowerCase().contains(query) ||
//         p.description.toLowerCase().contains(query) ||
//         p.category.toLowerCase().contains(query)
//       ).toList();

//       if (matchingProducts.isNotEmpty) {
//         String botResponse = "Voici les informations de prix que j'ai trouvées pour \"$text\":\n\n";
//         List<Map<String, String>> sources = [];

//         for (var product in matchingProducts) {
//           botResponse += "${product.name} (Votre prix: ${currencyFormatter.format(product.price)})\n";
//           for (var competitorPrice in product.competitorPrices) {
//             botResponse += "  - ${competitorPrice.competitor}: ${currencyFormatter.format(competitorPrice.price)}\n";
//             sources.add({
//               'name': "${product.name} - ${competitorPrice.competitor}",
//               'url': competitorPrice.url
//             });
//           }
//           botResponse += "\n";

//           final ourPrice = product.price;
//           final avgCompetitorPrice = product.competitorPrices.map((cp) => cp.price).reduce((a, b) => a + b) / product.competitorPrices.length;

//           if (ourPrice < avgCompetitorPrice * 0.95) {
//             botResponse += "Recommandation pour ${product.name}: Votre prix est très compétitif, vous pourriez envisager de le maintenir ou même de l'augmenter légèrement si la demande est forte.\n\n";
//           } else if (ourPrice > avgCompetitorPrice * 1.05) {
//             botResponse += "Recommandation pour ${product.name}: Votre prix est plus élevé que la moyenne des concurrents. Il serait judicieux de le baisser pour rester compétitif.\n\n";
//           } else {
//             botResponse += "Recommandation pour ${product.name}: Votre prix est en ligne avec le marché. Vous pouvez le garder tel quel.\n\n";
//           }
//         }

//         _addBotMessage(botResponse, sources: sources);
//       } else {
//         _addBotMessage("Désolé, je n'ai pas trouvé d'informations de prix pour \"$text\". Veuillez essayer une autre recherche.");
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Assistant de Prix IA'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); 
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: const EdgeInsets.all(8.0),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index];
//                 return ChatbotMessage(
//                   text: message['text'],
//                   isUserMessage: message['isUser'],
//                   sources: message['sources'] as List<Map<String, String>>?,
//                 );
//               },
//             ),
//           ),
//           Divider(height: 1.0, color: colorScheme.onSurface.withOpacity(0.1)),
//           Container(
//             decoration: BoxDecoration(
//               color: colorScheme.surface,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, -3),
//                 ),
//               ],
//             ),
//             child: _buildTextComposer(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextComposer() {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               onSubmitted: _handleSubmitted,
//               decoration: InputDecoration(
//                 hintText: 'Demandez-moi un prix...',
//                 hintStyle: textTheme.bodyLarge?.copyWith(
//                   color: colorScheme.onSurface.withOpacity(0.6),
//                 ),
//                 filled: true,
//                 fillColor: colorScheme.background,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25.0),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
//               ),
//               style: textTheme.bodyLarge?.copyWith(
//                 color: colorScheme.onSurface,
//               ),
//               cursorColor: colorScheme.primary,
//             ),
//           ),
//           const SizedBox(width: 8.0),
//           FloatingActionButton(
//             onPressed: () => _handleSubmitted(_controller.text),
//             backgroundColor: colorScheme.primary,
//             foregroundColor: colorScheme.onPrimary,
//             elevation: 0,
//             child: const Icon(Icons.send),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:supermarket_app_03072025/widgets/chatbot_message.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ChatbotScreen extends StatefulWidget {
//   const ChatbotScreen({Key? key}) : super(key: key);

//   @override
//   State<ChatbotScreen> createState() => _ChatbotScreenState();
// }

// class _ChatbotScreenState extends State<ChatbotScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<Map<String, dynamic>> _messages = [];
//   final currencyFormatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'TND');
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _addBotMessage("Bonjour ! Je suis votre assistant de prix. Quel article souhaitez-vous comparer ?");
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _addBotMessage(String text, {List<Map<String, String>>? sources}) {
//     setState(() {
//       _messages.add({'text': text, 'isUser': false, 'sources': sources});
//     });
//     _scrollToBottom();
//   }

//   void _addUserMessage(String text) {
//     setState(() {
//       _messages.add({'text': text, 'isUser': true});
//     });
//     _scrollToBottom();
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   Future<void> _handleSubmitted(String text) async {
//     if (text.trim().isEmpty) return;

//     _controller.clear();
//     _addUserMessage(text);

//     // Exemple: ici on demande le prix à l'utilisateur dans un dialogue simple (pour demo)
//     double? yourPrice = await _askForPrice(context);
//     if (yourPrice == null) {
//       _addBotMessage("Veuillez fournir un prix valide pour le produit.");
//       return;
//     }

//     _addBotMessage("Recherche des prix concurrents pour \"$text\" ...");

//     try {
//       // Remplace par l'URL de ton backend FastAPI
//       const backendUrl = "http://127.0.0.1:8000/compare_price";

//       final response = await http.post(
//         Uri.parse(backendUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "product_name": text,
//           "your_price": yourPrice,
//           // tu peux ajouter "competitors": ["Géant", "Aziza", "Jumia"] ou laisser vide pour tous
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         String botResponse = "Voici les informations de prix que j'ai trouvées pour \"$text\":\n\n";
//         List<Map<String, String>> sources = [];

//         for (var cp in data['competitor_prices']) {
//           botResponse +=
//               "  - ${cp['competitor']}: ${currencyFormatter.format(cp['price'])}\n";
//           sources.add({'name': cp['competitor'], 'url': cp['url']});
//         }
//         botResponse += "\nRecommandation : ${data['recommendation']}";

//         _addBotMessage(botResponse, sources: sources);
//       } else {
//         _addBotMessage("Erreur du serveur: ${response.statusCode}");
//       }
//     } catch (e) {
//       _addBotMessage("Erreur lors de la communication avec le serveur: $e");
//     }
//   }

//   // Dialogue simple pour demander le prix au user
//   Future<double?> _askForPrice(BuildContext context) async {
//     final priceController = TextEditingController();
//     double? result;

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Entrez votre prix (TND)'),
//         content: TextField(
//           controller: priceController,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(hintText: "Ex: 1500"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               final val = double.tryParse(priceController.text.trim());
//               if (val != null && val > 0) {
//                 result = val;
//                 Navigator.of(context).pop();
//               }
//             },
//             child: const Text('OK'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('Annuler'),
//           ),
//         ],
//       ),
//     );
//     return result;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Assistant de Prix IA'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: const EdgeInsets.all(8.0),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index];
//                 return ChatbotMessage(
//                   text: message['text'],
//                   isUserMessage: message['isUser'],
//                   sources: message['sources'] as List<Map<String, String>>?,
//                 );
//               },
//             ),
//           ),
//           Divider(height: 1.0, color: colorScheme.onSurface.withOpacity(0.1)),
//           Container(
//             decoration: BoxDecoration(
//               color: colorScheme.surface,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, -3),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       onSubmitted: _handleSubmitted,
//                       decoration: InputDecoration(
//                         hintText: 'Demandez-moi un prix...',
//                         hintStyle: textTheme.bodyLarge?.copyWith(
//                           color: colorScheme.onSurface.withOpacity(0.6),
//                         ),
//                         filled: true,
//                         fillColor: colorScheme.background,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 20.0, vertical: 12.0),
//                       ),
//                       style: textTheme.bodyLarge?.copyWith(
//                         color: colorScheme.onSurface,
//                       ),
//                       cursorColor: colorScheme.primary,
//                     ),
//                   ),
//                   const SizedBox(width: 8.0),
//                   FloatingActionButton(
//                     onPressed: () => _handleSubmitted(_controller.text),
//                     backgroundColor: colorScheme.primary,
//                     foregroundColor: colorScheme.onPrimary,
//                     elevation: 0,
//                     child: const Icon(Icons.send),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:supermarket_app_03072025/widgets/chatbot_message.dart';
import 'package:supermarket_app_03072025/widgets/custom_curved_navigation_bar.dart';


class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final currencyFormatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'TND');
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _addBotMessage("Bonjour ! Je suis votre assistant de prix. Quel article souhaitez-vous comparer ?");
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addBotMessage(String text, {List<Map<String, String>>? sources}) {
    setState(() {
      _messages.add({'text': text, 'isUser': false, 'sources': sources});
    });
    _scrollToBottom();
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add({'text': text, 'isUser': true});
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _controller.clear();
    _addUserMessage(text);

    // Exemple: ici on demande le prix à l'utilisateur dans un dialogue simple (pour demo)
    double? yourPrice = await _askForPrice(context);
    if (yourPrice == null) {
      _addBotMessage("Veuillez fournir un prix valide pour le produit.");
      return;
    }

    _addBotMessage("Recherche des prix concurrents pour \"$text\" ...");

    try {
      // Remplace par l'URL de ton backend FastAPI
      const backendUrl = "http://127.0.0.1:8000/compare_price";

      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "product_name": text,
          "your_price": yourPrice,
          // tu peux ajouter "competitors": ["Géant", "Aziza", "Jumia"] ou laisser vide pour tous
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        String botResponse = "Voici les informations de prix que j'ai trouvées pour \"$text\":\n\n";
        List<Map<String, String>> sources = [];

        for (var cp in data['competitor_prices']) {
          botResponse +=
              "  - ${cp['competitor']}: ${currencyFormatter.format(cp['price'])}\n";
          sources.add({'name': cp['competitor'], 'url': cp['url']});
        }
        botResponse += "\nRecommandation : ${data['recommendation']}";

        _addBotMessage(botResponse, sources: sources);
      } else {
        _addBotMessage("Erreur du serveur: ${response.statusCode}");
      }
    } catch (e) {
      _addBotMessage("Erreur lors de la communication avec le serveur: $e");
    }
  }

  // Dialogue simple pour demander le prix au user
  Future<double?> _askForPrice(BuildContext context) async {
    final priceController = TextEditingController();
    double? result;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Entrez votre prix (TND)'),
        content: TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "Ex: 1500"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final val = double.tryParse(priceController.text.trim());
              if (val != null && val > 0) {
                result = val;
                Navigator.of(context).pop();
              }
            },
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant de Prix IA'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatbotMessage(
                  text: message['text'],
                  isUserMessage: message['isUser'],
                  sources: message['sources'] as List<Map<String, String>>?,
                );
              },
            ),
          ),
          Divider(height: 1.0, color: colorScheme.onSurface.withOpacity(0.1)),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: _handleSubmitted,
                      decoration: InputDecoration(
                        hintText: 'Demandez-moi un prix...',
                        hintStyle: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        filled: true,
                        fillColor: colorScheme.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                      ),
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      cursorColor: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  FloatingActionButton(
                    onPressed: () => _handleSubmitted(_controller.text),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    elevation: 0,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomCurvedNavigationBar(), // Ajout de la barre de navigation
    );
  }
}