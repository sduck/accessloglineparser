import 'dart:html';

TextAreaElement logLine;
UListElement resultList;

void main() {
  resultList = query('#result_output');
  logLine = query('#logline');
  
  query('#parse_button').onClick.listen(parseLine);
  String initTxt = query('#logline').text;
  if (initTxt.isNotEmpty) {
    query('#logline').text = initTxt.trim();
  }
}

void parseLine(MouseEvent event) {
  String logline = logLine.text;
  
  if (logline.isEmpty) {
    var li = new LIElement();
    li.text = 'Please fill in a logline';
    resultList.append(li);
    logLine.focus();
    return;
  }
  
  List<String> parts = new List<String>();
  parts.add(r'^(\d+\.\d+\.\d+\.\d+)'); // IP address  
  parts.add('-'); // Sep
  parts.add(r'(.+?)'); // Remote users
  parts.add(r'\[(.+?)\]'); // Time
  parts.add(r'"([A-Z]{2,8}) ([^ ]*) ([^"]*)"'); // Request
  parts.add(r'(\d{3})'); // HTTP status
  parts.add(r'(\d+?)'); // Bytes sent
  parts.add(r'"([^"]*)"'); // Referer
  parts.add(r'"([^"]*)"'); // UserAgent
  
  //parts.add(r'.*');
  
  RegExp reg = new RegExp(parts.join(' '));
  Iterable<Match> matches = reg.allMatches(logline);
  
  String result = '';
  for (Match match in matches) {
    for (int i = 1; i <= match.groupCount; i++) {
      var li = new LIElement();
      li.text = match.group(i);
      resultList.append(li);
    }
  }
  
}