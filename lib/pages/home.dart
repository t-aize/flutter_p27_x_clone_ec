import 'package:flutter/material.dart';
import 'package:x_clone_ec/models/tweet.dart';
import 'package:x_clone_ec/pages/quote_screen.dart';
import 'package:x_clone_ec/pages/settings_page.dart';
import 'package:x_clone_ec/persistence/settings_persistence.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _settingsPersistence = SettingsPersistence();
  String _username = '';
  String _profileImage = 'assets/avatars/marie.jpg';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _settingsPersistence.loadSettings();
    if (!mounted) return;
    setState(() {
      _username = settings['username'] ?? '';
      final image = settings['backgroundImage'] ?? '';
      if (image.isNotEmpty) _profileImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Tooltip(
            message: _username.isEmpty ? 'Profil' : _username,
            child: Center(
              child: CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage(_profileImage),
              ),
            ),
          ),
          title: Image.asset('assets/x-logo.png', height: 32),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Paramètres',
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              ),
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            dividerColor: Colors.grey,
            dividerHeight: 0.5,
            tabs: [
              Tab(text: 'Pour vous'),
              Tab(text: 'Abonnements'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: Tweet.sampleTweets.length,
              itemBuilder: (context, index) =>
                  _Post(tweet: Tweet.sampleTweets[index]),
            ),
            const Center(child: Text('Abonnements')),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuoteScreen()),
              );
            }
          },
          showUnselectedLabels: MediaQuery.sizeOf(context).width >= 600,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Recherche',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Communauté',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Messages'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Créer un tweet',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _Post extends StatelessWidget {
  const _Post({required this.tweet});

  final Tweet tweet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xff333333))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(tweet.profilePictureUrl),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                tweet.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (tweet.verified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 15,
                              ),
                            ],
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 7),
                                child: Text(
                                  '${tweet.handle} • ${tweet.time}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xff999999),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.more_horiz, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tweet.content,
                  style: const TextStyle(fontSize: 16, height: 1.35),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _PostMetric(icon: Icons.comment, value: tweet.comments),
                      _PostMetric(icon: Icons.repeat, value: tweet.retweets),
                      _PostMetric(
                        icon: Icons.favorite_border,
                        value: tweet.likes,
                      ),
                      _PostMetric(icon: Icons.visibility, value: tweet.views),
                      const Icon(
                        Icons.upload_outlined,
                        size: 17,
                        color: Color(0xff999999),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostMetric extends StatelessWidget {
  const _PostMetric({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: const Color(0xff999999)),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(color: Color(0xff999999))),
      ],
    );
  }
}
