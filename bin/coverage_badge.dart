// NOTE: The preferred way is to install lcov and use command `lcov --summary path/to/lcov.info`
// Use this script only if you can't install lcov on your platform.

// Usage: dart coverage.dart path/to/lcov.info

import 'dart:io';

void main(List<String> args) async {
  final lcovFile = args[0];
  final lines = await File(lcovFile).readAsLines();
  final coverage = lines.fold([0, 0], (List<int> data, line) {
    var testedLines = data[0];
    var totalLines = data[1];
    if (line.startsWith('DA')) {
      totalLines++;
      if (!line.endsWith('0')) {
        testedLines++;
      }
    }
    return [testedLines, totalLines];
  });
  final testedLines = coverage[0];
  final totalLines = coverage[1];
  print(
    'Total test coverage: ${(testedLines / totalLines * 100).toStringAsFixed(2)}%',
  );
  var svg = '''
  <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="102" height="20">
  <linearGradient id="b" x2="0" y2="100%">
    <stop offset="0" stop-color="#bbb" stop-opacity=".1"/>
    <stop offset="1" stop-opacity=".1"/>
  </linearGradient>
  <clipPath id="a">
    <rect width="102" height="20" rx="3" fill="#fff"/>
  </clipPath>
  <g clip-path="url(#a)">
    <path fill="#555" d="M0 0h59v20H0z"/>
    <path fill="#44cc11" d="M59 0h43v20H59z"/>
    <path fill="url(#b)" d="M0 0h102v20H0z"/>
  </g>
  <g fill="#fff" text-anchor="middle" font-family="DejaVu Sans,Verdana,Geneva,sans-serif" font-size="110">
    <text x="305" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)" textLength="490">coverage</text>
    <text x="305" y="140" transform="scale(.1)" textLength="490">coverage</text>
    <text x="795" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)" textLength="330">REPLACEME</text>
    <text x="795" y="140" transform="scale(.1)" textLength="330">100%</text>
  </g>
</svg>
''';
  svg = svg.replaceAll(
    RegExp(r'REPLACEME', multiLine: true),
    '${(testedLines / totalLines * 100).toStringAsFixed(2)}%',
  );
  File('./coverage_badge.svg').writeAsStringSync(svg, mode: FileMode.write);
}
