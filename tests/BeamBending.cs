// BeamBending.cs
using System;

namespace BeamBendingApp
{
    class Program
    {
        static void Main(string[] args)
        {
            // Beam parameters
            double force = 1000; // N
            double length = 2;   // m
            double momentOfInertia = 0.0001; // m^4
            double youngsModulus = 200000000000; // N/m^2

            // Calculate the maximum deflection using the beam bending equation
            // Beam Deflection Formula: δ = (F * L^3) / (3 * E * I)
            double deflection = (force * Math.Pow(length, 3)) / (3 * youngsModulus * momentOfInertia);

            Console.WriteLine("Beam Bending Example");
            Console.WriteLine($"Force: {force} N");
            Console.WriteLine($"Length: {length} m");
            Console.WriteLine($"Moment of Inertia: {momentOfInertia} m^4");
            Console.WriteLine($"Young's Modulus: {youngsModulus} N/m^2");
            Console.WriteLine($"Maximum Deflection: {deflection} m");
        }
    }
}
