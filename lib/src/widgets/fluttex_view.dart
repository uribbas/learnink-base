import 'package:flutter/material.dart';
import 'package:fluttex/math_view_static.dart';
import 'package:learnink/src/widgets/learnink_network_image.dart';

enum TokenType {
  NORMALTEXT,
  TEXTEXT,
  IMAGE,
}

class Token {
  Token({this.tokenString, this.tokenType});
  String tokenString;
  TokenType tokenType;
}

class FluttexView extends StatelessWidget {
  FluttexView({@required this.texString});
  final String texString;
  List<Token> tokens = [];

  void _parse() {
    int currIndex = 0;
    int startOfTexString;
    String texStartMarker;
    int startOfNormalString;
    int startOfImgTag;
    Map<String, String> endMarkers = {
      "\\(": "\\)",
      "\\[": "\\]",
      "\$\$": "\$\$",
      "\$": "\$"
    };

    bool eos(int index) {
      return !(index < texString.length);
    }

    String doubleChar(int index) {
      if (!eos(index + 1)){
        return texString.substring(index, index + 2);
      }
      return null;
    }

    int consumeSpaces(int index) {
      print("Inside consume spaces:$index");
      while (!eos(index) && [' ', '\t'].contains(texString[index])) {
        index++;
      }
      return index;
    }

    while (!eos(currIndex)) {
      print("$currIndex:${texString[currIndex]}");
      //print("$startOfTexString:${texStartMarker},${doubleChar(currIndex)},${endMarkers[texStartMarker]}");
      currIndex = consumeSpaces(currIndex);
      if (eos(currIndex)) {
        continue;
      }

      if (["\\(", "\\[", "\$\$"].contains(doubleChar(currIndex))&& startOfTexString==null) {
        if (startOfNormalString != null) {
          tokens.add(Token(
              tokenString: texString.substring(startOfNormalString, currIndex),
              tokenType: TokenType.NORMALTEXT));
          startOfNormalString = null;
        }
        texStartMarker = doubleChar(currIndex);
        print("Inside tex start $texStartMarker");
        currIndex += 2;
        startOfTexString = currIndex;
        print("Inside start of Tex String:$startOfTexString");

        continue;
      } else if (texString[currIndex] == '\$' && startOfTexString==null) {
        if (startOfNormalString != null) {
          tokens.add(Token(
              tokenString: texString.substring(startOfNormalString, currIndex),
              tokenType: TokenType.NORMALTEXT));
          startOfNormalString = null;
        }
        texStartMarker = "\$";
        currIndex++;
        startOfTexString = currIndex;
        continue;
      } else if (startOfTexString != null && texString[currIndex] == '<') {
        int lastTexIndex=currIndex;
        int subIndex = currIndex + 1;
        subIndex = consumeSpaces(subIndex);
        if (eos(subIndex)) {
          currIndex = subIndex;
          continue;
        }
        if (!eos(subIndex + 3) &&
            (texString.substring(subIndex, subIndex + 4) == "img " ||
                texString.substring(subIndex, subIndex + 4) == "img\t")) {
          subIndex = subIndex + 3;
          subIndex = consumeSpaces(subIndex);
          if (eos(subIndex)) {
            currIndex = subIndex;
            continue;
          }
          if (!eos(subIndex + 2) &&
              texString.substring(subIndex, subIndex + 3) == "src") {
            subIndex=subIndex+3;
            subIndex = consumeSpaces(subIndex);
            if (eos(subIndex)) {
              currIndex = subIndex;
              continue;
            }
            //String equalSign=texString[subIndex];
            if (texString[subIndex] == "=") {
              subIndex = consumeSpaces(subIndex);
              if (eos(subIndex)) {
                currIndex = subIndex;
                continue;
              }
              subIndex++;
              startOfImgTag = subIndex;
              currIndex = subIndex;
              if(texString.substring(startOfTexString, lastTexIndex).isNotEmpty) {
                tokens.add(Token(
                    tokenString: texString.substring(
                        startOfTexString, lastTexIndex),
                    tokenType: TokenType.TEXTEXT));

              }
              startOfTexString = null;
              continue;
            }
          } else {
            // handle 'less than sign', continuation of texString
            currIndex++;
          }
        }
      } else if (startOfTexString != null &&
          (doubleChar(currIndex) == endMarkers[texStartMarker] ||
              texString[currIndex] == endMarkers[texStartMarker])) {
        print(
            "Inside Token(tokenString):$startOfTexString,${texString.substring(startOfTexString, currIndex)}");
        tokens.add(Token(
            tokenString: texString.substring(startOfTexString, currIndex),
            tokenType: TokenType.TEXTEXT));

        print(
            "Outside increment:${doubleChar(currIndex)},$texStartMarker,${endMarkers[texStartMarker]}");
        if (doubleChar(currIndex) == endMarkers[texStartMarker]) {
          currIndex++;
        }
        startOfTexString = null;
        texStartMarker = null;
        currIndex++;
        startOfNormalString = currIndex;
      } else if (startOfTexString != null && texString[currIndex] != '<') {
        // continuation of TeX String
        print("Inside continuation of TexString:${texString[currIndex]}");
        currIndex++;
      } else if (startOfImgTag != null) {
        int subIndex = startOfImgTag;
        subIndex = consumeSpaces(subIndex);
        if (eos(subIndex)) {
          currIndex = subIndex;
          continue;
        }
        //String quoteCharacter=texString[subIndex];
        if (["\"", "\'"].contains(texString[subIndex])) {
          String urlStartChar = texString[subIndex];
          int urlStartIndex = ++subIndex;
          while (!eos(subIndex) && texString[subIndex] != urlStartChar) {
            subIndex++;
          }
          //String imgUrl=texString.substring(urlStartIndex, subIndex);
          tokens.add(Token(
              tokenString: texString.substring(urlStartIndex, subIndex),
              tokenType: TokenType.IMAGE));
        }
        while (!eos(subIndex) && doubleChar(subIndex) != "\\>") {
          subIndex++;
        }
        subIndex+=2;
        subIndex = consumeSpaces(subIndex);
        if (eos(subIndex)) {
          currIndex = subIndex;
          continue;
        }
        startOfImgTag = null;
        currIndex = subIndex;
        startOfTexString = currIndex;
      } else if (startOfNormalString == null) {
        // Normal String
        startOfNormalString = currIndex;
        currIndex++;
      } else {
        // NormalString continues
        currIndex++;
      }
    }
    if (startOfNormalString != null) {
      tokens.add(Token(
          tokenString: texString.substring(startOfNormalString),
          tokenType: TokenType.NORMALTEXT));
    }
  }

