# Déploiement automatique sur FTP

Ce projet utilise GitHub Actions pour builder automatiquement l'application Flutter Web et la déployer sur un serveur FTP.

## Configuration des secrets GitHub

Pour que le déploiement fonctionne, vous devez configurer les secrets suivants dans votre repository GitHub :

### Étapes pour ajouter les secrets :

1. Allez dans **Settings** de votre repository GitHub
2. Cliquez sur **Secrets and variables** → **Actions**
3. Cliquez sur **New repository secret**
4. Ajoutez les secrets suivants :

| Secret | Description | Exemple |
|--------|-------------|---------|
| `FTP_URL` | URL ou IP de votre serveur FTP | `ftp.monserveur.com` ou `192.168.1.100` |
| `FTP_USERNAME` | Nom d'utilisateur FTP | `monuser` |
| `FTP_PASSWORD` | Mot de passe FTP | `monmotdepasse` |
| `FTP_BASE_FOLDER` | Dossier de destination sur le serveur | `public_html/volley` ou `www/apps/volley` |

## Déclenchement du déploiement

Le déploiement se lance automatiquement quand :

- ✅ Vous faites un `push` sur la branche `main` ou `master`
- ✅ Une Pull Request est créée vers `main` ou `master`
- ✅ Vous déclenchez manuellement le workflow depuis l'onglet "Actions" de GitHub

## Processus de déploiement

Le workflow fait les étapes suivantes :

1. **Checkout** du code source
2. **Installation** de Flutter (version stable)
3. **Installation** des dépendances (`flutter pub get`)
4. **Analyse** du code (`flutter analyze`)
5. **Tests** (`flutter test`)
6. **Build** pour le web (`flutter build web --release`)
7. **Upload** des fichiers via FTP vers le serveur

## Structure du déploiement

Les fichiers sont uploadés dans l'arborescence suivante sur votre serveur FTP :

```
{FTP_BASE_FOLDER}/
├── index.html          # Point d'entrée de l'app
├── main.dart.js        # Code Dart compilé en JavaScript
├── flutter.js          # Runtime Flutter Web
├── assets/             # Resources de l'app
├── canvaskit/          # Rendu graphique
└── build-info.txt      # Informations de build
```

## Monitoring

- Consultez l'onglet **Actions** de votre repository pour voir l'état des déploiements
- Les logs détaillés sont disponibles pour chaque étape
- En cas d'erreur, vérifiez la configuration de vos secrets FTP

## Accès à l'application

Une fois déployée, votre application sera accessible à :
```
http://votre-domaine.com/{FTP_BASE_FOLDER}/
```

## Dépannage

### Erreur FTP
- Vérifiez que les credentials FTP sont corrects
- Assurez-vous que le dossier de destination existe sur le serveur
- Vérifiez les permissions d'écriture sur le serveur FTP

### Erreur de build
- Consultez les logs du workflow dans l'onglet Actions
- Vérifiez que tous les tests passent en local
- Assurez-vous que `flutter analyze` ne remonte pas d'erreurs

### App inaccessible
- Vérifiez que le `base-href` est correctement configuré
- Contrôlez que les fichiers ont bien été uploadés sur le serveur
- Vérifiez la configuration de votre serveur web