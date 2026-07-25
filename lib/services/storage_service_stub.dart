/// In-memory store for non-web targets.
///
/// The app only ships to web; this exists so importing the widget tree does
/// not drag `package:web` into a VM test isolate, and so tests get a cache
/// that starts empty every run.
class StorageBackend {
  static final Map<String, String> _memory = {};

  static String? read(String key) => _memory[key];

  static void write(String key, String value) => _memory[key] = value;

  static void clear() => _memory.clear();
}
