%{
    #include "header.h"
    #include "Final.tab.h"
%}
%%
[\t\n\r\s ] {}
"mod" {string s=yytext;struct node*t=new node();t->op=s;t->type=3;yylval.n=t;return(MOD);}
"and" {string s=yytext;struct node*t=new node();t->op=s;t->type=3;yylval.n=t;return(AND);}
"or" {string s=yytext;struct node*t=new node();t->op=s;t->type=3;yylval.n=t;return(OR);}
"not" {string s=yytext;struct node*t=new node();t->op=s;t->type=3;yylval.n=t;return(NOT);}
"define" {string s=yytext;struct node*t=new node();t->op=s;t->type=3;yylval.n=t;return(DEFINE);}
"fun" {string s=yytext;struct node*t=new node();t->op=s;t->type=3;yylval.n=t;return(FUN);}
"if" {string s=yytext;struct node*t=new node();t->op=s;t->type=3;yylval.n=t;return(IF);}
"print-num" {string s=yytext;struct node*t=new node();t->op=s;t->type=3;yylval.n=t;return(PNUM);}
"print-bool" {string s=yytext;struct node*t=new node();t->op=s;t->type=3;yylval.n=t;return(PBOOL);}
[+-/<>=()] {string s=yytext;struct node*t=new node();t->op=s;t->type=3;yylval.n=t;return(yytext[0]);}
[*] {string s=yytext;struct node*t=new node();t->op=s;t->type=3;yylval.n=t;return(yytext[0]);}
"0"|(-?[1-9][0-9]*) {struct node*t=new node();sscanf(yytext,"%d",&(t->i));t->type=1;yylval.n=t;return(NUM);}
[a-z][a-z0-9-]* {struct node*t=new node();t->name=yytext;t->type=2;yylval.n=t;return(ID);}
"#t" {struct node*t=new node();t->b=true;t->type=0;yylval.n=t;return(BOOL);}
"#f" {struct node*t=new node();t->b=false;t->type=0;yylval.n=t;return(BOOL);}
. {cout<<"syntax error";return(0);}
%%

