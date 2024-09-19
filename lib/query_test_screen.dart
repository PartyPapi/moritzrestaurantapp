import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingFilter extends StatefulWidget {
  final Function(String?) onRatingChange;

  const RatingFilter({super.key, required this.onRatingChange});

  @override
  _RatingFilterState createState() => _RatingFilterState();
}

class _RatingFilterState extends State<RatingFilter> {
  String? selectedRating;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedRating,
      hint: const Text("Bewertung auswählen"),
      items: List.generate(5, (index) {
        return DropdownMenuItem(
          value: (index + 1).toString(),
          child: Text((index + 1).toString()),
        );
      }),
      onChanged: (value) {
        setState(() {
          selectedRating = value;
        });
        widget.onRatingChange(value);
      },
    );
  }
}

class ZipCodeFilter extends StatefulWidget {
  final Function(String) onZipChange;

  const ZipCodeFilter({super.key, required this.onZipChange});

  @override
  _ZipCodeFilterState createState() => _ZipCodeFilterState();
}

class _ZipCodeFilterState extends State<ZipCodeFilter> {
  String zipCode = '';

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(labelText: "Postleitzahl eingeben"),
      onChanged: (text) {
        setState(() {
          zipCode = text;
        });
        widget.onZipChange(text);
      },
    );
  }
}

Future<void> fetchFilteredRestaurants(String? rating, String zipCode) async {
  CollectionReference restaurantsRef =
      FirebaseFirestore.instance.collection('restaurants');

  Query query = restaurantsRef;

  if (rating != null) {
    query = query.where('rating',
        isEqualTo: int.parse(rating)); // Filter nach Bewertung
  }

  if (zipCode.isNotEmpty) {
    query = query.where('postalCode', isEqualTo: zipCode); // Filter nach PLZ
  }

  try {
    QuerySnapshot snapshot = await query.get();
    snapshot.docs.forEach((doc) {
      print('${doc.id} => ${doc.data()}');
    });
  } catch (error) {
    print("Fehler beim Abrufen der Dokumente: $error");
  }
}

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? selectedRating;
  String inputZipCode = '';

  void handleFilter() {
    fetchFilteredRestaurants(selectedRating, inputZipCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurant Filter")),
      body: Column(
        children: [
          RatingFilter(
              onRatingChange: (rating) =>
                  setState(() => selectedRating = rating)),
          ZipCodeFilter(
              onZipChange: (zip) => setState(() => inputZipCode = zip)),
          ElevatedButton(
            onPressed: handleFilter,
            child: const Text("Filtern"),
          ),
        ],
      ),
    );
  }
}
