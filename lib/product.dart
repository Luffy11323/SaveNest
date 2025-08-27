class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<Price> prices;
  final Map<String, String> nutrition;
  final double rating;
  final List<Review> reviews;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.prices,
    required this.nutrition,
    required this.rating,
    required this.reviews,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      prices: (json['prices'] as List).map((e) => Price.fromJson(e)).toList(),
      nutrition: Map<String, String>.from(json['nutrition'] ?? {}),
      rating: json['rating'].toDouble(),
      reviews: (json['reviews'] as List)
          .map((e) => Review.fromJson(e))
          .toList(),
      category: json['category'] ?? '',
    );
  }
}

class Price {
  final String store;
  final double price;
  final String link;

  Price({required this.store, required this.price, required this.link});

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      store: json['store'],
      price: json['price'].toDouble(),
      link: json['link'],
    );
  }
}

class Review {
  final String user;
  final String comment;

  Review({required this.user, required this.comment});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(user: json['user'], comment: json['comment']);
  }
}
