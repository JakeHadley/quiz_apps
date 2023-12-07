import 'package:quiz_core/models/language.dart';

///
const baseUrl = 'https://www.churchofjesuschrist.org/study/scriptures/nt/';

///
const matthew = ['Matthew', 'Mateus'];

///
const mark = ['Mark', 'Marcos'];

///
const luke = ['Luke', 'Lucas'];

///
const john = ['John', 'João'];

///
const colossians = ['Colossians', 'Colossenses'];

///
class ParsedEntry {
  ///
  ParsedEntry(this.book, this.chapter, this.verses, this.start);

  ///
  final String book;

  ///
  final String chapter;

  ///
  final String verses;

  ///
  final String start;
}

///
String getBook(String ref) {
  if (matthew.contains(ref)) {
    return 'matt';
  } else if (mark.contains(ref)) {
    return 'mark';
  } else if (luke.contains(ref)) {
    return 'luke';
  } else if (john.contains(ref)) {
    return 'john';
  } else if (colossians.contains(ref)) {
    return 'col';
  }
  return '';
}

///
ParsedEntry parseEntry(String entry) {
  final halves = entry.split(':');
  var book = '';
  var chapter = '1';
  var verses = '';
  var start = '';

  if (halves[0].split(' ').length == 1) {
    //only the book, no chapters
    book = getBook(halves[0].split(' ')[0]);
    return ParsedEntry(book, chapter, verses, start);
  }

  //it's a regular book
  //John 15-16
  //John 5:3-5, 10-12, 20
  if (halves.length == 1) {
    //no verses
    //[0] is 'John 5-8'
    book = getBook(halves[0].split(' ')[0]);
    chapter = halves[0].split(' ')[1].split('-')[0];
  } else if (halves.length == 2) {
    //verses
    //[0] is 'John 5'
    book = getBook(halves[0].split(' ')[0]);
    chapter = halves[0].split(' ')[1];

    //[1] is '3-5, 10-12'
    final inputVerses = halves[1]
        .replaceAll(RegExp('/ /g'), '')
        .replaceAll(RegExp('/d+/g'), r'p$&');
    verses = 'id=$inputVerses&';
    final startMatches = RegExp(r'\d+').firstMatch(verses);
    if (startMatches != null) {
      start = '#p${startMatches.group(0)}';
    }
  }

  return ParsedEntry(book, chapter, verses, start);
}

///
String getLanguage(String language) {
  if (language == Languages.en.name) {
    return 'eng';
  } else if (language == Languages.pt.name) {
    return 'por';
  } else if (language == Languages.es.name) {
    return 'spa';
  }
  return '';
}

///
Uri getUriFromReference(String reference, String locale) {
  final lang = getLanguage(locale);

  final parsed = parseEntry(reference);
  return Uri.parse(
    '$baseUrl'
    '${parsed.book}/'
    '${parsed.chapter}?'
    '${parsed.verses}'
    'lang=$lang'
    '${parsed.start}',
  );
}
