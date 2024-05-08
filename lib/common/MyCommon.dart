import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

const kSmilies = {':)': '🙂'};

// final smilieOp = BuildOp(
//   onPieces: (meta, pieces) {
//     final alt = meta.domElement.attributes['alt'];
//     final text = kSmilies.containsKey(alt) ? kSmilies[alt] : alt;
//     return pieces..first?.block?.addText(text);
//   },
// );