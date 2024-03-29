import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tussle_zego_sdk_manager/internal/business/business_define.dart';

import '../../internal/business/pk/pk_user.dart';
import '../../zego_live_streaming_manager.dart';
import '../../zego_sdk_manager.dart';
import 'pk_mute_button.dart';

class PKView extends StatefulWidget {
  final PKUser pkUser;
  const PKView({super.key, required this.pkUser});

  @override
  State<PKView> createState() => _PKViewState();
}

class _PKViewState extends State<PKView> {
  List<StreamSubscription> subscriptions = [];

  @override
  void initState() {
    super.initState();
    subscriptions.add(ZegoLiveStreamingManager()
        .onPKUserConnectingCtrl
        .stream
        .listen(onPKUserConnecting));

    if (widget.pkUser.userID == ZEGOSDKManager().currentUser!.userID) {
    } else {
      ZEGOSDKManager().expressService.startPlayingAnotherHostStream(
          widget.pkUser.pkUserStream, widget.pkUser.sdkUser);
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (final element in subscriptions) {
      element.cancel();
    }
  }

  void onPKUserConnecting(PKBattleUserConnectingEvent event) {
    // if (event.userID == widget.pkUser.userID) {
    //   final pkUserMuted = ZegoLiveStreamingManager().isPKUserMuted(event.userID);
    //   if (event.duration > 5000) {
    //     if (!pkUserMuted) {
    //       ZegoLiveStreamingManager().mutePKUser([event.userID], true).then((value) {
    //         if (value.errorCode == 0) {
    //           mutePlayAudio(true);
    //         }
    //       });
    //     }
    //   } else {
    //     if (pkUserMuted) {
    //       ZegoLiveStreamingManager().mutePKUser([event.userID], false).then((value) {
    //         if (value.errorCode == 0) {
    //           mutePlayAudio(false);
    //         }
    //       });
    //     }
    //   }
    // }
  }

  void mutePlayAudio(bool mute) {
    ZEGOSDKManager()
        .expressService
        .mutePlayStreamAudio(widget.pkUser.pkUserStream, mute);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.pkUser.connectingDuration,
        builder: (context, int duration, _) {
          if (duration > 5000) {
            return hostReconnecting();
          } else {
            return ValueListenableBuilder(
                valueListenable: widget.pkUser.sdkUser.isCamerOnNotifier,
                builder: (context, bool isCameraOn, _) {
                  if (isCameraOn) {
                    return SizedBox(
                      child: Stack(
                        children: [videoView(), foregroundView()],
                      ),
                    );
                  } else {
                    return SizedBox(
                      child: backGroundView(),
                    );
                  }
                });
          }
        });
  }

  Widget backGroundView() {
    return Stack(
      children: [
        Image.asset(
          'assets/icons/bg.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
          package: 'tussle_zego_sdk_manager',
        ),
        Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              border: Border.all(width: 0),
            ),
            child: Center(
              child: SizedBox(
                  height: 20,
                  child: Text(
                    widget.pkUser.userName[0],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Widget foregroundView() {
    if (ZEGOSDKManager().currentUser!.userID == widget.pkUser.userID) {
      return const SizedBox.shrink();
    } else {
      return LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Positioned(
              left: constraints.maxWidth - 80,
              top: 20,
              width: 60,
              height: 60,
              child: PKMuteButton(pkUser: widget.pkUser),
            )
          ],
        );
      });
    }
  }

  Widget videoView() {
    return ValueListenableBuilder<Widget?>(
      valueListenable: widget.pkUser.sdkUser.videoViewNotifier,
      builder: (context, view, _) {
        if (view != null) {
          return Container(
            color: Colors.blue,
            child: view,
          );
        } else {
          return Container(
            color: Colors.red,
          );
        }
      },
    );
  }

  Widget hostReconnecting() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Text(
          'Host is reconnecting…',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
