#include <cs50.h>
#include <stdio.h>
#include <math.h>

int main(void)
{
    float change;

    int coins = 0;
    int quantity;

    do
    {
        change = get_float("How much change is owed?");
    }
    while (change < 0);

    quantity = round(change * 100.00);

    while (quantity >= 25)
    {
        quantity -= 25;
        coins ++;
    }

    while (quantity >= 10)
    {
        quantity -= 10;
        coins++;
    }

    while (quantity >= 5)
    {
        quantity -= 5;
        coins++;
    }

    while (quantity >= 1)
    {
        quantity -= 1;
        coins++;
    }

    printf("%i\n", coins);
}
