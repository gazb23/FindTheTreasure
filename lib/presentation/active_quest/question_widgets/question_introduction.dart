import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_the_treasure/models/location_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
import 'package:find_the_treasure/presentation/active_quest/question_widgets/image_zoom.dart';
import 'package:find_the_treasure/services/connectivity_service.dart';

import 'package:find_the_treasure/widgets_common/custom_circular_progress_indicator_button.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class QuestionIntroduction extends StatelessWidget {
  final BuildContext context;
  final LocationModel locationModel;
  final QuestionsModel questionsModel;
  final bool locationQuestion;
  final bool showImage;
  final bool largerImage;

  const QuestionIntroduction({
    Key key,
    @required this.context,
    @required this.locationModel,
    @required this.questionsModel,
    @required this.locationQuestion,
    this.showImage = false,
    this.largerImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 150,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding:
                const EdgeInsets.only(top: 10, left: 5, right: 10, bottom: 10),
            decoration: BoxDecoration(
                boxShadow: [
                  const BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.3, 0.1),
                      blurRadius: 1.0,
                      spreadRadius: 1.0)
                ],
                color: Colors.grey.shade800,
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(50))),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  AutoSizeText(
                    locationQuestion
                        ? locationModel.questionIntroduction
                        : questionsModel.questionIntroduction,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: showImage ? 10 : 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  showImage
                      ? ConnectivityService.checkNetwork(context, listen: true)
                          ? CachedNetworkImage(
                              imageUrl: questionsModel.image,
                              fadeInDuration: Duration(milliseconds: 300),
                              placeholder: (context, url) =>
                                  CustomCircularProgressIndicator(),
                              imageBuilder: (context, image) => InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) =>
                                          ImageZoom(image: image)));
                                },
                                child: Container(
                                    height: largerImage
                                        ? MediaQuery.of(context).size.height /
                                            2.5
                                        : MediaQuery.of(context).size.height /
                                            2.8,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(40)),
                                      image: DecorationImage(
                                          image: image,
                                          fit: BoxFit.fill,
                                          alignment: Alignment.center),
                                    )),
                              ),
                            )
                          : Container(child: _offlineImage())
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  FutureBuilder<File> _offlineImage() {
    return FutureBuilder(
        future: _getLocalFile("${questionsModel.image}.jpg"),
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CustomCircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          } else
            return snapshot.data != null
                ? InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) =>
                              ImageZoom(image: FileImage(snapshot.data))));
                    },
                    child: Container(
                      width: double.infinity,
                      height: largerImage
                          ? MediaQuery.of(context).size.height / 2.5
                          : MediaQuery.of(context).size.height / 2.8,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(40)),
                          child: Image.file(
                            snapshot.data,
                            fit: BoxFit.fill,
                            alignment: Alignment.center,
                          )),
                    ),
                  )
                : Container(
                    child: Center(
                      child: CustomCircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
        });
  }

  Future<File> _getLocalFile(String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File f = new File('$dir/$filename');
    return f;
  }
}
