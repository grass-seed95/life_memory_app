import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/photos/views/photos_home_page.dart';
import 'features/photos/views/photo_detail_page.dart';
import 'features/photos/views/album_list_page.dart';
import 'features/photos/views/album_detail_page.dart';
import 'features/photos/views/photo_search_page.dart';
import 'features/calendar/views/calendar_home_page.dart';
import 'features/calendar/views/event_form_page.dart';
import 'features/calendar/views/event_detail_page.dart';
import 'features/wardrobe/views/wardrobe_home_page.dart';
import 'features/wardrobe/views/add_item_page.dart';
import 'features/wardrobe/views/item_detail_page.dart';
import 'features/wardrobe/views/outfit_create_page.dart';
import 'features/wardrobe/views/outfit_history_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _photosNavigatorKey = GlobalKey<NavigatorState>();
final _calendarNavigatorKey = GlobalKey<NavigatorState>();
final _wardrobeNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/photos',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.photo_library), label: '照片'),
                NavigationDestination(
                    icon: Icon(Icons.calendar_month), label: '日历'),
                NavigationDestination(
                    icon: Icon(Icons.checkroom), label: '穿搭'),
              ],
            ),
          );
        },
        branches: [
          StatefulNavigationBranch(
            navigatorKey: _photosNavigatorKey,
            routes: [
              GoRoute(
                path: '/photos',
                builder: (context, state) => const PhotosHomePage(),
                routes: [
                  GoRoute(
                    path: 'detail/:photoId',
                    builder: (context, state) => PhotoDetailPage(
                      photoId: int.parse(state.pathParameters['photoId']!),
                    ),
                  ),
                  GoRoute(
                    path: 'albums',
                    builder: (context, state) => const AlbumListPage(),
                    routes: [
                      GoRoute(
                        path: ':albumId',
                        builder: (context, state) => AlbumDetailPage(
                          albumId:
                              int.parse(state.pathParameters['albumId']!),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'search',
                    builder: (context, state) => const PhotoSearchPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulNavigationBranch(
            navigatorKey: _calendarNavigatorKey,
            routes: [
              GoRoute(
                path: '/calendar',
                builder: (context, state) => const CalendarHomePage(),
                routes: [
                  GoRoute(
                    path: 'event/new',
                    builder: (context, state) => const EventFormPage(),
                  ),
                  GoRoute(
                    path: 'event/:eventId',
                    builder: (context, state) => EventDetailPage(
                      eventId: int.parse(state.pathParameters['eventId']!),
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) => EventFormPage(
                          eventId:
                              int.parse(state.pathParameters['eventId']!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulNavigationBranch(
            navigatorKey: _wardrobeNavigatorKey,
            routes: [
              GoRoute(
                path: '/wardrobe',
                builder: (context, state) => const WardrobeHomePage(),
                routes: [
                  GoRoute(
                    path: 'add-item',
                    builder: (context, state) => const AddItemPage(),
                  ),
                  GoRoute(
                    path: 'item/:itemId',
                    builder: (context, state) => ItemDetailPage(
                      itemId: int.parse(state.pathParameters['itemId']!),
                    ),
                  ),
                  GoRoute(
                    path: 'outfit/create',
                    builder: (context, state) => const OutfitCreatePage(),
                  ),
                  GoRoute(
                    path: 'outfit/history',
                    builder: (context, state) => const OutfitHistoryPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class LifeMemoryApp extends ConsumerWidget {
  const LifeMemoryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      title: '生活记忆管家',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
    );
  }
}
