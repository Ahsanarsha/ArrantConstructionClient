import 'package:arrant_construction_client/src/controllers/comments_controller.dart';
import 'package:arrant_construction_client/src/pages/project_comments.dart';
import 'package:arrant_construction_client/src/widgets/add_project_comment.dart';
import '../controllers/project_controller.dart';
import '../helpers/helper.dart';
import '../models/project.dart';
import '../models/project_comment.dart';
import '../models/project_media_library.dart';
import '../models/project_service.dart';
import '../widgets/dialogs/image_dialog.dart';
import '../widgets/listsWidgets/comment_card.dart';
import '../widgets/loadingWidgets/loading_card_widget.dart';
import '../widgets/showProjectsWidgets/project_list_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../helpers/app_constants.dart' as constants;

class ProjectDetails extends StatefulWidget {
  final Project project;
  const ProjectDetails(this.project, {Key? key}) : super(key: key);

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  final ProjectController _con = Get.find(tag: constants.projectsConTag);
  final CommentsController _commentsController = CommentsController();
  void acceptProject() {
    // update status to 3
    _con.updateProjectStatus(context, widget.project.id!, 3).then((value) {
      if (value) {
        Navigator.pop(context, value);
      }
    });
  }

  void addComment(ProjectComment _comment) {
    _comment.projectId = widget.project.id;
    _comment.senderType = 1;
    _comment.isVisibleToClient = 1;
    _comment.isVisibleToManager = 1;
    _comment.isVisibleToVendor = 0;
    _commentsController.addProjectComment(_comment);
  }

  void onViewAllCommentsClicked() {
    FocusScope.of(context).requestFocus(FocusNode());
    // go to comments page
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ProjectComments(widget.project.id!, _commentsController);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Helper.bottomToTopTransition(child, animation);
        },
        // transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Get.create(
    //   () => CommentsController(),
    //   // permanent: false,
    //   tag: constants.commentsConTag,
    // );
    // _commentsController = Get.find(tag: constants.commentsConTag);
    print("in init of project details page");
    // get project comments
    _commentsController.getProjectComments(widget.project.id ?? '');
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   // print("disposing project details page resources");
  //   // _commentsController.dispose();
  //   // Get.delete<CommentsController>();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    SizedBox mainAxisPadding = SizedBox(
      height: MediaQuery.of(context).size.height * 0.015,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mainAxisPadding,
            _projectImagesCarousel(),
            mainAxisPadding,
            ProjectListTileWidget(
              widget.project,
              () {},
              showDescription: false,
            ),
            mainAxisPadding,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                widget.project.description,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            mainAxisPadding,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: _ProjectServicesTable(widget.project.addedServices),
            ),
            mainAxisPadding,
            widget.project.status > 1
                ? _EstimationTile(widget.project)
                : const SizedBox(),
            mainAxisPadding,
            widget.project.status == 2
                ? Align(
                    alignment: Alignment.center,
                    child: _acceptProjectButton(),
                  )
                : const SizedBox(),
            mainAxisPadding,
            widget.project.status == 3
                ? Obx(() {
                    const int numberOfCommentsOnMainPage = 2;
                    return _commentsController.projectComments.isEmpty &&
                            _commentsController
                                .doneFetchingProjectComments.value
                        ? const Center(child: Text("No comments"))
                        : _commentsController.projectComments.isEmpty &&
                                !_commentsController
                                    .doneFetchingProjectComments.value
                            ? LoadingCardWidget(
                                cardCount: 2,
                                width: MediaQuery.of(context).size.width * 0.90,
                                adjustment: BoxFit.fill,
                              )
                            : _CommentWidget(
                                _commentsController.projectComments
                                    .take(numberOfCommentsOnMainPage)
                                    .toList(),
                                onViewAllCommentsClicked,
                                // addComment,
                                _commentsController.projectComments.length,
                              );
                  })
                : const SizedBox(),
            widget.project.status == 3
                ? AddProjectCommentWidget(addComment)
                : const SizedBox(),
            mainAxisPadding,
          ],
        ),
      ),
    );
  }

  // Widget _commentSection() {
  //   double borderRadius = 15.0;
  //   return
  // }

  Widget _acceptProjectButton() {
    return TextButton(
      onPressed: () {
        acceptProject();
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 50.0),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.green),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
      ),
      child: const Text(
        "Accept",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _projectImagesCarousel() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: widget.project.mediaLibraryFiles.isNotEmpty
          ? CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.25,
                // height: 200,
                autoPlay: true,
                enableInfiniteScroll: false,
              ),
              items: widget.project.mediaLibraryFiles
                  .map((ProjectMediaLibrary mediaItem) {
                // print("Url: " + mediaItem.url);
                return GestureDetector(
                  onTap: () {
                    Get.dialog(
                      ImageDialogWidget(
                        mediaItem.url,
                        width: MediaQuery.of(context).size.width * 0.90,
                      ),
                    );
                  },
                  child: _ProjectImageBuilder(mediaItem.url),
                );
              }).toList(),
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.25,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: const Center(
                  child: Icon(
                Icons.image,
              )),
            ),
    );
  }

  // Widget _projectEstimatesTile() {
  //   return ListTile(
  //     title: Text(),
  //   );
  // }
}

