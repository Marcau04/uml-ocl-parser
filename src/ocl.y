%{
    #include "lex.yy.c"
    #define MAX_SYNTAX_ERROR 10

    typedef struct {
        char* nombre;
        int nOp;
    } operacion;

    typedef struct {
        char*   nombre;
        int     inv;
        int     nOpColInv;
        int     opLength;
        operacion* operaciones;
    } clase;

    clase*          clases;
    int             errNum = 0;
    int             numClases = 0;
    int             numInv = 0;
    int             numOpInv = 0;
    
    void inClassOp(char* currentClass, char* currentOp);
    void inClass(char* clase);
    int yyerror(char *msg);
%}

//Defs
%union {
    char str[100];
    double numero;
}

%token<str> OPERADOR_AR // operador aritmetico
%token<str> OPERADOR_BOOLEANO // operador booleano
%token<numero> NUMERO
%token<str> ID // idExpresion
%token<str> IDC // idClase
%token<str> PRE // precondicion
%token<str> POST // postcondicion
%token<str> INV // invariante
%token<str> CNTX // contexto
%token<str> CMP // Comparador
%token<str> NOT //Not
%token<str> ABS
%token<str> OP_NUM
%token<str> OP_COL
%token<str> ARROW
%token<str> OP_ESP_COL
%token<str> MAX
%token<str> MIN
%token<str> STRING
%token<str> OP_TYPE
%token<str> OP_STR
%token<str> SIZE
%token<str> AT
%token<str> OP_AS_SET

%left CMP
%left OPERADOR_AR
%left OPERADOR_BOOLEANO
%left NOT

%right '.'

%%
//Reglas

programa      : contextos 
              ;

contextos     : contexto contextos
              | contexto
              | error {yyclearin; yyerrok;}
              ;

contexto      : CNTX IDC condiciones {inClass($2);}
              | CNTX IDC ':'':' ID '(' argumentos ')' ':' IDC metodosDefs {inClassOp($2, $5);}
              | CNTX IDC ':'':' ID '(' ')' ':' IDC metodosDefs {inClassOp($2, $5);}
              | CNTX IDC ':'':' ID '(' ')' metodosDefs {inClassOp($2, $5);}
              | CNTX IDC ':'':' ID '(' argumentos ')' metodosDefs {inClassOp($2, $5);}
              | CNTX IDC ':'':' ID metodosDefs {inClassOp($2, $5);}
              ;

argumentos    : argumento ',' argumentos
              | argumento
              ;

argumento     : ID ':' IDC
              ;

metodosDefs   : metodoDef metodosDefs
              | metodoDef
              ;

metodoDef     : PRE ':' expresion
              | POST ':' expresion
              ;
              
condiciones   : condicion condiciones
              | condicion
              ;

condicion     : INV ':' expresion {numInv ++;}
              ;
         
expresion     : expresion OPERADOR_AR expresion
              | expresion CMP expresion
              | expresion OPERADOR_BOOLEANO expresion
              | NOT expresion
              | posibles_cols
              | NUMERO
              | STRING
              | '(' expresion ')'
              ;

posibles_cols : IDC ':'':' identificador
              | identificador
              | operaciones
              | operaciones_col
              | operacion_esp_col
              ;

metodo_col    : OP_ESP_COL '(' argumentosExp '|' expresion ')'
              | OP_ESP_COL '(' expresion ')'
              | OP_COL '(' ')'
              | OP_COL '(' argumentosExp ')'
              | SIZE '(' ')'
              | AT '(' argumentosExp ')'
              ;

operacion_esp_col : identificador '.' metodo_col {numOpInv ++;}
                  | IDC '.' metodo_col {numOpInv ++;}
                  ;

est_op_col    : OP_COL '(' ')'
              | OP_COL '(' argumentosExp ')'
              | SIZE '(' ')'
              | AT '(' argumentosExp ')'
              | OP_ESP_COL '(' argumentosExp '|' expresion ')'
              | OP_ESP_COL '(' argumentosExp ')'
              | MAX '(' ')'
              | MIN '(' ')'
              ;

operaciones_col: operaciones_col ARROW est_op_col {numOpInv ++;}
              | operacion_col;

operacion_col : operacion_esp_col ARROW est_op_col {numOpInv ++;}
              | identificador ARROW est_op_col {numOpInv ++;}
              | posibles_cols ARROW est_op_col {numOpInv ++;}
              ;

operaciones   : operaciones '.' operacion
              | operacion
              ;

operacion     : expresion '.' operaciones_lit
              | identificador '.' operaciones_lit
              | identificador '(' ')'
              | identificador '(' argumentosExp ')'
              ;

