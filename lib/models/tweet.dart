class Tweet {
  const Tweet({
    required this.name,
    required this.handle,
    required this.time,
    required this.content,
    required this.comments,
    required this.retweets,
    required this.likes,
    required this.views,
    required this.profilePictureUrl,
    this.verified = false,
  });

  final String name;
  final String handle;
  final String time;
  final String content;
  final String comments;
  final String retweets;
  final String likes;
  final String views;
  final String profilePictureUrl;
  final bool verified;

  static const List<Tweet> sampleTweets = [
    Tweet(
      name: 'Marie Dupont',
      handle: '@marie_dupont',
      time: '2 h',
      content: 'Je viens de tester une nouvelle recette de lasagnes aux épinards et ricotta. Un vrai délice, je recommande ! 🍝',
      comments: '42',
      retweets: '8',
      likes: '156',
      views: '3,2 k',
      profilePictureUrl: 'assets/avatars/marie.jpg',
    ),
    Tweet(
      name: 'Thomas Martin',
      handle: '@thomas_martin',
      time: '3 h',
      content: 'Ce matin, j’ai vu un hérisson traverser la route. Trop mignon, même si j’ai eu peur qu’il se fasse écraser.',
      comments: '67',
      retweets: '12',
      likes: '423',
      views: '8,9 k',
      verified: true,
      profilePictureUrl: 'assets/avatars/thomas.jpg',
    ),
    Tweet(
      name: 'Sophie Bernard',
      handle: '@sophie_bernard',
      time: '4 h',
      content: 'Quelqu’un a déjà essayé le yoga du rire ? J’hésite à m’inscrire à un cours cette semaine.',
      comments: '89',
      retweets: '5',
      likes: '201',
      views: '5,6 k',
      profilePictureUrl: 'assets/avatars/sophie.jpg',
    ),
    Tweet(
      name: 'Lucas Petit',
      handle: '@lucas_petit',
      time: '5 h',
      content: 'Je suis en train de lire « Les Misérables » pour la première fois. Je comprends maintenant pourquoi c’est un classique.',
      comments: '134',
      retweets: '23',
      likes: '512',
      views: '12,4 k',
      verified: true,
      profilePictureUrl: 'assets/avatars/lucas.jpg',
    ),
  ];
}
