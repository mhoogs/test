#include <stdio.h>
int main() 
{ int a,b,c;
	printf("enter your first number:\n");
	scanf("%d", &a);

	printf("please enter second number: \n");
	scanf("%d", &b);

	c=a+b;
	printf("The sum of your numbers %d and %d is: %d\n", a,b,c);
	return 0;
}

