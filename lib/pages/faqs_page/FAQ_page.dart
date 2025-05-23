import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'faq_manager.dart';

final TextEditingController textController = TextEditingController();
final FirestoreService firestoreService = FirestoreService();

class QAItem extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color backgroundColor;
  final Color titleColor;
  final Color childrenColor;

  const QAItem({
    Key? key,
    required this.title,
    required this.children,
    this.backgroundColor = Colors.green,
    this.titleColor = Colors.black,
    this.childrenColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: children
          .map((child) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: DefaultTextStyle(
            style: TextStyle(
              color: childrenColor,
              fontSize: 16.0,
            ),
            child: child,
          ),
        ),
      ))
          .toList(),
      backgroundColor: backgroundColor,
    );
  }
}

class FAQ_page extends StatefulWidget {
  const FAQ_page({Key? key}) : super(key: key);

  @override
  _FAQ_pageState createState() => _FAQ_pageState();
}

class _FAQ_pageState extends State<FAQ_page> {
  late TextEditingController _searchController;
  List<QAItem> _allQuestions = [];
  List<QAItem> _filteredQuestions = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    _fetchQuestions();
  }

  void _fetchQuestions() {
    firestoreService.getQuestionStream().listen((querySnapshot) {
      setState(() {
        _allQuestions.clear(); // Clear the existing questions
        _allQuestions = querySnapshot.docs.map((document) {
          return QAItem(
            title: document['note'],
            children: [
              Text(document['answer'] ?? ''),
            ],
          );
        }).toList();
        _filteredQuestions.clear(); // Clear the filtered questions as well
        _filteredQuestions.addAll(_allQuestions);
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredQuestions = _allQuestions.where((qaItem) {
        final title = qaItem.title.toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
        backgroundColor: Colors.green,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openQuestionBox,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.green[700],
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    minimumSize: const Size(0, 50),
                  ),
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredQuestions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _filteredQuestions[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void openQuestionBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              try {
                await firestoreService.addQuestion(context, textController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Question added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              textController.clear();
              Navigator.pop(context);
            },
            child: Text("Add"),
          )
        ],
      ),
    );
  }
}
