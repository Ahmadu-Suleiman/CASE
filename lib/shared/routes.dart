import 'package:case_be_heard/pages/case_pages/case_page.dart';
import 'package:case_be_heard/pages/case_pages/case_play_video.dart';
import 'package:case_be_heard/pages/case_pages/case_view_photo.dart';
import 'package:case_be_heard/pages/case_pages/create_case.dart';
import 'package:case_be_heard/pages/case_pages/edit_case.dart';
import 'package:case_be_heard/pages/profile/edit_member_profile.dart';
import 'package:case_be_heard/pages/profile/member_profile.dart';
import 'package:case_be_heard/pages/profile/profile_image.dart';
import 'package:case_be_heard/pages/wrapper.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const String wrapper = '/wrapper';
  static const String createCase = '/create-case';
  static const String editCase = '/edit-case';
  static const String casePage = '/case-page';
  static const String memberProfile = '/member-profile';
  static const String editMemberProfile = '/edit-member-profile';
  static const String profileImage = '/profile-image';
  static const String casePhoto = '/case-photo';
  static const String caseVideo = '/case-video';

  static final router = GoRouter(
    initialLocation: Routes.wrapper,
    routes: [
      GoRoute(
        name: 'wrapper',
        path: Routes.wrapper,
        builder: (context, state) => const Wrapper(),
      ),
      GoRoute(
        name: 'createCase',
        path: Routes.createCase,
        builder: (context, state) => const CreateCase(),
      ),
      GoRoute(
        name: 'editCase',
        path: '${Routes.editCase}/:caseId',
        builder: (context, state) {
          final caseId = state.pathParameters['caseId'];
          return EditCase(caseId: caseId!);
        },
      ),
      GoRoute(
        name: 'casePage',
        path: '${Routes.casePage}/:caseId',
        builder: (context, state) {
          final caseId = state.pathParameters['caseId'];
          return CasePage(
            caseId: caseId!,
          );
        },
      ),
      GoRoute(
        name: 'memberProfile',
        path: Routes.memberProfile,
        builder: (context, state) => const Profile(),
      ),
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
          return CasePhotoViewer(
            photoUrl: photoUrl!,
          );
        },
      ),
      GoRoute(
        name: 'caseVideo',
        path: '${Routes.caseVideo}/:videoUrl',
        builder: (context, state) {
          final videoUrl = state.pathParameters['videoUrl'];
          return CaseVideoPlayer(
            videoUrl: videoUrl!,
          );
        },
      ),
    ],
  );
}
