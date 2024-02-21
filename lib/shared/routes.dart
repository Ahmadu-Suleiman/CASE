import 'package:case_be_heard/pages/case_pages/case_page.dart';
import 'package:case_be_heard/pages/case_pages/case_play_video.dart';
import 'package:case_be_heard/pages/case_pages/case_view_photo.dart';
import 'package:case_be_heard/pages/case_pages/create_case.dart';
import 'package:case_be_heard/pages/case_pages/edit_case.dart';
import 'package:case_be_heard/pages/case_pages/next_steps.dart';
import 'package:case_be_heard/pages/community/create_community.dart';
import 'package:case_be_heard/pages/drawer_pages.dart/bookmark_page.dart';
import 'package:case_be_heard/pages/drawer_pages.dart/case_catalog.dart';
import 'package:case_be_heard/pages/drawer_pages.dart/communities_page.dart';
import 'package:case_be_heard/pages/drawer_pages.dart/petitions_page.dart';
import 'package:case_be_heard/pages/feedback/case_reads.dart';
import 'package:case_be_heard/pages/feedback/case_views.dart';
import 'package:case_be_heard/pages/feedback/signatories_page.dart';
import 'package:case_be_heard/pages/petition/create_petition.dart';
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
  static const String signatories = '/signatories-page';
  static const String bookmarks = '/bookmarks';
  static const String createPetition = '/create-petition';
  static const String petitionPage = '/petition-page';
  static const String caseCatalog = '/case-catalog';
  static const String communitiesPage = '/communities-page';
  static const String createCommunity = '/create-community';

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
        path: '$editCase/:caseId',
        builder: (context, state) {
          final caseId = state.pathParameters['caseId'];
          return EditCase(caseId: caseId!);
        }),
    GoRoute(
        name: 'casePage',
        path: '$casePage/:caseId',
        builder: (context, state) {
          final caseId = state.pathParameters['caseId'];
          return CasePage(caseId: caseId!);
        }),
    GoRoute(
        name: 'memberProfile',
        path: '$memberProfile/:memberId',
        builder: (context, state) {
          final memberId = state.pathParameters['memberId'];
          return Profile(memberId: memberId!);
        }),
    GoRoute(
        name: 'memberProfileOthers',
        path: '$memberProfileOthers/:memberId',
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
        path: '$casePhoto/:photoUrl',
        builder: (context, state) {
          final photoUrl = state.pathParameters['photoUrl'];
          return CasePhotoViewer(photoUrl: photoUrl!);
        }),
    GoRoute(
        name: 'caseVideo',
        path: '$caseVideo/:videoUrl',
        builder: (context, state) {
          final videoUrl = state.pathParameters['videoUrl'];
          return CaseVideoPlayer(videoUrl: videoUrl!);
        }),
    GoRoute(
        name: 'nextSteps',
        path: '$nextSteps/:steps',
        builder: (context, state) {
          final steps = state.pathParameters['steps'];
          return NextSteps(nextSteps: steps!);
        }),
    GoRoute(
        name: 'caseViews',
        path: '$caseViews/:caseId',
        builder: (context, state) {
          final caseId = state.pathParameters['caseId'];
          return CaseViewsWidget(caseRecordId: caseId!);
        }),
    GoRoute(
        name: 'caseReads',
        path: '$caseReads/:caseId',
        builder: (context, state) {
          final caseId = state.pathParameters['caseId'];
          return CaseReadsWidget(caseRecordId: caseId!);
        }),
    GoRoute(
        name: 'signatoriesPage',
        path: '$signatories/:petitionId',
        builder: (context, state) {
          final petitionId = state.pathParameters['petitionId'];
          return SignatoriesWidget(petitionId: petitionId!);
        }),
    GoRoute(
        name: 'bookmarks',
        path: Routes.bookmarks,
        builder: (context, state) => const BookmarkWidget()),
    GoRoute(
        name: 'createPetition',
        path: Routes.createPetition,
        builder: (context, state) => const CreatePetitionWidget()),
    GoRoute(
        name: 'petitionPage',
        path: Routes.petitionPage,
        builder: (context, state) => const PetitionsPageWidget()),
    GoRoute(
        name: 'caseCatalog',
        path: Routes.caseCatalog,
        builder: (context, state) => const CaseCatalog()),
    GoRoute(
        name: 'createCommunity',
        path: Routes.createCommunity,
        builder: (context, state) => const CreateCommunityWidget()),
    GoRoute(
        name: communitiesPage,
        path: '/communitiesPage/:state/:countryISO',
        builder: (context, state) {
          String communityState = state.pathParameters['state']!;
          String countryISO = state.pathParameters['countryISO']!;
          return CommunitiesPageWidget(
              state: communityState, countryISO: countryISO);
        })
  ]);
}
