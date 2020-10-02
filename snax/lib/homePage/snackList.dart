class SnackList {
  final String name;

  SnackList(this.name);

  static List<SnackList> getProducts() {
    List<SnackList> items = <SnackList>[];

    items.add(SnackList("Cheetos"));
    items.add(SnackList("Cheez-It"));
    items.add(SnackList("Goldfish"));
    items.add(SnackList("OREO"));
    items.add(SnackList("Gardetto's"));
    return items;
  }
}
