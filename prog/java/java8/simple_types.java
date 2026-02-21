// True: all strings are instances of String
"string" instanceof String
// True: strings are also instances of Object
"" instanceof Object
// False: null is never an instance of anything
null instanceof String

Object o = new int[] {1,2,3};
o instanceof int[]   // True: the array value is an int array
o instanceof byte[]  // False: the array value is not a byte array
o instanceof Object  // True: all arrays are instances of Object

// Use instanceof to make sure that it is safe to cast an object
if (object instanceof Account) {
   Account a = (Account) object;
}
