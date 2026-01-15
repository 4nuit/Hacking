## Java idioms

- [Java8 Playlist - Coding with John ](https://www.youtube.com/watch?v=qJr1PjTt2S8&list=PLkeaG1zpPTHhXOfy-mFbdqd1Zz4GnjcpC)
- https://en.wikipedia.org/wiki/Java_version_history
- https://google.github.io/styleguide/javaguide.html

### OpenJDK

- https://wiki.archlinux.org/title/Java#OpenJDK
- https://wiki.archlinux.org/title/Java#Switching_between_JVM

### Resources

- [Head First Java](https://docs.google.com/file/d/0BwxUBHTpU9kCU0xubVhyYlp0bWc/view?resourcekey=0-sk68B4dt12P8MPoLieNBBA)
- https://github.com/kittylyst/javanut8
- https://docs.oracle.com/javase/tutorial/collections/streams/parallelism.html
- https://gokan-ekinci.developpez.com/tutoriels/java/introduction-bien-debuter-avec-maven/#LI

### Java's references

- https://stackoverflow.com/questions/36347/what-are-the-differences-between-generic-types-in-c-and-java

Function call => copy of the argument on the stack

- Passed by value : dont modify the argument (treated like a value) after ret  
- Passed by address/ptr or reference: modify the argument (treated like a reference) after ret

```
Object references are passed by value.
Java works exactly like C. You can assign a pointer, pass the pointer to a method, follow the pointer in the method and change the data that was pointed to. However, you cannot change where that pointer points.
```
