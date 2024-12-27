extension StringExtension on String {
  String nameSyntaxCheck() {
    if (contains('Hi, I am ')) {
      return 'Hi, I am ';
    }
    return this;
  }

  String nameCheck() {
    if (startsWith('Hi, I am ')) {
      return replaceFirst('Hi, I am ', '');
    } else {
      return '';
    }
  }
}
