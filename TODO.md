# TODO - Home Features Architecture (Clean Architecture + BLoC)

- [ ] Create required folder architecture under `lib/features/home/` for roles: admin/student/semsar/sanaiee
- [x] Implement `BaseHomeScreen` at `lib/features/home/presentation/views/base_home_screen.dart` (Scaffold/AppBar/Drawer as specified)

- [ ] Implement Admin Clean Architecture:
  - [ ] Models: admin user, sanaiee, report
  - [ ] Data sources (remote via Dio/ApiHelper)
  - [ ] Repositories returning `Either<String, ...>`
  - [ ] Cubits + states for users/sanaiee/reports
  - [ ] Presentation: AdminHome with tabs + Users/Sanaiee/Reports UI
  - [ ] Custom UI widgets: gradient header, search field, users table, grid cards
- [ ] Update `lib/features/home/home_screens.dart` to wire new role screens
- [ ] Ensure all new widgets/screens use `AppColors.scaffoldBackground`
- [ ] Run `flutter analyze` and `flutter test`

