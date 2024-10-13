import 'package:cuberto_bottom_bar/internal/internal.dart';
import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:hackathon2024_pizamka/info.dart';
import 'package:provider/provider.dart';
import 'package:getwidget/getwidget.dart';
import 'appbars/home_appbar.dart';
import 'drawer.dart';
import 'event_design_page.dart';
import 'homehome_page.dart';
import 'nowy_search.dart';
import 'themes/dark_mode.dart';
import 'themes/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  String _currentTitle = "Wyszukaj harmonogramu";
  Color _currentColor = Colors.blue;
  final Color _inactiveColor = Colors.grey;
  final List<String> _titles = [
    "Wyszukaj odpad",
    "Wyszukaj harmonogramu",
    "Informacje"
  ];
  final List<Widget> _pages = [
    SearchPageNew(),
    HomeHomePage(),
    EventListPage()
  ];
  final List<Widget> _appbars = [
    HomeAppBar(),
    HomeAppBar(),
    HomeAppBar(),
  ];
  void _onTabTapped(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  final List<TabData> tabs = [
    TabData(
      key: Key("Home"),
      iconData: Icons.home,
      title: "Home",
      tabColor: Colors.blue,
      tabGradient: LinearGradient(
        colors: [Colors.blue, Colors.blueAccent],
      ),
    ),
    TabData(
      key: Key("Search"),
      iconData: Icons.search,
      title: "Search",
      tabColor: Colors.green,
      tabGradient: LinearGradient(
        colors: [Colors.green, Colors.greenAccent],
      ),
    ),
    TabData(
      key: Key("Settings"),
      iconData: Icons.settings,
      title: "Settings",
      tabColor: Colors.orange,
      tabGradient: LinearGradient(
        colors: [Colors.orange, Colors.deepOrangeAccent],
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_titles[_currentPage]),
        scrolledUnderElevation: 4,
        shadowColor: Theme.of(context).colorScheme.shadow,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Provider.of<ThemeProvider>(context).themeData == darkMode
                    ? Icons.nights_stay
                    : Icons.wb_sunny,
                size: 30,
                color: Provider.of<ThemeProvider>(context).themeData == darkMode
                    ? Colors.white
                    : Colors.black,
              ),
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ),
        ],
      ),
      //drawer: AppDrawer(),
      body: _pages[_currentPage],
      bottomNavigationBar: DotCurvedBottomNav(
        hideOnScroll: false,
        indicatorColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.black,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.ease,
        selectedIndex: _currentPage,
        indicatorSize: 6,
        borderRadius: 25,
        height: 65,
        onTap: (index) {
          setState(() => _currentPage = index);
        },
        items: [
          Icon(
            Icons.search,
            color: _currentPage == 0
                ? Theme.of(context).colorScheme.primary
                : Colors.white,
          ),
          Icon(
            Icons.home,
            color: _currentPage == 1
                ? Theme.of(context).colorScheme.primary
                : Colors.white,
          ),
          Icon(
            Icons.info,
            color: _currentPage == 2
                ? Theme.of(context).colorScheme.primary
                : Colors.white,
          ),
        ],
      ),
    );
  }
}

class TabData {
  final Key key;
  final IconData iconData;
  final String title;
  final Color tabColor;
  final LinearGradient tabGradient;

  TabData({
    required this.key,
    required this.iconData,
    required this.title,
    required this.tabColor,
    required this.tabGradient,
  });
}


///! Tu masz plik z malachapp jak to robiles tam