class _CommentWidget extends StatelessWidget {
  final List<ProjectComment> comments;
  final int totalComments;
  final Function onViewAllClicked;
  // final Function addComment;
  // final int numberOfCommentsOnMainPage;
  final double borderRadius = 15.0;
  const _CommentWidget(
    this.comments,
    this.onViewAllClicked,
    // this.addComment,
    this.totalComments, {
    Key? key,
    // this.numberOfCommentsOnMainPage = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!,
            spreadRadius: 3,
            blurRadius: 2,
            offset: const Offset(0, -2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _commentHeading(),
              const Spacer(),
              _viewAllButton(),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          _commentsList(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _commentsList() {
    return ListView.builder(
      itemCount: comments.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CommentCardWidget(comments[index]),
        );
      },
    );
  }

  Widget _viewAllButton() {
    return TextButton(
      onPressed: () {
        onViewAllClicked();
      },
      child: const Text("View All"),
    );
  }

  Widget _commentHeading() {
    return Text(
      "Comments ($totalComments)",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _EstimationTile extends StatelessWidget {
  final Project project;
  const _EstimationTile(this.project, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleSubTitleStyle = const TextStyle(
      // same as title
      color: Colors.black,
      fontSize: 16,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Estimate:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ExpansionTile(
          initiallyExpanded: true,
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          // expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.topLeft,
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              project.estimatedStartDate,
              style: titleSubTitleStyle,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              project.estimatedEndDate,
              style: titleSubTitleStyle,
            ),
          ),
          leading: _leadingColumn(context),
          // leading: _leadingColumn(),
          trailing: Helper.of(context).getPriceRichText(
            project.estimatedCost,
            size: 15,
          ),
          children: _expandedColumnWidgetsList(),
        ),
      ],
    );
  }

  List<Widget> _expandedColumnWidgetsList() {
    return [
      const Text(
        "Comment:",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        project.backofficeComments,
      ),
    ];
  }

  Widget _leadingColumn(BuildContext context) {
    const double containerRadius = 8.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: containerRadius,
          width: containerRadius,
          decoration: BoxDecoration(
            // color: Colors.red,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.green,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.027,
            child: const VerticalDivider(
              // width: 2,
              thickness: 1,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          height: containerRadius,
          width: containerRadius,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class _ProjectServicesTable extends StatelessWidget {
  final List<ProjectService> projectServices;
  final double mainRowChildrenVerticalPadding = 5.0;
  List<TableRow> allRows = [];
  _ProjectServicesTable(this.projectServices, {Key? key}) : super(key: key) {
    TextStyle mainRowHeadingStyle = const TextStyle(
      fontWeight: FontWeight.bold,
    );
    TableRow firstRow = TableRow(
      decoration: const BoxDecoration(),
      children: [
        Center(
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: mainRowChildrenVerticalPadding),
            child: Text(
              "Service",
              style: mainRowHeadingStyle,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: mainRowChildrenVerticalPadding),
            child: Text(
              "Area(m${constants.squareSC})",
              style: mainRowHeadingStyle,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: mainRowChildrenVerticalPadding),
            child: Text(
              "Description",
              style: mainRowHeadingStyle,
            ),
          ),
        ),
      ],
    );
    allRows.add(firstRow);
  }

  @override
  Widget build(BuildContext context) {
    // adding all other rows dynamic values to the list
    allRows.addAll(projectServices.map((ProjectService _service) {
      // print("service description");
      // print(_service.description);
      return _servicesTableRow(_service);
    }));
    // print(allRows.length);
    return Table(
      border: TableBorder.all(
        color: Theme.of(context).primaryColor,
      ),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(2)
      },
      children: allRows,
    );
  }

  TableRow _servicesTableRow(ProjectService s) {
    const double verticalPadding = 5.0;
    const double horizontalPadding = 5.0;
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Text(
            s.service?.name ?? '',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Text(
            s.areaInSqM.toString(),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            child: Text(
              s.description ?? 'N/A',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectImageBuilder extends StatelessWidget {
  final String url;
  const _ProjectImageBuilder(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "${constants.storageBaseUrl}$url",
      imageBuilder: (context, imageProvider) {
        return _imageBuilder(context, imageProvider);
      },
      placeholder: (context, url) {
        return _placeHolder();
      },
      errorWidget: (context, error, d) {
        return _errorWidget();
      },
    );
  }

  Widget _imageBuilder(
      BuildContext context, ImageProvider<Object> imageProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill,
          )),
    );
  }

  Widget _placeHolder() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
          // color: Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          image: DecorationImage(
            image: AssetImage("assets/img/loading.gif"),
            fit: BoxFit.cover,
          )),
    );
  }

  Widget _errorWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: const Center(
          child: Icon(
        Icons.image,
      )),
    );
  }
}
