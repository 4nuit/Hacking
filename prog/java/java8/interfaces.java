// Static member types (nested class)

public interface Map<K, V> {
    // ...

    Set<Map.Entry<K, V>> entrySet();

    // All nested interfaces are automatically static
    interface Entry<K, V> {
        K getKey();
        V getValue();
        V setValue(V value);

        // other members elided
    }

    // other members elided
}


// Non static member class (example: iterator)

import java.util.Iterator;

public class LinkedStack {

    // Our static member interface
    public interface Linkable {
        public Linkable getNext();
        public void setNext(Linkable node);
    }

    // The head of the list
    private Linkable head;

    // Method bodies omitted here
    public void push(Linkable node) { ... }
    public Linkable pop() { ... }

    // This method returns an Iterator object for this LinkedStack
    public Iterator<Linkable> iterator() { return new LinkedIterator(); }

    // Here is the implementation of the Iterator interface,
    // defined as a nonstatic member class.
    protected class LinkedIterator implements Iterator<Linkable> {
        Linkable current;

        // The constructor uses a private field of the containing class
        public LinkedIterator() { current = head; }

        // The following three methods are defined
        // by the Iterator interface
        public boolean hasNext() {  return current != null; }

        public Linkable next() {
            if (current == null)
              throw new java.util.NoSuchElementException();
            Linkable value = current;
            current = current.getNext();
            return value;
        }

        public void remove() { throw new UnsupportedOperationException(); }
    }
}
