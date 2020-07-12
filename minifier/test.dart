void main() {
  var str =
      """a) The'û \"nominal\" <<-a>> (ة) sentence الجُمْلَةُ الاسْمِيَّّةُ wherein the first word is a noun e.g. الكِتَابُ سَهْلٌ 'The book is easy'. The noun which commences the nominal sentence is called the mubtada الْمُبْتَدَأُ while the second part is called the khabar الْخَبَرُ.""";
  var reg = RegExp(r"([a-z()<>'\s.0-9´û-]+)|([^a-z.\'()]+)",
      multiLine: true, caseSensitive: false);
  reg
      .allMatches(
    str,
  )
      .forEach((e) {
    print(e[0]);
  });
}
