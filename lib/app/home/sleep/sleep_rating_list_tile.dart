// ignore : prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insomnia_checklist/app/home/models/sleep.dart';
import 'package:insomnia_checklist/app/top_level_providers.dart';

import 'package:insomnia_checklist/services/utils.dart';

typedef Future<void> OnSleepRating(
    BuildContext context, SleepRating sleepRating);

class SleepRatingExpandedTile extends ConsumerWidget {
  const SleepRatingExpandedTile({
    Key? key,
    required this.sleepRating,
    this.onRating,
  }) : super(key: key);
  final SleepRating sleepRating;

  final OnSleepRating? onRating;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final date = watch(sleepDateProvider).state;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Container(
        /*decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: sleepRating.date.isSameDay(date)
                  ? Theme.of(context).shadowColor.withOpacity(0.5)
                  : Theme.of(context).shadowColor.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),*/
        child: Material(
          //Material needed here for the IconButton splash to manifest correctly
          child: ListTile(
            //key: checklistItem.id,
            title: Row(
              children: [
                Container(
                    child: Text(SleepRating.labelAsDayOfWeek(sleepRating.date),
                        textScaleFactor: 0.9,
                        style: (sleepRating.date.isYesterday() ||
                                sleepRating.date.isDayBeforeYesterday())
                            ? Theme.of(context).textTheme.headline5
                            : Theme.of(context)
                                .textTheme
                                .headline6!
                                .apply(color: Colors.grey[600])),
                    width: 140),
                RatingBar.builder(
                  initialRating: sleepRating.value,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amberAccent,
                  ),
                  itemCount: 5,
                  itemSize: 35.0,
                  direction: Axis.horizontal,
                  onRatingUpdate: (rating) {
                    if (onRating != null) {
                      final SleepRating newSleepRating =
                          sleepRating.copy(newValue: rating);
                      onRating!(context, newSleepRating);
                      context.read(itemsDateProvider).state = sleepRating.date;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
