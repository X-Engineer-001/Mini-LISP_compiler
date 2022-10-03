%{
    #include "header.h"
    string reserved[18]={"+","-","*","/","mod",">","<","=","and","or","not","define","fun","if","print-num","print-bool","(",")"};
    vector<map<string,struct node*> > var (1,map<string,struct node*>());
    struct node*root=NULL;
    string error="";
    struct node* run(struct node*p);
%}
%union{
    struct node*n;
    vector<struct node*>*ns;
}
%token <n> NUM ID BOOL '+' '-' '*' '/' MOD '>' '<' '=' AND OR NOT DEFINE FUN IF PNUM PBOOL '(' ')'
%type <n> STMT EXP DEF PRINT NUMOP LOGIC FUNEXP FUNCALL IFEXP
%type <ns> IDS EXPS DEFS
%%
PROGRAM :STMTS {}
        ;
STMTS   :STMT {}
        |STMTS STMT {}
        ;
STMT    :DEF {$$=$1;root=$$;struct node*result=run(root);if(result->type<0){cout<<error;YYERROR;}}
        |EXP {$$=$1;root=$$;struct node*result=run(root);if(result->type<0){cout<<error;YYERROR;}}
        |PRINT {$$=$1;root=$$;struct node*result=run(root);if(result->type<0){cout<<error;YYERROR;}}
        ;
PRINT   :'(' PNUM EXPS ')' {if($3->size()!=1){cout<<"operand quantity error: expected 1\n";YYERROR;}else{struct node*t=$2;t->sub=$3;$$=t;}}
        |'(' PBOOL EXPS ')' {if($3->size()!=1){cout<<"operand quantity error: expected 1\n";YYERROR;}else{struct node*t=$2;t->sub=$3;$$=t;}}
        ;
EXP     :BOOL {$$=$1;}
        |NUM {$$=$1;}
        |ID {$$=$1;}
        |NUMOP {$$=$1;}
        |LOGIC {$$=$1;}
        |FUNEXP {$$=$1;}
        |FUNCALL {$$=$1;}
        |IFEXP {$$=$1;}
        ;
NUMOP   :'(' '+' EXPS ')' {if($3->size()<2){cout<<"operand quantity error: expected at least 2\n";YYERROR;}else{struct node*t=$2;t->sub=$3;$$=t;}}
        |'(' '-' EXPS ')' {if($3->size()!=2){cout<<"operand quantity error: expected 2\n";YYERROR;}else{struct node*t=$2;t->sub=$3;$$=t;}}
        |'(' '*' EXPS ')' {if($3->size()<2){cout<<"operand quantity error: expected at least 2\n";YYERROR;}else{struct node*t=$2;t->sub=$3;$$=t;}}
        |'(' '/' EXPS ')' {if($3->size()!=2){cout<<"operand quantity error: expected 2\n";YYERROR;}else{struct node*t=$2;t->sub=$3;$$=t;}}
        |'(' MOD EXPS ')' {if($3->size()!=2){cout<<"operand quantity error: expected 2\n";YYERROR;}else{struct node*t=$2;t->sub=$3;$$=t;}}
        |'(' '>' EXPS ')' {if($3->size()!=2){cout<<"operand quantity error: expected 2\n";YYERROR;}else{struct node*t=$2;t->sub=$3;$$=t;}}
        |'(' '<' EXPS ')' {if($3->size()!=2){cout<<"operand quantity error: expected 2\n";YYERROR;}else{struct node*t=$2;t->sub=$3;$$=t;}}
        |'(' '=' EXPS ')' {if($3->size()<2){cout<<"operand quantity error: expected at least 2\n";YYERROR;}else{struct node*t=$2;t->sub=$3;$$=t;}}
        ;
LOGIC   :'(' AND EXPS ')' {if($3->size()<2){cout<<"operand quantity error: expected at least 2\n";YYERROR;}else{struct node*t=$2;t->sub=$3;$$=t;}}
        |'(' OR EXPS ')' {if($3->size()<2){cout<<"operand quantity error: expected at least 2\n";YYERROR;}else{struct node*t=$2;t->sub=$3;$$=t;}}
        |'(' NOT EXPS ')' {if($3->size()!=1){cout<<"operand quantity error: expected 1\n";YYERROR;}else{struct node*t=$2;t->sub=$3;$$=t;}}
        ;
DEF     :'(' DEFINE IDS EXPS ')' {if($3->size()!=1||$4->size()!=1){cout<<"operand quantity error: expected 1 name and 1 expression\n";YYERROR;}else{struct node*t=$2;t->sub=$3;t->sub->push_back((struct node*)$4->front());$$=t;}}
        ;
