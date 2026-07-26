/// Non-web fallback so widget tests can run on the Dart VM.
///
/// The app only ships to web; this exists purely so importing the widget tree
/// does not drag `package:web` into a VM test isolate.
void openUrlImpl(String url) {}

void setDocumentLanguageImpl(String tag) {}
