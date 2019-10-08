#include <stdio.h>

void test_4(void)
{
  volatile int i, j;

  for(i = 0; i < 10000000; i++)
    j=i;
}

void test_3(void)
{
  volatile int i, j;
  test_4();
  for(i = 0; i < 3000; i++)
    j=i;
}

void test_2(void)
{
  volatile int i, j;
  test_3();
  for(i = 0; i < 3000; i++)
    j=i;
}

void test_1(void)
{
  volatile int i, j;
  test_2();
  for(i = 0; i < 3000; i++)
    j=i;

}

int main(void)
{
  test_1();
  return 0;
}
