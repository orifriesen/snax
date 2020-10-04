class TrendingSnackList {
  final String name;
  final String image;
  final String categories;
  final double rating;
  final int totalRatings;

  TrendingSnackList(
      this.name, this.image, this.categories, this.rating, this.totalRatings);

  static List<TrendingSnackList> getProducts() {
    List<TrendingSnackList> items = <TrendingSnackList>[];
    items.add(TrendingSnackList(
        "Cheetos", "placeholderImage.jpg", "Snack", 4.3, 10000));
    items.add(TrendingSnackList(
        "Cheez-It", "placeholderImage.jpg", "Snack", 5, 10000));
    items.add(TrendingSnackList(
        "Goldfish", "placeholderImage.jpg", "Snack", 5, 10000));
    items.add(
        TrendingSnackList("OREO", "placeholderImage.jpg", "Snack", 5, 10000));
    items.add(TrendingSnackList(
        "Gardetto's", "placeholderImage.jpg", "Snack", 5, 10000));
    return items;
  }
}
