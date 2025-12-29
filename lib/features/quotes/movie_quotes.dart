import 'movie_quote.dart';

class MovieQuotes {
  static const List<MovieQuote> quotes = [
    MovieQuote(
      quote: 'Hope is a good thing, maybe the best of things.',
      movie: 'The Shawshank Redemption',
    ),
    MovieQuote(
      quote: 'With great power comes great responsibility.',
      movie: 'Spider-Man',
    ),
    MovieQuote(quote: 'Why so serious?', movie: 'The Dark Knight'),
    MovieQuote(quote: 'May the Force be with you.', movie: 'Star Wars'),
    MovieQuote(
      quote: 'I’m going to make him an offer he can’t refuse.',
      movie: 'The Godfather',
    ),
    MovieQuote(
      quote: 'Life is like a box of chocolates.',
      movie: 'Forrest Gump',
    ),
    MovieQuote(quote: 'Just keep swimming.', movie: 'Finding Nemo'),
    MovieQuote(quote: 'To infinity… and beyond!', movie: 'Toy Story'),
    MovieQuote(
      quote:
          'You either die a hero or live long enough to see yourself become the villain.',
      movie: 'The Dark Knight',
    ),
    MovieQuote(
      quote: 'Carpe diem. Seize the day.',
      movie: 'Dead Poets Society',
    ),
    MovieQuote(quote: 'I’ll be back.', movie: 'The Terminator'),
    MovieQuote(
      quote:
          'No matter what anybody tells you, words and ideas can change the world.',
      movie: 'Dead Poets Society',
    ),
    MovieQuote(
      quote: 'Great men are not born great, they grow great.',
      movie: 'The Godfather',
    ),
    MovieQuote(
      quote: 'It’s not who I am underneath, but what I do that defines me.',
      movie: 'Batman Begins',
    ),
    MovieQuote(
      quote: 'Happiness can be found even in the darkest of times.',
      movie: 'Harry Potter and the Prisoner of Azkaban',
    ),
    MovieQuote(
      quote:
          'Sometimes it is the people who no one imagines anything of who do the things that no one can imagine.',
      movie: 'The Imitation Game',
    ),
    MovieQuote(
      quote: 'You mustn’t be afraid to dream a little bigger, darling.',
      movie: 'Inception',
    ),
    MovieQuote(
      quote: 'What we do in life echoes in eternity.',
      movie: 'Gladiator',
    ),
    MovieQuote(
      quote: 'After all, tomorrow is another day.',
      movie: 'Gone with the Wind',
    ),
    MovieQuote(
      quote: 'Every man dies, not every man really lives.',
      movie: 'Braveheart',
    ),
  ];

  /// Returns a quote based on the day (stable daily quote)
  static MovieQuote quoteOfTheDay() {
    final index = DateTime.now().day % quotes.length;
    return quotes[index];
  }

  /// Returns a random quote
  static MovieQuote randomQuote() {
    quotes.shuffle();
    return quotes.first;
  }
}
