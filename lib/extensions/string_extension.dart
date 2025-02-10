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

  String get linkedinTag {
    return replaceAll('linkedin.com/', '');
  }

  String get getGithubNameFromUrl => split('/').last;

  String get xTag {
    return replaceAll('x.com/', '');
  }

  String get instagramTag {
    return replaceAll('instagram.com/', '');
  }

  String get toGithubRepo {
    return '$this?tab=repositories';
  }

  String get toGithubProjects {
    return '$this?tab=projects';
  }

  String get fixPackageName {
    return split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
