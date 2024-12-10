import 'package:english_dictionary/DictionaryPage/dictionary_model.dart';
import 'package:english_dictionary/DictionaryPage/services.dart';
import 'package:flutter/material.dart';

class DictionaryHomePage extends StatefulWidget {
  const DictionaryHomePage({super.key});

  @override
    // TODO: implement ==
    State<DictionaryHomePage> createState() => _DictionaryHomePageState();
}

class _DictionaryHomePageState extends State<DictionaryHomePage> {
  DictionaryModel? myDictionaryModel;
  bool isLoading = false;
  String noDataFound = "Now You Can Search";

  searchContain(String word) async {
    setState(() {
      isLoading = true;
    });
    try{
    myDictionaryModel = await APIservices.fetchData(word);
    setState(() {});
  } catch (e) {
    myDictionaryModel = null;
    noDataFound = "Meaning can't be found";
  } finally {
    setState(() {
      isLoading = false;
    });
  }
  }
  @override
    // TODO: implement ==
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dictionary"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            // for searching the words
            SearchBar( 
              hintText:"Search Word Here",
              onSubmitted: (value) {
                searchContain(value);
              },
            ),
          const SizedBox(height: 15),
          if (isLoading) 
            const LinearProgressIndicator()
          else if (myDictionaryModel != null)
            Expanded(
              child: Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  const SizedBox(height: 10),
                  Text(
                    myDictionaryModel!.word,
                    style:const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    myDictionaryModel!.phonetics.isNotEmpty
                  ? myDictionaryModel!.phonetics[0].text ?? "" 
                  : ""
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: myDictionaryModel!.meanings.length,
                      itemBuilder: (context, index) {
                        return showMeaning(myDictionaryModel!.meanings[index]);
                      },
                    ),    
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  showMeaning(Meaning meaning){
    String wordDefinition = "";
    for(var element in meaning.definitions){
      int index = meaning.definitions.indexOf(element);
    wordDefinition += "\n${ index +1}. ${element.definition}\n";
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child:Material(
        elevation:  2,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meaning.partOfSpeech,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Definitions: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                wordDefinition,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1,
                ),
              ),
              wordRelation("Synonyms", meaning.synonyms),
              wordRelation("Antonyms", meaning.antonyms),
            ],
          ),
        ),
      ),
    );
  }
  wordRelation(String title,List<String>? setList){
    if(setList?.isNotEmpty ?? false){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title : ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            setList!.toSet().toString().replaceAll("{", "").replaceAll("}", ""),
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}