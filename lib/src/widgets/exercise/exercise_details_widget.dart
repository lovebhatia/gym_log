import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constant.dart';
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

class _ExerciseDetailsWidgetState extends State<ExerciseDetailsWidget>
    with TickerProviderStateMixin {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isVideoLoaded = false;
  bool _isError = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _loadCachedVideo();
  }

  Future<void> _loadCachedVideo() async {
    try {
      final fileInfo = await DefaultCacheManager().getSingleFile(
        '${AppConst.videoBaseUrl}${widget.selectedWorkout.toLowerCase()}/${widget.exerciseName.toLowerCase().replaceAll(' ', '_')}.mp4',
      );
      _controller = VideoPlayerController.file(fileInfo);
      _initializeVideoPlayerFuture = _controller.initialize().then((_) {
        setState(() {
          _isVideoLoaded = true;
        });
        _animationController.forward();
        _controller.play();
        _controller.setLooping(true);
      });
    } catch (error) {
      setState(() {
        _isError = true;
      });
    }
  }

  @override
  void dispose() {
    if (_isVideoLoaded) {
      _controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildVideoPlayer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: VideoPlayer(_controller),
      ),
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: CachedNetworkImage(
          imageUrl:
              '${AppConst.imageBaseUrl}${widget.selectedWorkout.toLowerCase()}/${widget.exerciseName.toLowerCase().replaceAll(' ', '_')}.jpg',
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        ),
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
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: _isVideoLoaded && !_isError
                          ? FadeTransition(
                              opacity: _animationController,
                              child: _buildVideoPlayer(),
                            )
                          : _buildThumbnail(),
                    ),
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



