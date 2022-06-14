import 'dart:io';

String fixture(fileName) =>
    File('test/fixtures/$fileName.json').readAsStringSync();
