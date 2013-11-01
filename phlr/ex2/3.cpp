#include <iostream>

// sum all natural numbers in [a,b]
int sum(int a, int b)
{
	int result = 0;
	for (int i=a; i<=b; i++)
	{
		result = result + i;
	}

	return result ;
}

int main()
{
	std::cout << sum(1, 10) << std::endl;
	return 0;
}

