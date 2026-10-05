class Env {
  static const String supabaseUrl = String.fromEnvironment(
    "SUPABASE_URL",
    defaultValue: "",
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    "SUPABASE_PUBLISHABLE_KEY",
    defaultValue: "",
  );
}