/*
import 'package:getwidget/getwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:malachapp/auth/auth_service.dart';
import 'package:malachapp/components/MyText1.dart';
import 'package:malachapp/components/MyText2.dart';
import 'package:malachapp/pages/Home/post_creator.dart';
import 'package:malachapp/services/nickname_fetcher.dart';
import 'package:malachapp/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:malachapp/pages/Home/post.dart';

class HomeHomeWidget extends StatefulWidget {
  const HomeHomeWidget({super.key});

  @override
  State<HomeHomeWidget> createState() => _HomeHomeWidgetState();
}

class _HomeHomeWidgetState extends State<HomeHomeWidget> {
  List<String> items = ["", '',];
  int current = 0;
  PageController pageController = PageController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  Widget _buildPostTile(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.currentThemeKey == 'dark';

    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('posts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        var data = snapshot.data!.docs;
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return buildPostCard(context, index, data, isDarkMode);
          },
        );
      }
    );
  }

  Widget buildPostCard(BuildContext context, int index, List<DocumentSnapshot> data, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Post3(snapshot: data[index]),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
        borderOnForeground: true,
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Ink.image(
              image: data[index]['mainImageUrl'] != '' ? CachedNetworkImageProvider(data[index]['mainImageUrl']) : const CachedNetworkImageProvider('https://firebasestorage.googleapis.com/v0/b/malachapp.appspot.com/o/favicon.png?alt=media&token=5b974a23-3b18-4a6d-a41b-4a9e78dd91b0'),
              height: 100,
              fit: BoxFit.cover,
              colorFilter: isDarkMode
                  ? ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken)
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MyText1(text: data[index]['title'].toString(), rozmiar: 40),
                ],
              ),
            ),
            Divider(
              color: isDarkMode ? Colors.white : Colors.black,
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
              child: MyText2(text: data[index]['description'].toString(), rozmiar: 18),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);

    final color = themeProvider.currentThemeKey == 'light'
        ? const Color.fromARGB(255, 133, 196, 255)
        : Colors.blueGrey;

    return Scaffold(
      body: SingleChildScrollView( // Added to enable scrolling
        child: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: Column(
            children: [
              SizedBox(
                width: screenWidth,
                height: screenHeight - 140, // Consider adjusting this value
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    double itemHeight = index == 0 ? 120 : 300;

                    if (index == 0) {
                      // First element, the carousel
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SingleChildScrollView(
                          child: GFCarousel(
                            items: _buildCarouselItems(screenWidth, color),
                            pauseAutoPlayOnTouch: const Duration(seconds: 1),
                            height: itemHeight,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.9,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 8),
                            autoPlayAnimationDuration: const Duration(seconds: 1),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeMainPage: true,
                            hasPagination: true,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      );
                    } else {
                      // Other elements, the post tiles
                      return SizedBox(
                        height: screenHeight - 255,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: _buildPostTile(context),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FutureBuilder(
        future: AuthService().isAdmin(),
        builder: (context, futureSnapshot) {
          return Visibility(
            visible: futureSnapshot.hasData && futureSnapshot.data == true,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PostCreator(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        }
      ),
    );
  }

  List<Widget> _buildCarouselItems(double screenWidth, Color color) {
    return [
      SizedBox(
        width: screenWidth,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(10))),
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: SizedBox(
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const MyText2(
                    text:
                        "Dołącz do naszej szkolnej społeczności!",
                    rozmiar: 16,
                  ),
                  Row(
                    children: [
                      const MyText1(
                        text: "Witaj ",
                        rozmiar: 33,
                      ),
                      NicknameFetcher().buildNickname(context, userId),
                      Text(
                        "!",
                        style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              fontFamily: 'Nunito',
                              fontStyle: FontStyle.normal,
                              fontSize: 26,
                              fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        width: screenWidth,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(10))),
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                //! tutaj wyjatakowo damy inny styl tekstu i nie damy komponentu
                "... krew człowieka wykonuje pełny obieg w układzie krążenia w ciągu około minuty",
                style: GoogleFonts.merriweather(
                    fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        width: screenWidth,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(10))),
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                //! tutaj wyjatakowo damy inny styl tekstu i nie damy komponentu
                "... krew człowieka wykonuje pełny obieg w układzie krążenia w ciągu około minuty",
                style: GoogleFonts.merriweather(
                    fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        width: screenWidth,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(10))),
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                //! tutaj wyjatakowo damy inny styl tekstu i nie damy komponentu
                "... krew człowieka wykonuje pełny obieg w układzie krążenia w ciągu około minuty",
                style: GoogleFonts.merriweather(
                    fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
      ),
    ];
  }
}

*/