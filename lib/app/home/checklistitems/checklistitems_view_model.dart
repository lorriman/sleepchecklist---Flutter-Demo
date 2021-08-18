import 'package:insomnia_checklist/app/home/models/rating.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:insomnia_checklist/app/home/checklistitems/rating_checklistitem.dart';
import 'package:insomnia_checklist/app/home/models/check_list_item.dart';
import 'package:insomnia_checklist/services/repository.dart';
import 'package:insomnia_checklist/services/utils.dart';
import 'checklistitem_list_tile.dart';

class ChecklistItemsViewModel {
  ChecklistItemsViewModel({required this.database});

  final Repository database;

  static String labelDate(DateTime date) {
    if (date.isToday()) return 'Today';
    if (date.isYesterday()) return 'Yesterday';
    return DateFormat.yMMMEd().format(date);
  }

  Future<void> rewriteSortOrdinals(
      List<ChecklistItemListTileModel> items) async {
    final Map<String, int> newSortOrdinalsMap = {};
    int i = 0;
    //put null ordinals to the top of the list (ie, which were untrashed or new)
    items.where((item) => !item.trash && item.ordinal == null).forEach((item) {
      newSortOrdinalsMap[item.id] = i++;
    });
    //then do the rest
    items.where((item) => !item.trash && item.ordinal != null).forEach((item) {
      newSortOrdinalsMap[item.id] = i++;
    });
    await database.setChecklistItemsSortOrdinals(newSortOrdinalsMap);
  }

  Stream<List<RatingChecklistItem>> _ChecklistitemsRatingitemsStream(
      DateTime day) {
    return CombineLatestStream.combine2(
      database.ratingsIndexedByChecklistItemIdStream(day: day),
      database.checklistItemsStream(), // as Stream<List<ChecklistItem>>,
      _ratingsChecklistItemsCombiner,
    );
  }

  static List<RatingChecklistItem> _ratingsChecklistItemsCombiner(
      Map<String, Rating>? ratings, List<ChecklistItem> checklistItems) {
    final List<RatingChecklistItem> combo = [];
    checklistItems.forEach((checklistItem) {
      final Rating? rating = ratings?[checklistItem.id];
      combo.add(RatingChecklistItem(rating, checklistItem));
    });
    return combo;
  }

  /// Output stream
  Stream<List<ChecklistItemListTileModel>> tileModelStream(DateTime day) =>
      _ChecklistitemsRatingitemsStream(day).map(_createModels);

  List<ChecklistItemListTileModel> _createModels(
      List<RatingChecklistItem> allEntries) {
    if (allEntries.isEmpty) {
      return [];
    }

    return <ChecklistItemListTileModel>[
      for (RatingChecklistItem item in allEntries) ...[
        ChecklistItemListTileModel(
          database: database,
          id: item.checklistItem.id,
          checklistItem: item.checklistItem,
          leadingText: item.checklistItem.name,
          bodyText: item.checklistItem.description,
          rating: item.rating?.value ?? 0.0,
          isHeader: false,
          trash: item.checklistItem.trash,
          ordinal: item.checklistItem.ordinal,
        )
      ]
    ];
  }
}