operaciones_lit: ABS '(' ')'
              | OP_NUM '(' expresion ')'
              | OP_NUM '(' ')'
              | OP_STR '(' expresion ')'
              | OP_STR '(' ')'
              | SIZE '(' ')'
              | AT '(' expresion ')'
              | MAX '(' expresion ')'
              | MIN '(' expresion ')'
              | OP_TYPE '(' IDC ')'
              | OP_TYPE '(' ')'
              | OP_AS_SET '(' ')'
              ;

identificador : identificador '.' ID
              | ID
              ;

argumentosExp : argumentoExp ',' argumentosExp
              | argumentoExp
              ;
              
argumentoExp  : expresion
              | identificador ':' IDC
              ;
  
%%

//Rutinas 
int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }
    
    yyparse();

    printf("\n----------------------------\n\n");

    printf("\n");

    for (int i = 0; i < numClases; i ++) {
        printf("---- %s ----\n", clases[i].nombre);

        printf("\tNumero de Invariantes: %d\n", clases[i].inv);        
        printf("\tNumero de Operaciones sobre colecciones en los invariantes: %d\n", clases[i].nOpColInv);        

        for (int j = 0; j < clases[i].opLength; j ++) {
            printf("\n\t---- Operacion: %s ----\n", clases[i].operaciones[j].nombre);
            printf("\t\tNumero de Operaciones sobre colecciones en la especificacion: %d\n", clases[i].operaciones[j].nOp);
        }

        printf("\n");

    }
    
    printf("\n");
    
    for (int i = 0; i < numClases; i ++) {
        free(clases[i].operaciones);
    }

    free(clases);
}

void inClass(char* currentClass) {
    for (int i = 0; i < numClases; i ++) {
        if (strcmp(clases[i].nombre, currentClass) == 0) {
            clases[i].inv += numInv;
            clases[i].nOpColInv += numOpInv; 
            numInv = 0;
            numOpInv = 0;
            return;
        }
    }

    clases = (clase *) realloc(clases, sizeof(clase) * (numClases + 1));
    clases[numClases].nombre = (char *) malloc(sizeof(char) * strlen(currentClass) + 1);

    if (clases == NULL || clases[numClases].nombre == NULL)
        exit(-1);

    strcpy(clases[numClases].nombre, currentClass);
    clases[numClases].opLength = 0;
    clases[numClases].inv = numInv;
    clases[numClases].nOpColInv = numOpInv;
    numClases ++;
    numInv = 0;
    numOpInv = 0;
}

void inClassOp(char* currentClass, char* currentOp) {
    int claseExiste = -1;
    for (int i = 0; i < numClases; i ++) {
        if (strcmp(clases[i].nombre, currentClass) == 0) {
            claseExiste = i;
            for (int j = 0; j < clases[i].opLength; j ++) {
                if (strcmp(clases[i].operaciones[j].nombre, currentOp) == 0) {
                    clases[i].operaciones[j].nOp += numOpInv;
                    numOpInv = 0;
                }
                return;
            }
            break;
        }
    }

    if (claseExiste == -1) {
        clases = (clase *) realloc(clases, sizeof(clase) * (numClases + 1));
        clases[numClases].nombre = (char *) malloc(sizeof(char) * strlen(currentClass) + 1);

        if (clases == NULL || clases[numClases].nombre == NULL)
            exit(-1);

        strcpy(clases[numClases].nombre, currentClass);
        clases[numClases].opLength = 0;
        clases[numClases].inv = 0;
        clases[numClases].nOpColInv = 0;
        numClases ++;
    }

    int iClase = (claseExiste != -1 ? claseExiste : (numClases - 1));

    clases[iClase].operaciones = (operacion *) realloc(clases[iClase].operaciones, sizeof(operacion) * (clases[iClase].opLength + 1));

    if (clases[iClase].operaciones == NULL)
        exit(-1);

    clases[iClase].operaciones[clases[iClase].opLength].nombre = (char *) malloc(sizeof(char) * strlen(currentOp) + 1);

    if (clases[iClase].operaciones[clases[iClase].opLength].nombre == NULL)
        exit(-1);

    strcpy(clases[iClase].operaciones[clases[iClase].opLength].nombre, currentOp);
    clases[iClase].operaciones[clases[iClase].opLength].nOp = numOpInv;
    clases[iClase].opLength ++;

    numOpInv = 0;

}

int yyerror(char *msg) {
    fprintf(stderr, "Unexpected symbol '%s' in line %d\n", yytext, yylineno);
    errNum ++;

    if (errNum >= MAX_SYNTAX_ERROR) {
        fprintf(stderr, "Limite de errores alcanzado\n");
        exit(1);
    }

    return 0;
}