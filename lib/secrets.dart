String publishableKeyLive =
    "pk_live_51Hga2kLRbI5gjrlUOyQ1p7mgiFNWYXLQR4TIQ50LzwyaKSph4iBwI8CuykB1MNOj3xzIMmOLtLUOWQCL75OODtH70086d4DDda";
String publishableKeyTest =
    "pk_test_51Hga2kLRbI5gjrlUqpZ1OkIw6F3jPmZxdYkIrWI1gIJpVu1ANCZnlzIuqzIHzL0Sfz8bKBl2EOVcdp2RYiKg9Tzm00rv0uSYjH";
bool isInTesting = true;
String get publishableKey {
  return isInTesting ? publishableKeyTest : publishableKeyLive;
}
