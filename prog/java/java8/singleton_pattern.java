public class Singleton {
  private final static Singleton instance = new Singleton();
  private static boolean initialized = false;

  // Constructor
  private Singleton() {
    super();
  }

  private void init() {
    /* Do initialization */
  }

  // This method should be the only way to get a reference
  // to the instance
  public static synchronized Singleton getInstance() {
    if (initialized) return instance;
    instance.init();
    initialized = true;
    return instance;
  }
}
