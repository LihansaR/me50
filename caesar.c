#include <stdio.h>
#include <cs50.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

int upperbound(char c);

int main(int argc, string argv[])
{
    if (argc == 2)
    {
        int digits = strlen(argv[1]);
        bool isnum = true;

        for (int i = 0; i < digits; i++)
        {
            if (isdigit(argv[1][i]) == 0)
            {
                isnum = false;
                //printf("isnum %i false", i);
                break;
            }
        }

        if (isnum == true)
        {
            int rotateby = atoi(argv[1]) % 26;
            string plaintext = get_string("plaintext: ");
            int charcount = strlen(plaintext);
            char ciphertext[charcount + 1];
            ciphertext[charcount] = '\0';

            for (int i = 0; i < charcount; i++)
            {
                if (isalpha(plaintext[i]) != 0 && (int) plaintext[i] + rotateby <= upperbound(plaintext[i]))
                {
                    ciphertext[i] = (char)((int) plaintext[i] + rotateby);
                }
                else if (isalpha(plaintext[i]) != 0 && (int) plaintext[i] + rotateby > upperbound(plaintext[i]))
                {
                    ciphertext[i] = (char)((int) plaintext[i] + rotateby - 26);
                }
                else
                {
                    ciphertext[i] = plaintext[i];
                }
            }
            printf("ciphertext:%s\n", ciphertext);
            return 0;
        }
        else
        {
            printf("Usage: ./caesar key\n");
            return 1;
        }
    }
    else
    {
        printf("please provide us with ONE argument.\n");
        return 1;
    }
}

int upperbound(char c)
{
    if (isupper(c) == 0)
    {
        return 122;
    }
    else
    {
        return 90;
    }
}