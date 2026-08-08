public final class Circle implements Comparable<Circle> {
    private final int x, y, r;

    // Main constructor
    private Circle(int x, int y, int r) {
        if (r < 0) throw new IllegalArgumentException("radius < 0");
        this.x = x; this.y = y; this.r = r;
    }

    // Usual factory method
    public static Circle of(int x, int y, int r) {
        return new Circle(x, y, r);
    }

    // Factory method playing the role of the copy constructor
    public static Circle of(Circle original) {
        return new Circle(original.x, original.y, original.r);
    }

    // Third factory with intent given by name
    public static Circle ofOrigin(int r) {
        return new Circle(0, 0, r);
    }

    // other methods elided
}
