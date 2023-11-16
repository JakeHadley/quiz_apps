import 'package:flag/flag.dart';

/// Languages currently supported in the app
/// english (en)
/// portuguese (pt)
/// spanish (es)
enum Languages {
  /// english
  en,

  /// portuguese
  pt,

  /// es
  es,
}

/// Flag widgets list in order of the language
/// US (english)
/// BR (portuguese)
/// ES (spanish)
List<Flag> flags = [
  Flag.fromCode(FlagsCode.US),
  Flag.fromCode(FlagsCode.BR),
  Flag.fromCode(FlagsCode.ES),
];
