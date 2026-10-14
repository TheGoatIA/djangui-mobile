# Contribuer à Kauri (mobile)

Nous apprécions votre aide ! Voici comment contribuer efficacement.

## 📝 Code de conduite

Restez respectueux et professionnel dans toutes vos interactions.

## 🌿 Branches

| Branche | Rôle | Build |
| :-- | :-- | :-- |
| `dev` | Intégration | CI GitHub (qualité, tests, compilation Android API 36, sécurité, Sonar) |
| `main` | Production | Codemagic (release signée) |

Créez vos branches depuis `dev` et ouvrez la PR vers `dev`.

## 🚀 Processus

1. **Bug** : ouvrez une issue (étapes, logs, version de l'app).
2. **Fonctionnalité** : discutez-en d'abord dans une issue.
3. **Pull Request** — avant de pousser :
   ```bash
   flutter pub get
   dart format lib test
   flutter analyze
   flutter test --coverage
   bash tool/check_coverage.sh
   node tool/check_android_plugin_sdk.js 36
   ```
4. Ajoutez des tests pour tout code testable (sécurité, parsing, mapping d'erreurs, widgets critiques).
5. Mettez à jour la documentation (README, DEPLOYMENT, SECURITY_CHECKLIST) si le comportement change.

## 🎨 Style

- [Effective Dart](https://dart.dev/guides/language/effective-dart/style), widgets petits et ciblés.
- Aucun secret dans le dépôt (gitleaks bloque la CI) ; configuration via `--dart-define-from-file`.
- Aucune donnée sensible dans les logs ; erreurs affichées via `error_mapper`.
- Dépendances : ne montez pas un plugin au-delà de `compileSdk 36` (garde-fou CI) ; gardez les plugins FlutterFire alignés.
- Après un changement de modèle/DI/l10n : `flutter gen-l10n` puis `dart run build_runner build --delete-conflicting-outputs`.

## 📜 Commits

[Conventional Commits](https://www.conventionalcommits.org/) : `feat:`, `fix:`, `chore(deps):`, `docs:`, `test:` — première ligne ≤ 72 caractères, à l'impératif.

## ❓ Questions

Ouvrez une issue ou écrivez à support@kauri-app.com.

## ⚖️ Licence

Vos contributions sont sous licence [MIT](LICENSE).
