import 'package:find_the_treasure/presentation/explore/screens/empty_content.dart';
import 'package:find_the_treasure/widgets_common/custom_circular_progress_indicator_button.dart';
import 'package:flutter/material.dart';

typedef ItemWidgetBuilder<T> = Widget Function(
    BuildContext context, T item, int index);

class ListItemsBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final AsyncSnapshot<T> snapshots;
  final String title;
  final String message;
  final String buttonText;
  final Image image;
  final VoidCallback onPressed;
  final bool buttonEnabled;
  final bool isSeperated;

  const ListItemsBuilder({
    Key key,
    this.snapshot,
    this.itemBuilder,
    this.snapshots,
    this.title,
    this.message,
    this.buttonText,
    this.image,
    this.onPressed,
    this.buttonEnabled = false,
    this.isSeperated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;

      if (items.isNotEmpty) {
        return _buildList(items);
      } else {    
        return EmptyContent(
          title: title,
          message: message,
          buttonText: buttonText,
          image: image,
          onPressed: onPressed,
          buttonEnabled: buttonEnabled,
        );
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something Went Wrong!',
        message: 'Can\'t load Quests right now',
      );
    }
    return Center(
      child: CustomCircularProgressIndicator(),
    );
  }

  Widget _buildList(List<T> items) {
    if (isSeperated) {
      return ListView.separated(
          separatorBuilder: (context, index) => Divider(
                thickness: 0.25,
                color: Colors.black26,
              ),
          itemCount: items.length + 2,
          itemBuilder: (context, index) {
            if (index == 0 || index == items.length + 1) {
              return Container();
            }
            return itemBuilder(context, items[index - 1], index);
          });
    }
    return ListView.builder(
      itemCount: items.length,    
      itemBuilder: (context, index) =>
          itemBuilder(context, items[index], index),
    );
  }
}