FUNEXP  :'(' FUN '(' IDS ')' EXPS ')' {if($6->size()!=1){cout<<"operand quantity error: expected 1 function evaluation body\n";YYERROR;}else{struct node*t=new node();t->type=4;t->f=(struct node*)$6->front();t->sub=$4;$$=t;}}
        |'(' FUN '(' ')' EXPS ')' {if($5->size()!=1){cout<<"operand quantity error: expected 1 function evaluation body\n";YYERROR;}else{struct node*t=new node();t->type=4;t->f=(struct node*)$5->front();t->sub=new vector<struct node*>();$$=t;}}
        |'(' FUN '(' IDS ')' DEFS EXPS ')' {if($7->size()!=1){cout<<"operand quantity error: expected 1 function evaluation body\n";YYERROR;}else{struct node*t=new node();t->type=4;t->f=(struct node*)$7->front();t->sub=$4;t->sub->insert(t->sub->end(),$6->begin(),$6->end());$$=t;}}
        |'(' FUN '(' ')' DEFS EXPS ')' {if($6->size()!=1){cout<<"operand quantity error: expected 1 function evaluation body\n";YYERROR;}else{struct node*t=new node();t->type=4;t->f=(struct node*)$6->front();t->sub=$5;$$=t;}}
        ;
FUNCALL :'(' FUNEXP EXPS ')' {struct node*t=new node();t->type=3;t->op="call";t->sub=$3;t->sub->push_back($2);$$=t;}
        |'(' FUNEXP ')' {struct node*t=new node();t->type=3;t->op="call";t->sub=new vector<struct node*>();t->sub->push_back($2);$$=t;}
        |'(' IDS EXPS ')' {if($2->size()!=1){cout<<"operand quantity error: expected 1 function name\n";YYERROR;}else{struct node*t=new node();t->type=3;t->op="call";t->sub=$3;t->sub->push_back((struct node*)$2->front());$$=t;}}
        |'(' IDS ')' {if($2->size()!=1){cout<<"operand quantity error: expected 1 function name\n";YYERROR;}else{struct node*t=new node();t->type=3;t->op="call";t->sub=new vector<struct node*>();t->sub->push_back((struct node*)$2->front());$$=t;}}
        ;
IFEXP   :'(' IF EXPS ')' {if($3->size()!=3){cout<<"operand quantity error: expected 3\n";YYERROR;}else{struct node*t=$2;t->sub=$3;$$=t;}}
        ;
IDS     :ID {vector<struct node*>*t=new vector<struct node*>();t->push_back($1);$$=t;}
        |IDS ID {vector<node*>*t=$1;t->push_back($2);$$=t;}
        ;
EXPS    :EXP {vector<struct node*>*t=new vector<struct node*>();t->push_back($1);$$=t;}
        |EXPS EXP {vector<node*>*t=$1;t->push_back($2);$$=t;}
        ;
DEFS    :DEF {vector<struct node*>*t=new vector<struct node*>();t->push_back($1);$$=t;}
        |DEFS DEF {vector<node*>*t=$1;t->push_back($2);$$=t;}
