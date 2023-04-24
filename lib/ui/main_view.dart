import 'package:flutter/material.dart';
import 'package:malango_pod/enums/lifecycle_state.dart';
import 'package:malango_pod/providers/player_provider/player_provider.dart';
import 'package:malango_pod/providers/ui/bottom_navigation_provider.dart';
import 'package:malango_pod/ui/main_pages/archives/archives.dart';
import 'package:malango_pod/ui/main_pages/home/home.dart';
import 'package:malango_pod/ui/mini_player/mini_player.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/buttom_navigation_item.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:provider/provider.dart';

/// [MainView] is main screen of the app that contains [Home] and [Archives]
class MainView extends StatefulWidget {
  const MainView({
    Key key,
  }) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with WidgetsBindingObserver {
  PlayerProvider soundProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    soundProvider = Provider.of<PlayerProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      soundProvider.setLifecycleState(LifecycleState.resume);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      soundProvider.setLifecycleState(LifecycleState.pause);
    });

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          soundProvider.setLifecycleState(LifecycleState.resume);
        });
        break;
      case AppLifecycleState.paused:
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          soundProvider.setLifecycleState(LifecycleState.pause);
        });
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Consumer<BottomNavigationProvider>(
                builder: (context, pagerProvider, child) {
              if (pagerProvider.bottomNavigationPage == 0) {
                return const Home();
              } else {
                return const Archives();
              }
            }),
          ),
          const MiniPlayer(),
        ],
      ),
      bottomNavigationBar: Consumer<BottomNavigationProvider>(
          builder: (context, pagerProvider, child) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: white,
          currentIndex: pagerProvider.bottomNavigationPage,
          onTap: pagerProvider.changeBottomNavigationPage,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: homeScreenText,
              activeIcon: BottomNavigationItem(
                  label: homeScreenText,
                  activated: true,
                  iconData: HomeIcon(
                    isFill: true,
                    color: brandMainColor,
                  )),
              icon: BottomNavigationItem(
                  label: homeScreenText,
                  activated: false,
                  iconData: HomeIcon(
                    isFill: false,
                    color: mainViewUnSelectedItemColor,
                  )),
            ),
            BottomNavigationBarItem(
              label: archivesScreenText,
              activeIcon: BottomNavigationItem(
                  label: archivesScreenText,
                  activated: true,
                  iconData: ArchivesIcon(
                    isFill: true,
                    color: brandMainColor,
                  )),
              icon: BottomNavigationItem(
                  label: archivesScreenText,
                  activated: false,
                  iconData: ArchivesIcon(
                    isFill: false,
                    color: mainViewUnSelectedItemColor,
                  )),
            )
          ],
        );
      }),
    );
  }
}
