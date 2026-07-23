// A functional interface is an interface that includes only one abstract method.
// Runnable, ActionListener, Comparable are some functional interfaces examples.

@FunctionalInterface
interface Forme {
    int calculer(int x);
}
