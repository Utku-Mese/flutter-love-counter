// ignore_for_file: deprecated_member_use, unnecessary_new
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class StaggeredAnimationsView extends StatefulWidget {
  const StaggeredAnimationsView({Key? key}) : super(key: key);

  @override
  State<StaggeredAnimationsView> createState() =>
      _StaggeredAnimationsViewState();
}

/*
class RelationshipTimer {
  var defference = DateTime.now().difference(DateTime(2019, 5, 30, 13, 10)).inSeconds;
 
  String timeDifference() { 
    
    final year = defference ~/ 31556926;
    final day = (defference - (year * 31556926)) ~/ 86400;
    final hour = (defference - (day * 86400) - (year * 31556926)) ~/ 3600;
    final minut =
        (defference - (hour * 3600) - (day * 86400) - (year * 31556926)) ~/ 60;
    final second = defference -
        (minut * 60) -
        (hour * 3600) -
        (day * 86400) -
        (year * 31556926);
    final String sonuc =
        "$year yıl $day gün $hour saat $minut dakika $second saniye";
    return sonuc;
  }
}
*/
class _StaggeredAnimationsViewState extends State<StaggeredAnimationsView>
    with TickerProviderStateMixin {
  late AnimationController sequenceAnimationController;
  late SequenceAnimation sequenceAnimation;

  late AnimationController heartAnimationController;
  late Animation<double> heartSizeAnimation;

  var defference = DateTime.now().difference(DateTime(2019, 5, 30, 13, 10)).inSeconds;
 
  String timeDifference() { 
    
    final year = defference ~/ 31556926;
    final day = (defference - (year * 31556926)) ~/ 86400;
    final hour = (defference - (day * 86400) - (year * 31556926)) ~/ 3600;
    final minut =
        (defference - (hour * 3600) - (day * 86400) - (year * 31556926)) ~/ 60;
    final second = defference -
        (minut * 60) -
        (hour * 3600) -
        (day * 86400) -
        (year * 31556926);
    final String sonuc =
        "$year yıl $day gün $hour saat $minut dakika $second saniye";
    return sonuc;
  }

  bool timerContinue = true;

  String text = "" ;

  Timer? timer;

  void startTimer(){
    if(timerContinue == true){
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        defference++;
      });
    });
    }
  }
  
  @override
  void initState() {
    startTimer();
    super.initState();
    sequenceAnimationController = AnimationController(vsync: this);

    heartAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );

    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
          animatable: AlignmentTween(
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
          from: Duration(milliseconds: 0),
          to: Duration(milliseconds: 1500),
          curve: Curves.elasticInOut,
          tag: "alignment",
        )
        .addAnimatable(
          animatable: Tween<double>(
            begin: 150,
            end: 330,
          ),
          from: Duration(milliseconds: 750),
          to: Duration(milliseconds: 1000),
          tag: "size",
        )
        .addAnimatable(
          animatable: ColorTween(
            begin: Colors.black,
            end: Colors.red,
          ),
          from: Duration(milliseconds: 750),
          to: Duration(milliseconds: 850),
          tag: "color",
        )
        .animate(sequenceAnimationController);

    heartSizeAnimation = Tween<double>(
      begin: 1,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: heartAnimationController,
      curve: Curves.elasticIn,
    ));

    sequenceAnimationController.forward();
    
    sequenceAnimationController.addListener(() {
      setState(() {});
    });
    
    sequenceAnimationController.addStatusListener((status) async {
      if (sequenceAnimationController.isCompleted) {
        text = "KÜS😢";
        heartAnimationController.repeat(reverse: true);
      } else {
        text = "BARIŞ";
        heartAnimationController.stop();
      }
    });

    heartAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    sequenceAnimationController.dispose();
    heartAnimationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            child: FlatButton(
              height: 50,
              minWidth: 150,
              color: Color(0xFFE57373),
              onPressed: () async {
                if (sequenceAnimationController.isCompleted) {
                  sequenceAnimationController.reverse();
                } else if (sequenceAnimationController.isDismissed) {
                  sequenceAnimationController.forward();
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: sequenceAnimation["alignment"].value,
              child: Transform.scale(
                scale: heartSizeAnimation.value,
                child: Icon(
                  (sequenceAnimationController.status !=
                          AnimationStatus.dismissed)
                      ? Icons.favorite
                      : Icons.heart_broken,
                  size: sequenceAnimation["size"].value,
                  color: sequenceAnimation["color"].value,
                ),
              ),
            ),
          ),
          Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Color(0xFFE57373),
                  borderRadius: BorderRadius.circular(30)),
              margin: EdgeInsets.only(bottom: 150),
              child: Center(
                child: Text(
                  timeDifference(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
