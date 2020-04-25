#include <cs50.h>
#include <stdio.h>

int main(void)
{
    int n;
    do
    {
        n = get_int("Positive Number: ");
    }
    while (n < 1 || n > 8);
    
    for (int i = 0; i < n; i++)
    {
        for (int j = n - i; j > 1; j--)
        {
            printf(" ");
        }
        for (int d = 0; d < i + 1; d++)
        {
            printf("#");
        }
        printf("\n");
    }
}
