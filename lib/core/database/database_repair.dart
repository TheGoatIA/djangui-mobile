import "dart:io";

import "package:sqlite3/sqlite3.dart";

/// Résultat de [repairUnreadableDatabase].
enum DatabaseRepairOutcome {
  /// Aucun fichier : la base sera créée normalement.
  absent,

  /// La base se lit déjà avec la clé : rien à faire.
  readable,

  /// Base non chiffrée (ancienne version) chiffrée sur place, sans perte.
  encrypted,

  /// Base illisible (autre clé, autre format) supprimée puis recréée vide.
  rebuilt,
}

/// Journalisation des réparations (branchée sur LogService par l'app).
typedef DatabaseRepairLog = void Function(String message);

/// Vrai si la base [file] s'ouvre et se lit, avec [key] (ou en clair si null).
bool canReadDatabase(final File file, final String? key) {
  Database? db;
  try {
    db = sqlite3.open(file.path);
    if (key != null) {
      db.execute("PRAGMA key = '$key';");
    }
    db.select("SELECT count(*) FROM sqlite_master;");
    return true;
  } on Object {
    return false;
  } finally {
    db?.close();
  }
}

/// Supprime la base [file] et ses fichiers annexes (-wal, -shm, -journal).
Future<void> deleteDatabaseFiles(final File file) async {
  for (String path in <String>[
    file.path,
    "${file.path}-wal",
    "${file.path}-shm",
    "${file.path}-journal",
  ]) {
    File part = File(path);
    if (part.existsSync()) {
      await part.delete();
    }
  }
}

/// Répare une base locale illisible avec la clé [key].
///
/// Cas constaté sur iPhone : « file is not a database » (code 26). La session
/// ne pouvait plus être enregistrée et toute connexion échouait. Ici :
/// 1. base non chiffrée → chiffrée sur place (`PRAGMA rekey`), sans perte ;
/// 2. sinon → supprimée : simple cache resynchronisé depuis le serveur (les
///    jetons de session sont dans le stockage sécurisé, pas dans la base).
Future<DatabaseRepairOutcome> repairUnreadableDatabase(
  final File file,
  final String key, {
  final DatabaseRepairLog? log,
}) async {
  if (!file.existsSync()) {
    return DatabaseRepairOutcome.absent;
  }
  if (canReadDatabase(file, key)) {
    return DatabaseRepairOutcome.readable;
  }
  if (canReadDatabase(file, null) && _encryptInPlace(file, key)) {
    log?.call("Base locale non chiffrée : chiffrée sur place.");
    return DatabaseRepairOutcome.encrypted;
  }
  await deleteDatabaseFiles(file);
  log?.call("Base locale illisible (clé ou format différent) : reconstruite.");
  return DatabaseRepairOutcome.rebuilt;
}

/// Chiffre sur place une base en clair ; vrai si elle se lit ensuite avec [key].
bool _encryptInPlace(final File file, final String key) {
  Database? db;
  try {
    db = sqlite3.open(file.path);
    db.execute("PRAGMA rekey = '$key';");
  } on Object {
    return false;
  } finally {
    db?.close();
  }
  return canReadDatabase(file, key);
}
