class A {                          // Define a class named A
  int i = 1;                       // An instance field
  int f() { return i; }            // An instance method
  static char g() { return 'A'; }  // A class method
}

class B extends A {                // Define a subclass of A
  int i = 2;                       // Hides field i in class A
  int f() { return -i; }           // Overrides method f in class A
  static char g() { return 'B'; }  // Hides class method g() in class A
}

public class OverrideTest {
  public static void main(String args[]) {
    B b = new B();               // Creates a new object of type B
    System.out.println(b.i);     // Refers to B.i; prints 2
    System.out.println(b.f());   // Refers to B.f(); prints -2
    System.out.println(b.g());   // Refers to B.g(); prints B
    System.out.println(B.g());   // A better way to invoke B.g()

    A a = (A) b;                 // Casts b to an instance of class A
    System.out.println(a.i);     // Now refers to A.i; prints 1
    System.out.println(a.f());   // Still refers to B.f(); prints -2
    System.out.println(a.g());   // Refers to A.g(); prints A
    System.out.println(A.g());   // A better way to invoke A.g()
  }
}
