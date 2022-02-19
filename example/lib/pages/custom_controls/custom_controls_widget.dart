import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class CustomControlsWidget extends StatefulWidget {
  final BetterPlayerController? controller;
  final Function(bool visbility)? onControlsVisibilityChanged;

  const CustomControlsWidget({
    Key? key,
    this.controller,
    this.onControlsVisibilityChanged,
  }) : super(key: key);

  @override
  _CustomControlsWidgetState createState() => _CustomControlsWidgetState();
}

class _CustomControlsWidgetState extends State<CustomControlsWidget> {
  late ChromeCastController chromeCastController;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      widget.controller!.isFullScreen
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                onTap: () => setState(() {
                  if (widget.controller!.isFullScreen)
                    widget.controller!.exitFullScreen();
                  else
                    widget.controller!.enterFullScreen();
                }),
              ),
            ),
          ),
          Container(
            height: widget.controller!.betterPlayerConfiguration
                .controlsConfiguration.controlBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    ChromeCastButton(
                      onButtonCreated: (controller) {
                        print("ON button created!");
                        chromeCastController = controller;
                      },
                    ),
                    BetterPlayerMaterialClickableWidget(
                      onTap: () {
                        print("CLICKED ON CAST");
                        widget.controller?.onCastClicked();
                        chromeCastController.click();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.cast,
                          color: widget.controller!.betterPlayerConfiguration
                              .controlsConfiguration.iconsColor,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () async {
                          Duration? videoDuration = await widget
                              .controller!.videoPlayerController!.position;
                          setState(() {
                            if (widget.controller!.isPlaying()!) {
                              Duration rewindDuration = Duration(
                                  seconds: (videoDuration!.inSeconds - 2));
                              if (rewindDuration <
                                  widget.controller!.videoPlayerController!
                                      .value.duration!) {
                                widget.controller!.seekTo(Duration(seconds: 0));
                              } else {
                                widget.controller!.seekTo(rewindDuration);
                              }
                            }
                          });
                        },
                        child: Icon(
                          Icons.fast_rewind,
                          color: Colors.white,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (widget.controller!.isPlaying()!)
                              widget.controller!.pause();
                            else
                              widget.controller!.play();
                          });
                        },
                        child: Icon(
                          widget.controller!.isPlaying()!
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Duration? videoDuration = await widget
                              .controller!.videoPlayerController!.position;
                          setState(() {
                            if (widget.controller!.isPlaying()!) {
                              Duration forwardDuration = Duration(
                                  seconds: (videoDuration!.inSeconds + 2));
                              if (forwardDuration >
                                  widget.controller!.videoPlayerController!
                                      .value.duration!) {
                                widget.controller!.seekTo(Duration(seconds: 0));
                                widget.controller!.pause();
                              } else {
                                widget.controller!.seekTo(forwardDuration);
                              }
                            }
                          });
                        },
                        child: Icon(
                          Icons.fast_forward,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BetterPlayerMaterialClickableWidget extends StatelessWidget {
  final Widget child;
  final void Function() onTap;

  const BetterPlayerMaterialClickableWidget({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
      ),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
