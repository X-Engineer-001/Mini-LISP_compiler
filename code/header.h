extern int yylex(void);
#include<stdio.h>
#include<iostream>
#include<vector>
#include<map>
using namespace std;
void yyerror(const char*message);
struct node{
    bool b;
    int i;
    string name,op;
    struct node*f;
    int type;
    vector<struct node*>*sub;
};
