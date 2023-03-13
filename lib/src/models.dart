
enum ImageOrientation { up, down, left, right }

extension ParseToString on ImageOrientation {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
