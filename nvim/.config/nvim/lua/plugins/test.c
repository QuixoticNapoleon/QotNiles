#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_NAME_LEN 50
#define ARRAY_SIZE 5

typedef enum {
    STUDENT,
    TEACHER,
    STAFF
} Role;

typedef struct {
    char name[MAX_NAME_LEN];
    int age;
    Role role;
    float grades[ARRAY_SIZE];
} Person;

// Function declarations
void print_person(const Person* p);
float average_grade(const Person* p);
Person* create_person(const char* name, int age, Role role);
void fill_random_grades(Person* p);
void print_all(Person** people, int count);
void free_all(Person** people, int count);
int find_oldest(Person** people, int count);

int main() {
    Person* people[ARRAY_SIZE];
    
    people[0] = create_person("Alice", 20, STUDENT);
    people[1] = create_person("Bob", 35, TEACHER);
    people[2] = create_person("Charlie", 28, STAFF);
    people[3] = create_person("Diana", 22, STUDENT);
    people[4] = create_person("Ethan", 40, TEACHER);

    for (int i = 0; i < ARRAY_SIZE; i++) {
        fill_random_grades(people[i]);
    }

    print_all(people, ARRAY_SIZE);

    int oldest_index = find_oldest(people, ARRAY_SIZE);
    printf("\nOldest person is: %s, Age: %d\n", people[oldest_index]->name, people[oldest_index]->age);

    free_all(people, ARRAY_SIZE);

    return 0;
}

void print_person(const Person* p) {
    const char* role_names[] = {"Student", "Teacher", "Staff"};
    printf("Name: %s\n", p->name);
    printf("Age: %d\n", p->age);
    printf("Role: %s\n", role_names[p->role]);
    printf("Grades: ");
    for (int i = 0; i < ARRAY_SIZE; i++) {
        printf("%.2f ", p->grades[i]);
    }
    printf("\nAverage Grade: %.2f\n\n", average_grade(p));
}

float average_grade(const Person* p) {
    float sum = 0;
    for (int i = 0; i < ARRAY_SIZE; i++) {
        sum += p->grades[i];
    }
    return sum / ARRAY_SIZE;
}

Person* create_person(const char* name, int age, Role role) {
    Person* p = (Person*)malloc(sizeof(Person));
    if (!p) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }
    strncpy(p->name, name, MAX_NAME_LEN);
    p->age = age;
    p->role = role;
    memset(p->grades, 0, sizeof(p->grades));
    return p;
}

void fill_random_grades(Person* p) {
    for (int i = 0; i < ARRAY_SIZE; i++) {
        p->grades[i] = (float)(rand() % 101); // 0 to 100
    }
}

void print_all(Person** people, int count) {
    for (int i = 0; i < count; i++) {
        print_person(people[i]);
    }
}

void free_all(Person** people, int count) {
    for (int i = 0; i < count; i++) {
        free(people[i]);
    }
}

int find_oldest(Person** people, int count) {
    int oldest_index = 0;
    for (int i = 1; i < count; i++) {
        if (people[i]->age > people[oldest_index]->age) {
            oldest_index = i;
        }
    }
    return oldest_index;
}

