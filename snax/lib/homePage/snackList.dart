class TrendingSnackList {
  final String name;
  final String image;
  final String categories;
  final double rating;
  final int totalRatings;
  final double sweetness;
  final double sourness;
  final double saltiness;
  final double spiciness;
  final double mouthfeel;
  final double accessibility;
  final double snackability;

  TrendingSnackList(
      this.name,
      this.image,
      this.categories,
      this.rating,
      this.totalRatings,
      this.sweetness,
      this.sourness,
      this.saltiness,
      this.spiciness,
      this.mouthfeel,
      this.accessibility,
      this.snackability);

  static List<TrendingSnackList> getProducts() {
    List<TrendingSnackList> items = <TrendingSnackList>[];
    items.add(TrendingSnackList("Cheetos", "placeholderImage.jpg", "Snack", 4.3,
        10000, 2.4, 3.6, 3.3, 2.3, 4.5, 1.2, 2.1));
    items.add(TrendingSnackList("Cheez-It", "placeholderImage.jpg", "Snack", 5,
        10000, 2.4, 3.6, 3.3, 2.3, 4.5, 1.2, 2.1));
    items.add(TrendingSnackList("Goldfish", "placeholderImage.jpg", "Snack", 5,
        10000, 2.4, 3.6, 3.3, 2.3, 4.5, 1.2, 2.1));
    items.add(TrendingSnackList("OREO", "placeholderImage.jpg", "Snack", 5,
        10000, 2.4, 3.6, 3.3, 2.3, 4.5, 1.2, 2.1));
    items.add(TrendingSnackList("Gardetto's", "placeholderImage.jpg", "Snack",
        5, 10000, 2.4, 3.6, 3.3, 2.3, 4.5, 1.2, 2.1));
    return items;
  }
}