  double _characterCount(String texString) {
    double count = 0;
    int currIndex = 0;
    bool group = false;
    bool script = false;
    double factor = 1;
    List<String> endOfWord = [
      "+",
      "-",
      "*",
      "%",
      "(",
      ")",
      "\\",
      " ",
      "\t",
      "}",
      "{"
    ];
    List<String> scripts = ["\^", "\_"];
    bool eos(index) {
      return !(index < texString.length);
    }

    int consumeSpaces(index) {
      while (!eos(index) && [" ", "\t"].contains(texString[index])) {
        index++;
      }
      return index;
    }

    while (!eos(currIndex)) {
      currIndex = consumeSpaces(currIndex);
      if (eos(currIndex)) {
        continue;
      }
      print("_charaterCount:Print of character:${texString[currIndex]}");
      if (scripts.contains(texString[currIndex])) {
        currIndex++;
        script = true;
        factor = 0.5;
        print("I have been here:${texString[currIndex]}");
      } else if (texString[currIndex] == "{") {
        currIndex++;
        group = true;
      } else if (texString[currIndex] == "}") {
        currIndex++;
        group = false;
        factor = script ? 1 : factor;
      } else if (texString[currIndex] == "\\") {
        currIndex++;
        while (!eos(currIndex) && !endOfWord.contains(texString[currIndex])) {
          currIndex++;
        }
        count += factor;
      } else {
        count += factor;
        print("Character:${texString[currIndex]},$count");
        script = script & group;
        factor = script ? factor : 1;
        currIndex++;
      }
    }
    return count;
  }
  double _calculateHeight(String texString){
    if(texString.contains("\\frac")){
      return 2;
    }else if(texString.contains("\\over")){
      return 2;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    print("Inside build FlutterView");
    _parse();
    print("Inside build FlutterView");
    print("tokens $tokens");
    List<InlineSpan> _widgetSpan = [];

    for (Token tok in tokens) {
      if (tok.tokenType == TokenType.NORMALTEXT) {
        _widgetSpan.add(WidgetSpan(
            child: Text(
          tok.tokenString,
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        )));
      } else if (tok.tokenType == TokenType.TEXTEXT) {
        //print("CharacterCount:${tok.tokenString},${_characterCount(tok.tokenString)}");
        double maxWidth = _characterCount(tok.tokenString) * 16.0;
        double maxHeight = _calculateHeight(tok.tokenString)*20;
        _widgetSpan.add(WidgetSpan(
            child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
                child: MathViewStatic( key:UniqueKey(), tex: tok.tokenString))));
      }
      else if(tok.tokenType== TokenType.IMAGE){
        _widgetSpan.add(
          WidgetSpan(child:LearninkNetworkImage(tok.tokenString),),
        );
      }
    }
    return Text.rich(TextSpan(text: '', children: _widgetSpan));
  }
}
