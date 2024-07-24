import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_constant.dart';
import '../../screens/reps/reps_record_screen.dart';

class ExerciseDetailsWidget extends StatefulWidget {
  final String videoUrl;
  final String exerciseName;
  final String sets;
  final String description;
  final String selectedWorkout;

  const ExerciseDetailsWidget({
    Key? key,
    required this.videoUrl,
    required this.exerciseName,
    required this.sets,
    required this.description,
    required this.selectedWorkout,
  }) : super(key: key);

  @override
  _ExerciseDetailsWidgetState createState() => _ExerciseDetailsWidgetState();
}

class _ExerciseDetailsWidgetState extends State<ExerciseDetailsWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isVideoLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadCachedVideo();
  }

  Future<void> _loadCachedVideo() async {
    final fileInfo = await DefaultCacheManager().getSingleFile(
      '${AppConst.videoBaseUrl}${widget.selectedWorkout}/${widget.exerciseName.replaceAll(' ', '')}.mp4',
    );
    _controller = VideoPlayerController.file(fileInfo);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {
        _isVideoLoaded = true;
      });
      _controller.play();
      _controller.setLooping(true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildVideoPlayer() {
    return FutureBuilder<void>(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: 3 / 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: VideoPlayer(_controller),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: CachedNetworkImage(
        imageUrl:
            '${AppConst.ChestGifBaseUrl}${widget.selectedWorkout.toLowerCase()}/thumbnails/${widget.videoUrl}.jpg',
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 500.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.BLACK, AppColors.LIGHT_BLACK],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.w),
                  child: Container(
                    padding: const EdgeInsets.only(top: 5),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width *
                        (2 / 3), // 3:2 aspect ratio
                    child: _isVideoLoaded
                        ? _buildVideoPlayer()
                        : _buildThumbnail(),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: RepsRecordScreen(
                    exerciseName: widget.exerciseName,
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
