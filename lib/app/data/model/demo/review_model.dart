class ReviewDemo {
  final String image =
      "https://thuthuatnhanh.com/wp-content/uploads/2019/06/anh-anime-nam.jpg";
  final String name = "Trần A";
  final double rate = 4;
  final String date = "25/09/2021";
  final String content =
      "Bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla.";
  final String device = "Máy quạt";
  final double price = 50000;
  final String respondContent =
      "Bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla.";
}

List<ReviewDemo> reviewDemoList = List.filled(6, ReviewDemo());

List<int> reviewCountList = [20, 6, 3, 4, 4, 3].reversed.toList();
