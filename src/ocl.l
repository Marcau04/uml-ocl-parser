%{
    #include "ocl.tab.h"
%}
 // palabra                     [a-zA-Z]+
identificador               [a-z_][a-zA-Z0-9_]*
identificador_clase         [A-Z][a-zA-Z0-9_]*
string_lit                  [']|["]
string                      {string_lit}.*{string_lit}
dig                         [0-9]
digs                        {dig}+
float                       {digs}[.]{digs}
comparacion_unilateral      ">"|"<"
comparadores                "="|"<>"|{comparacion_unilateral}=|{comparacion_unilateral}
op_booleano                 "or"|"xor"|"and"|"implies"
op_aritmeticos              "+"|"-"|"/"|"*"
operaciones_num             "div"|"mod"|"round"|"floor"
operaciones_str             "toString"|"concat"|"toInteger"|"toReal"|"toUpperCase"|"toLowerCase"|"indexOf"|"equalsIgnoreCase"|"characters"|"toBoolean"
operacion_tipo              "oclIsTypeOf"|"oclIsKindOf"|"oclAsType"|"oclType"|"oclAsType"
operaciones_colecciones     "count"|"sum"|"isEmpty"|"notEmpty"|"includes"|"excludes"|"includesAll"|"excludesAll"|"flatten"|"allInstances"|"product"
operaciones_esp_col         "select"|"reject"|"collect"|"forAll"|"exists"|"iterate"|"selectByKind"|"selectByType"
operaciones_conjuntos       "union"|"intersection"|"including"|"excluding"|"asSequence"|"asBag"|"asSet"|"symmetricDifference"|"asOrderedSet"
operaciones_secuencias      "append"|"prepend"|"first"|"last"|"subsequence"|"reverse"|"insertAt"|"subOrderedSet"
%%

--.*\n                              yylineno ++;
--.*                                yylineno ++;
context                             return(CNTX);                            
inv                                 return(INV);
pre                                 return(PRE);
post                                return(POST);
{string}                            return(STRING);
{op_aritmeticos}                    return(OPERADOR_AR);
{op_booleano}                       return(OPERADOR_BOOLEANO);
not                                 return(NOT);
{operaciones_num}                   return(OP_NUM);
{operaciones_str}                   return(OP_STR);
{operaciones_colecciones}           return(OP_COL);
{operaciones_conjuntos}             return(OP_COL);
{operaciones_secuencias}            return(OP_COL);
{operaciones_esp_col}               return(OP_ESP_COL);
{digs}                              return(NUMERO);
{float}                             return(NUMERO);
{comparadores}                      return(CMP);
->                                  return(ARROW);
\(                                  return('(');
\)                                  return(')');
\.                                  return('.');
:                                   return(':');
,                                   return(',');
{operacion_tipo}                    return(OP_TYPE);
\|                                  return('|');
size                                return(SIZE);
at                                  return(AT);
abs                                 return(ABS);
max                                 return(MAX);
min                                 return(MIN);
oclAsSet                            return(OP_AS_SET);
{identificador}                     {strcpy(yylval.str, yytext); return(ID);}
{identificador_clase}               {strcpy(yylval.str, yytext); return(IDC);}
\n                                  yylineno ++;
[\t| |\r]
.                               

%%
