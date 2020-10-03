class TrendingSnackList {
  final String name;
  final String image;
  final String categories;
  final int rating;

  TrendingSnackList(this.name, this.image, this.categories, this.rating);

  static List<TrendingSnackList> getProducts() {
    List<TrendingSnackList> items = <TrendingSnackList>[];

    items.add(TrendingSnackList("Cheetos", "placeholderImage.jpg", "Snack", 5));
    items
        .add(TrendingSnackList("Cheez-It", "placeholderImage.jpg", "Snack", 5));
    items
        .add(TrendingSnackList("Goldfish", "placeholderImage.jpg", "Snack", 5));
    items.add(TrendingSnackList("OREO", "placeholderImage.jpg", "Snack", 5));
    items.add(
        TrendingSnackList("Gardetto's", "placeholderImage.jpg", "Snack", 5));
    return items;
  }
}
