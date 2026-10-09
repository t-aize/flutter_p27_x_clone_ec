# Clone X — Flutter SIO2-SLAM

Projet pédagogique basé sur le support de la promotion 2027.

- Login avec validation de l’email et mot de passe de 12 caractères minimum.
- Affichage/masquage du mot de passe, sauvegarde du formulaire et remplacement de la route vers Home.
- Thème sombre commun, logo X et photos d’avatar stockées localement.
- Modèle Tweet et données fictives accessibles via Tweet.sampleTweets.
- Onglets « Pour vous » et « Abonnements » synchronisés : liste de tweets dans le premier, texte provisoire dans le second, conformément au support.
- Barre de navigation à cinq icônes et bouton flottant de création de tweet, sans actions métier à ce stade.
- Page Paramètres accessible par la roue dentée de l’accueil : choix du fond (noir, gris foncé, bleu nuit ou violet foncé), appliqué à tous les écrans et sauvegardé avec `SharedPreferencesAsync` pour le prochain lancement.

## Exécution

```sh
flutter pub get
flutter run
```

## Vérification

```sh
flutter analyze
flutter test
```

L’authentification est simulée : les identifiants ne sont pas envoyés à un serveur. Le journal de débogage affiche l’email et uniquement la longueur du mot de passe.

Les photos de démonstration proviennent de [Pravatar](https://i.pravatar.cc/) (images 47, 12, 44 et 13). Elles sont incluses dans `assets/avatars/` pour fonctionner sans connexion réseau.

## Conformité au support promotion 2027

| Partie du support | Implémentation |
| --- | --- |
| Structure et packages | Point d’entrée `lib/main.dart`, écrans dans `lib/pages/`, modèles dans `lib/models/`, persistance dans `lib/persistence/`. Packages `http` et `shared_preferences` avec contraintes de version. |
| Assets et thème | Logo et avatars déclarés dans `pubspec.yaml`. Fond noir, couleurs primaire blanche et secondaire grise, texte courant de taille 16, thème commun pour les barres et les champs. |
| Login | `LoginPage` avec état, `Form`, clé `GlobalKey<FormState>`, titre 28 en gras, espacements 20/10, padding 20, bordures grises/bleues, bouton de visibilité et actions en bas. |
| Validation et navigation | Email obligatoire avec contrôle de forme, mot de passe obligatoire de 12 caractères minimum, `onSaved`, `validate`, `save` et `Navigator.pushReplacement` vers `Home`. |
| Accueil | Avatar, logo, deux onglets synchronisés, `ListView.builder`, modèle `Tweet` et `sampleTweets`, compteurs, séparateurs, cinq icônes et bouton flottant `add`. |
| Paramètres | Écriture et lecture asynchrones cohérentes avec `SharedPreferencesAsync`. L’email et le chemin de l’avatar sont sauvegardés puis relus à l’accueil. Le mot de passe n’est pas stocké. |
| API et JSON | `QuoteScreen`, requête HTTPS ZenQuotes, modèle `Quote.fromJSON`, `FutureBuilder`, chargement, erreur et nouvelle tentative. Délai maximal de 15 secondes par requête et permission Internet Android. |

Les exemples intermédiaires du cours (compteur initial, liste de 100 cartes, écran `Placeholder`, etc.) sont remplacés par leur version finale. Les exemples de polices, `provider` et `chucknorris` illustrent des notions et ne constituent pas des dépendances obligatoires du clone.

Différences utiles avec les exemples : `Home` est un `StatefulWidget` pour charger les paramètres ; la citation est accessible par l’icône Recherche ; le lien de récupération affiche un message provisoire. Le formulaire peut défiler sur un petit écran. Les valeurs de mot de passe ne sont pas affichées en clair dans la console.

Le support mélange `SharedPreferences` et `SharedPreferencesAsync` dans son exemple : ce projet utilise uniquement l’API asynchrone pour les deux opérations. `validate()` renvoie un booléen, tandis que chaque `validator` renvoie `null` ou un message d’erreur. La contrainte Dart 3 du projet correspond au SDK installé ; il ne faut pas recopier l’ancien exemple Dart 2 du support.

Plateformes présentes : Android, Web et Linux. Les dossiers iOS, macOS et Windows ne sont pas générés dans ce projet. Leur présence dépend des plateformes ciblées, et le code natif de ces plateformes n’a pas été validé.

Vérification du 9 octobre 2026 : `flutter analyze` sans problème, cinq tests automatisés réussis, `flutter doctor -v` sans problème (Flutter 3.47.5, Dart 3.13.4, outils Android et licences OK). Les tests de préférences utilisent le stockage en mémoire du package uniquement dans les tests ; une relance réelle de l’application reste nécessaire pour vérifier le stockage sur l’appareil. Les tests JSON n’appellent pas le service ZenQuotes réel. Les captures mentionnées dans le support n’étant pas fournies, l’identité visuelle exacte n’a pas pu être comparée.
