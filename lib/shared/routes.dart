import 'package:case_be_heard/pages/case_pages/case_page.dart';
import 'package:case_be_heard/pages/case_pages/case_play_video.dart';
import 'package:case_be_heard/pages/case_pages/case_view_photo.dart';
import 'package:case_be_heard/pages/case_pages/create_case.dart';
import 'package:case_be_heard/pages/case_pages/edit_case.dart';
import 'package:case_be_heard/pages/case_pages/next_steps_case.dart';
import 'package:case_be_heard/pages/drawer_pages.dart/bookmark_page.dart';
import 'package:case_be_heard/pages/feedback/case_reads.dart';
import 'package:case_be_heard/pages/feedback/case_views.dart';
import 'package:case_be_heard/pages/profile/edit_member_profile.dart';
import 'package:case_be_heard/pages/profile/member_profile.dart';
import 'package:case_be_heard/pages/profile/member_profile_others.dart';
import 'package:case_be_heard/pages/profile/profile_image.dart';
import 'package:case_be_heard/pages/wrapper.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const String wrapper = '/wrapper';
  static const String createCase = '/create-case';
  static const String editCase = '/edit-case';
  static const String casePage = '/case-page';
  static const String memberProfile = '/member-profile';
  static const String memberProfileOthers = '/member-profile-others';
  static const String editMemberProfile = '/edit-member-profile';
  static const String profileImage = '/profile-image';
  static const String casePhoto = '/case-photo';
  static const String caseVideo = '/case-video';
  static const String nextSteps = '/next-steps';
  static const String caseViews = '/case-views';
  static const String caseReads = '/case-reads';
  static const String bookmarks = '/bookmarks';

  static final router = GoRouter(initialLocation: Routes.wrapper, routes: [
    GoRoute(
        name: 'wrapper',
        path: Routes.wrapper,
        builder: (context, state) => const Wrapper()),
    GoRoute(
        name: 'createCase',
        path: Routes.createCase,
        builder: (context, state) => const CreateCase()),
    GoRoute(
        name: 'editCase',
        path: '${Routes.editCase}/:caseId',
        builder: (context, state) {
          final caseId = state.pathParameters['caseId'];
          return EditCase(caseId: caseId!);
        }),
    GoRoute(
        name: 'casePage',
        path: '${Routes.casePage}/:caseId',
        builder: (context, state) {
          final caseId = state.pathParameters['caseId'];
          return CasePage(caseId: caseId!);
        }),
    GoRoute(
      name: 'memberProfile',
      path: Routes.memberProfile,
      builder: (context, state) => const Profile(),
    ),
    GoRoute(
        name: 'memberProfileOthers',
        path: '${Routes.memberProfileOthers}/:memberId',
        builder: (context, state) {
          final memberId = state.pathParameters['memberId'];
          return ProfileOthers(memberId: memberId!);
        }),
    GoRoute(
      name: 'editMemberProfile',
      path: Routes.editMemberProfile,
      builder: (context, state) => const EditProfile(),
    ),
    GoRoute(
      name: 'profileImage',
      path: Routes.profileImage,
      builder: (context, state) => const ProfileImage(),
    ),
    GoRoute(
        name: 'casePhoto',
        path: '${Routes.casePhoto}/:photoUrl',
        builder: (context, state) {
          final photoUrl = state.pathParameters['photoUrl'];
          return CasePhotoViewer(photoUrl: photoUrl!);
        }),
    GoRoute(
        name: 'caseVideo',
        path: '${Routes.caseVideo}/:videoUrl',
        builder: (context, state) {
          final videoUrl = state.pathParameters['videoUrl'];
          return CaseVideoPlayer(videoUrl: videoUrl!);
        }),
    GoRoute(
        name: 'nextSteps',
        path: '${Routes.nextSteps}/:steps',
        builder: (context, state) {
          final steps = state.pathParameters['steps'];
          return NextSteps(nextSteps: steps!);
        }),
    GoRoute(
        name: 'caseViews',
        path: '${Routes.caseViews}/:caseId',
        builder: (context, state) {
          final caseId = state.pathParameters['caseId'];
          return CaseViewsWidget(caseRecordId: caseId!);
        }),
    GoRoute(
        name: 'caseReads',
        path: '${Routes.caseReads}/:caseId',
        builder: (context, state) {
          final caseId = state.pathParameters['caseId'];
          return CaseReadsWidget(caseRecordId: caseId!);
        }),
    GoRoute(
        name: 'bookmarks',
        path: Routes.bookmarks,
        builder: (context, state) => const BookmarkWidget())
  ]);
}