%%
void yyerror(const char*message){
    cout<<"syntax error\n";
}
struct node* run(struct node*p){
    if(p->type==3){
        vector<struct node*> values=*(p->sub);
        struct node*t=new node();
        string o=p->op;
        if(o=="+"){
            t->type=1;
            t->i=0;
            for(int i=0;i<values.size();i++){
                struct node*result=run(values[i]);
                if(result->type==1){
                    t->i+=result->i;
                }else{
                    if(error==""){
                        error="type error: expected numbers\n";
                    }
                    break;
                }
            }
        }else if(o=="-"){
            struct node*result1=run(values[0]);
            struct node*result2=run(values[1]);
            if(result1->type==1&&result2->type==1){
                t->type=1;
                t->i=result1->i-result2->i;
            }else{
                if(error==""){
                    error="type error: expected numbers\n";
                }
            }
        }else if(o=="*"){
            t->type=1;
            t->i=1;
            for(int i=0;i<values.size();i++){
                struct node*result=run(values[i]);
                if(result->type==1){
                    t->i*=result->i;
                }else{
                    if(error==""){
                        error="type error: expected numbers\n";
                    }
                    break;
                }
            }
        }else if(o=="/"){
            struct node*result1=run(values[0]);
            struct node*result2=run(values[1]);
            if(result1->type==1&&result2->type==1){
                t->type=1;
                t->i=result1->i/result2->i;
            }else{
                if(error==""){
                    error="type error: expected numbers\n";
                }
            }
        }else if(o=="mod"){
            struct node*result1=run(values[0]);
            struct node*result2=run(values[1]);
            if(result1->type==1&&result2->type==1){
                t->type=1;
                t->i=result1->i%result2->i;
            }else{
                if(error==""){
                    error="type error: expected numbers\n";
                }
            }
        }else if(o==">"){
            struct node*result1=run(values[0]);
            struct node*result2=run(values[1]);
            if(result1->type==1&&result2->type==1){
                t->type=0;
                if(result1->i>result2->i){
                    t->b=true;
                }else{
                    t->b=false;
                }
            }else{
                if(error==""){
                    error="type error: expected numbers\n";
                }
            }
        }else if(o=="<"){
            struct node*result1=run(values[0]);
            struct node*result2=run(values[1]);
            if(result1->type==1&&result2->type==1){
                t->type=0;
                if(result1->i<result2->i){
                    t->b=true;
                }else{
                    t->b=false;
                }
            }else{
                if(error==""){
                    error="type error: expected numbers\n";
                }
            }
        }else if(o=="="){
            struct node*result0=run(values[0]);
            if(result0->type==1){
                t->type=0;
                t->b=true;
                int base=result0->i;
                for(int i=1;i<values.size();i++){
                    struct node*result=run(values[i]);
                    if(result->type==1){
                        if(result->i!=base){
                            t->b=false;
                            break;
                        }
                    }else{
                        if(error==""){
                            error="type error: expected numbers\n";
                        }
                        break;
                    }
                }
            }else{
                if(error==""){
                    error="type error: expected numbers\n";
                }
            }
        }else if(o=="and"){
            t->type=0;
            t->b=true;
            for(int i=0;i<values.size();i++){
                struct node*result=run(values[i]);
                if(result->type==0){
                    if(!(result->b)){
                        t->b=false;
                        break;
                    }
                }else{
                    if(error==""){
                        error="type error: expected booleans\n";
                    }
                    break;
                }
            }
        }else if(o=="or"){
            t->type=0;
            t->b=false;
            for(int i=0;i<values.size();i++){
                struct node*result=run(values[i]);
                if(result->type==0){
                    if(result->b){
                        t->b=true;
                        break;
                    }
                }else{
                    if(error==""){
                        error="type error: expected booleans\n";
                    }
                    break;
                }
            }
        }else if(o=="not"){
            struct node*result=run(values[0]);
            if(result->type==0){
                t->type=0;
                t->b=!(result->b);
            }else{
                if(error==""){
                    error="type error: expected boolean\n";
                }
            }
        }else if(o=="define"){
            struct node*result1=values[0];
            struct node*result2=run(values[1]);
            if(result1->type==2&&(result2->type==0||result2->type==1||result2->type==4)){
                string id=result1->name;
                if(var.back()[id]){
                    if(error==""){
                        error="redefine error: "+id+"\n";
                    }
                }else{
                    var.back()[id]=result2;
                    t=result2;
                }
            }else{
                if(error==""){
                    error="type error: expected 1 name and 1 variable\n";
                }
            }
        }else if(o=="call"){
            struct node*resultF=run(values.back());
            if(resultF->type==4){
                map<string,struct node*> localVar;
                vector<struct node*> localList=*(resultF->sub);
                int i;
                for(i=0;i<values.size()-1;i++){
                    struct node*result=run(values[i]);
                    if(result->type==0||result->type==1){
                        if(localList[i]->type==2){
                            localVar[localList[i]->name]=result;
                        }else{
                            if(error==""){
                                error="parameter quantity unmatched error\n";
                            }
                            break;
                        }
                    }else{
                        if(error==""){
                            error="type error: expected number or boolean\n";
                        }
                        break;
                    }
                }
                if(error==""){
                    var.push_back(localVar);
                    for(;i<localList.size();i++){
                        if(localList[i]->type==3){
                            run(localList[i]);
                        }else{
                            if(error==""){
                                error="parameter quantity unmatched error\n";
                            }
                            break;
                        }
                    }
                    struct node*result=run(resultF->f);
                    if(result->type==0||result->type==1){
                        t=result;
                    }else{
                        if(error==""){
                            error="type error: expected number or boolean\n";
                        }
                    }
                    var.pop_back();
                }
            }else{
                if(error==""){
                    error="type error: expected function\n";
                }
            }
        }else if(o=="if"){
            struct node*resultBOOL=run(values[0]);
            if(resultBOOL->type==0){
                if(resultBOOL->b){
                    struct node*resultTRUE=run(values[1]);
                    if(resultTRUE->type<0){
                        if(error==""){
                            error="type error: expected expression\n";
                        }
                    }else{
                        t=resultTRUE;
                    }
                }else{
                    struct node*resultFALSE=run(values[2]);
                    if(resultFALSE->type<0){
                        if(error==""){
                            error="type error: expected expression\n";
                        }
                    }else{
                        t=resultFALSE;
                    }
                }
            }else{
                if(error==""){
                    error="type error: expected boolean\n";
                }
            }
        }else if(o=="print-num"){
            struct node*result=run(values[0]);
            if(result->type==1){
                cout<<result->i<<endl;
                t=result;
            }else{
                if(error==""){
                    error="type error: expected number\n";
                }
            }
        }else if(o=="print-bool"){
            struct node*result=run(values[0]);
            if(result->type==0){
                if(result->b){
                    cout<<"#t"<<endl;
                }else{
                    cout<<"#f"<<endl;
                }
                t=result;
            }else{
                if(error==""){
                    error="type error: expected boolean\n";
                }
            }
        }
        if(error!=""){
            t->type=-1;
        }
        return t;
    }else if(p->type==2){
        for(int i=var.size()-1;i>=0;i--){
            if(var[i][p->name]){
                return var[i][p->name];
            }
        }
        if(error==""){
            error="symbol undefined error: "+p->name+"\n";
        }
        struct node*t=new node();
        t->type=-1;
        return t;
    }else{
        return p;
    }
}
int main(){
    yyparse();
    return 0;
}
