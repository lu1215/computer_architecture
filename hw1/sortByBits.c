#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>

uint16_t count_leading_zeros(uint32_t x)
{
    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);

    x -= ((x >> 1) & 0x55555555);  
    x = ((x >> 2) & 0x33333333) + (x & 0x33333333);  
    x = ((x >> 4) + x) & 0x0f0f0f0f;  
    x += (x >> 8);  
    x += (x >> 16);  

    return (32 - (x & 0x3f));  
}

int counting_one(int val) {
    int num = 0;
    int len = 32 - count_leading_zeros(val);
    for(int i = 0; i <= len; i++) {
        num += val & 1;
        val >>= 1;
    }
    return num;
}

void swap(int* v1, int* v2) {
    int tmp = *v1;
    *v1 = *v2;
    *v2 = tmp;
}

int comparing(const int a, const int b) {
    int a_one = counting_one(a);
    int b_one = counting_one(b);
    return (a_one - b_one == 0) ? (a - b) : (a_one - b_one); 
}

int partition_adv(int* arr, int start, int end) {
    int pivot = arr[end];
    int idx = start;
    for(int i = start; i < end; i++) {
        if(comparing(arr[i], pivot) < 0) {
            swap(&arr[idx], &arr[i]);
            idx++;
        }
    }
    swap(&arr[idx], &arr[end]);
    return idx;
}

void quick_sort_adv(int* arr, int start, int end) {
    if(start < end) {
        int pivot = partition_adv(arr, start, end);
        quick_sort_adv(arr, start, pivot - 1);
        quick_sort_adv(arr, pivot + 1, end);
    }
}

int* sortByBits(int* arr, int arrSize, int* returnSize) {
    *returnSize = arrSize;
    quick_sort_adv(arr, 0, arrSize - 1);    
    return arr;
}

bool check_sorted(int* sorted, int* expected, int len) {
    for(int i = 0; i < len; i++) {
        if (sorted[i] != expected[i]) {
            return false;
        }
    }
    return true;
}

void run_test(int* test_data, int test_len, int* expected_data, const char* test_name) {
    int returnSize = 0;
    int* sorted = sortByBits(test_data, test_len, &returnSize);
    
    bool is_correct = check_sorted(sorted, expected_data, test_len);
    if(is_correct) {
        printf("%s: Passed\n", test_name);
    } else {
        printf("%s: Failed\n", test_name);
    }

    printf("Sorted: ");
    for (int i = 0; i < test_len; i++) {
        printf("%d ", sorted[i]);
    }
    printf("\n");
}

int main() {
    int test_data1[] = {0, 3, 4};
    int test_data1_len = 3;
    int ans_data1[] = {0, 4, 3};
    run_test(test_data1, test_data1_len, ans_data1, "Test 1");

    int test_data2[] = {16, 8, 4, 2, 1};
    int test_data2_len = 5;
    int ans_data2[] = {1, 2, 4, 8, 16};
    run_test(test_data2, test_data2_len, ans_data2, "Test 2");

    int test_data3[] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
    int test_data3_len = 9;
    int ans_data3[] = {0, 1, 2, 4, 8, 3, 5, 6, 7};
    run_test(test_data3, test_data3_len, ans_data3, "Test 3");

    return 0;
}
