package cpsc331.tutorials;

public class Fibonacci1
{

  // A straightfoward application of the recursive algorithm fib
  // discussed in Lecture #2: It is expected here that one or
  // more arguments is included on the command line and that the first
  // is the integer n that will be supplied as input to this
  // recursive algorithm.
  //
  // The integer output that is supplied by the algorithm will be
  // printed as output.
  //
  // Author: Wayne Eberly

  public static void main(String[] args) {

    int n = Integer.parseInt(args[0]);
    System.out.println(fib(n));

  }
  
  // A Recursive Algorithm for the "Fibonacci Number Computation" Problem
  //
  // Precondition: A non-negative integer n is given as input.
  // Postcondition: The nth Fibonacci number, F_n, is returned as output.
  //
  // Bound Function: n

  public static int fib(int n)
  {
  
    // Assertion: n is an integer input such that n is greater than
    // or equal to 0.

    if (n == 0) {

      // Assertion: n is an integer input whose value is 0.

      return 0;

      // Assertion:
      // 1. n is an integer input whose value is 0.
      // 2. The nth Fibonacci number, F_n = F_0 = 0, has been returned as output.

    } else if (n == 1) {

      // Assertion: n is an integer input whose value is 1.

      return 1;

      // Assertion:
      // 1. n is an integer input whose value is 1.
      // 2. The nth Fibonacci number, F_n = F_1 = 1, has been returned as output.

    } else {

      // Assertion: n is an integer input such that n is greater than or
      //   equal to 2.

      return fib(n-1) + fib(n-2);

     // Assertion:
     // 1. n is an integer input such that n is greater than or equal to 2.
     // 2. The nth Fibonacci number, F_n = F_(n-2) + F_(n-1), has been
     //    returned as output.

    }

    // Assertion:
    // 1. n is an integer input such that n is greater than or equal to 0.
    // 2. The nth Fibonacci number, F_n, has been returned as output.

  }

}
