namespace LamportTimestamps
{
    using System;

    public class Program
    {
        static void Main(string[] args)
        {
            int fib1 = func(2,3);
            Console.WriteLine(fib1);
            Console.ReadLine();
        }

        static int func(int a, int b)
        {
            if (a == 0) return b + 1;
            if (a > 0 && b == 0) return func(a - 1, 1);
            return func(a - 1, func(a, b - 1));
        }
    }
}
