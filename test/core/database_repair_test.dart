import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:kauri/core/database/database_repair.dart";
import "package:sqlite3/sqlite3.dart";

/// Réparation de la base locale chiffrée (constat iPhone : « file is not a
/// database » → aucune connexion possible). Tests sur de VRAIES bases SQLite.
void main() {
  late Directory dir;
  late File file;

  setUp(() {
    dir = Directory.systemTemp.createTempSync("kauri_db_");
    file = File("${dir.path}/db.sqlite");
  });

  tearDown(() {
    dir.deleteSync(recursive: true);
  });

  void createDatabase(final String? key) {
    Database db = sqlite3.open(file.path);
    if (key != null) {
      db.execute("PRAGMA key = '$key';");
    }
    db.execute("CREATE TABLE notes (texte TEXT);");
    db.execute("INSERT INTO notes VALUES ('conservée');");
    db.close();
  }

  String readNote(final String key) {
    Database db = sqlite3.open(file.path);
    db.execute("PRAGMA key = '$key';");
    String value =
        db.select("SELECT texte FROM notes;").first["texte"] as String;
    db.close();
    return value;
  }

  test("aucun fichier : rien à réparer", () async {
    expect(
      await repairUnreadableDatabase(file, "cle"),
      DatabaseRepairOutcome.absent,
    );
  });

  test("base lisible avec la clé : laissée intacte", () async {
    createDatabase("cle");
    expect(
      await repairUnreadableDatabase(file, "cle"),
      DatabaseRepairOutcome.readable,
    );
    expect(readNote("cle"), "conservée");
  });

  test("base en clair : chiffrée sur place sans perte", () async {
    createDatabase(null);
    List<String> logs = <String>[];
    expect(
      await repairUnreadableDatabase(file, "cle", log: logs.add),
      DatabaseRepairOutcome.encrypted,
    );
    expect(canReadDatabase(file, null), isFalse);
    expect(readNote("cle"), "conservée");
    expect(logs.single, contains("chiffrée sur place"));
  });

  test("base chiffrée avec une autre clé : reconstruite", () async {
    createDatabase("ancienne");
    File("${file.path}-journal").writeAsStringSync("x");
    List<String> logs = <String>[];
    expect(
      await repairUnreadableDatabase(file, "nouvelle", log: logs.add),
      DatabaseRepairOutcome.rebuilt,
    );
    expect(file.existsSync(), isFalse);
    expect(File("${file.path}-journal").existsSync(), isFalse);
    expect(logs.single, contains("reconstruite"));
  });

  test("fichier qui n'est pas une base : reconstruit", () async {
    file.writeAsStringSync("pas une base de données");
    expect(
      await repairUnreadableDatabase(file, "cle"),
      DatabaseRepairOutcome.rebuilt,
    );
    expect(file.existsSync(), isFalse);
  });
}
