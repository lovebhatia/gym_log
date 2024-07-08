import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimerButton extends StatefulWidget {
  final Function(dynamic data)? onPressed;

  TimerButton({Key? key, this.onPressed}) : super(key: key);

  @override
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // Set the initial timer duration
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ElevatedButton(
        onPressed: () {
          _startTimer();
          if (widget.onPressed != null) {
            // Execute the callback function and pass data if provided
            widget.onPressed!("Your data here");
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: Size(MediaQuery.of(context).size.width * 0.40, 50.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: TimerButtonChild(),
      ),
    );
  }

  void _startTimer() {
    if (!_controller.isAnimating) {
      _controller.reset();
      _controller.forward();
    }
  }

  Widget TimerButtonChild() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_controller.isAnimating) {
          return Text(
            "Start in | ${_controller.duration!.inSeconds - _controller.value.toInt()}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          );
        } else {
          return Text(
            "Click When Done",
            style: TextStyle(
              color: Colors.black,
              fontSize: 21.sp,
              fontWeight: FontWeight.w700,
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
