class TrendingSnackList {
  final String name;
  final String image;

  TrendingSnackList(this.name, this.image);

  static List<TrendingSnackList> getProducts() {
    List<TrendingSnackList> items = <TrendingSnackList>[];

    items.add(TrendingSnackList("Cheetos", "placeholderImage.jpg"));
    items.add(TrendingSnackList("Cheez-It", "placeholderImage.jpg"));
    items.add(TrendingSnackList("Goldfish", "placeholderImage.jpg"));
    items.add(TrendingSnackList("OREO", "placeholderImage.jpg"));
    items.add(TrendingSnackList("Gardetto's", "placeholderImage.jpg"));
    return items;
  }
}
