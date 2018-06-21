%{
//'P' global varible. 'p' local varible.
#include <stdio.h>
#include <string.h>
#include "ASTree.h"
void yyerror(const char *message);
struct ast_define_node* main_define;
void pass_parameter(struct ast_node* var, struct ast_node* para, int mode);
%}
%union {
	int ival;
	char* str;
	struct ast_PARAMETER_node * left;
	struct ast_node * ast;
}
%token <ival> number
%token <str> id
%token <str> bool_val print_num print_bool mod and or not define fun ift
%type <ast> EXP NUM_OP FUN_BODY FUN_CALL PARAM LAST_EXP IF_EXP TEST_EXP THEN_EXP ELSE_EXP PROGRAM STMT PRINT_STMT DEF_STMT FUN_EXP STMTs EXPs 
%type <ast> PLUS MINUS MULTIPLY DIVIDE MODULUS 
%type <ast> GREATER SMALLER EQUAL LOGICAL_OP AND_OP OR_OP NOT_OP 
%type <ast> VARIABLE FUN_IDs FUN_NAME ids
%left '+' '-' 
%left '^' 
%left '(' ')'
%%
PROGRAM  	: STMTs {}
;
STMTs		: STMT {} 
			| STMT STMTs {}
;
STMT  		: EXP {}
			| DEF_STMT { struct ast_define_node* next_define; ((struct ast_define_node *)$1)->next = main_define->next; main_define->next = $1; }
			| PRINT_STMT {}
;
PRINT_STMT 	: '(' print_num EXP ')' { printf("%d\n", converseAST($3));}
			| '(' print_bool EXP ')' { if(converseAST($3) == 1){printf("#t\n");}else{printf("#f\n");}}
;
EXPs		: EXP {								$$ = $1;}
			| EXP EXPs {						$$ = new_ast_node('R', $1, $2, NULL, 0, NULL);}
;
EXP 		: bool_val {						$$ = new_ast_bool_node($1);}
			| number {							$$ = new_ast_number_node($1); }
			| VARIABLE {	$$ = $1;}
			| NUM_OP {							$$ = $1; }
			| LOGICAL_OP {						$$ = $1; }
			| FUN_EXP  {	$$ = $1; }
			| FUN_CALL {	$$ = $1; }
			| IF_EXP {					 		$$ = $1; }
;
NUM_OP  	: PLUS {							$$ = $1; }
			| MINUS {							$$ = $1; }
			| MULTIPLY {						$$ = $1; }
			| DIVIDE {							$$ = $1; }
			| MODULUS {							$$ = $1; }
			| GREATER {							$$ = $1; }
			| SMALLER {							$$ = $1; }
			| EQUAL {							$$ = $1; }
;
	PLUS  	: '(' '+'  EXP EXPs ')' 			{$$ = new_ast_node('+', $3, $4, NULL, 0, NULL);}
;
	MINUS  	: '(' '-' EXP EXP ')' 				{$$ = new_ast_node('-', $3, $4, NULL, 0, NULL);}
;
	MULTIPLY: '(' '*' EXP EXPs ')' 				{$$ = new_ast_node('*', $3, $4, NULL, 0, NULL);}
;
	DIVIDE  : '(' '/' EXP EXP ')' 				{$$ = new_ast_node('/', $3, $4, NULL, 0, NULL);}
;
	MODULUS : '(' mod EXP EXP ')' 				{$$ = new_ast_node('m', $3, $4, NULL, 0, NULL);}
;
	GREATER : '(' '>' EXP EXP ')' 				{$$ = new_ast_node('>', $3, $4, NULL, 0, NULL);}
;
	SMALLER : '(' '<' EXP EXP ')' 				{$$ = new_ast_node('<', $3, $4, NULL, 0, NULL);}
;
	EQUAL  	: '(' '=' EXP EXPs ')'				{$$ = new_ast_node('=', $3, $4, NULL, 0, NULL);}
;
LOGICAL_OP  : AND_OP {							$$ = $1; }
			| OR_OP {							$$ = $1; }
			| NOT_OP {							$$ = $1; }
;
	AND_OP  : '(' and EXP EXPs ')'				{$$ = new_ast_node('a', $3, $4, NULL, 0, NULL);}
;
	OR_OP  	: '(' or EXP EXPs ')'				{$$ = new_ast_node('o', $3, $4, NULL, 0, NULL);}
;
	NOT_OP  : '(' not EXP ')'					{$$ = new_ast_node('n', $3, NULL, NULL, 0, NULL);}
;
DEF_STMT 	: '(' define id EXP ')' 		{ $$ = new_ast_define_node($3, $4, NULL);}
;

VARIABLE	: id 								{$$ = new_ast_parameter_node($1, 'P');}
;
FUN_EXP 	: '(' fun FUN_IDs FUN_BODY ')' 		{$$ = new_ast_node('F', $3, $4, NULL, 0, NULL);}
;
;	FUN_IDs : '(' ids ')'						{$$ = $2;}

	ids 	: id ids 							{$1 = new_ast_parameter_node($1, 'p'); $$ = new_ast_node('R', $1, $2, NULL, 0, NULL);}
			| id 								{$$ = new_ast_parameter_node($1, 'p');}
;
	FUN_BODY: EXP 								{$$ = $1;}
;
FUN_CALL	: '(' FUN_EXP PARAM ')' {$2->condition = $3; $$ = $2;}
			| '(' FUN_NAME PARAM ')' {$$ = new_ast_node('P', NULL, NULL, $3, 0, $2); }
;
	PARAM  	: EXPs 								{$$ = $1;}
;
	LAST_EXP: EXP								{$$ = $1;}
;
	FUN_NAME: id 								{$$ = $1;}
;
IF_EXP  	: '(' ift TEST_EXP THEN_EXP ELSE_EXP')'  {$$ = new_ast_node('I', $4, $5, $3, 0, NULL);}
;
	TEST_EXP: EXP 								{$$ = $1;}
;
	THEN_EXP: EXP 								{$$ = $1;}
;
	ELSE_EXP: EXP 								{$$ = $1;}
;
%%
void yyerror (const char *message)
{
        fprintf(stderr, "%s\n",message);
}
int converseAST(struct ast_node* node){
	if (node == NULL) return 0;
	if (node->node_type == 'N'){
		return ((struct ast_number_node *)node)->value;
	}
	if (node->node_type == 'p'){ 
		return ((struct ast_parameter_node *)node)->value;
	}
	if (node->node_type == 'B') {
		if ( strcmp( ((struct ast_bool_node *)node)->value, "#f") == 0) return 0;
		else return 1;
	}
	if (node->node_type == 'P'){
		struct ast_define_node * find_define;
		find_define = main_define->next;
		while(find_define != NULL){
			if ( strcmp( ((struct ast_parameter_node *)node)->name, find_define->name) == 0){
				int value;
				value = converseAST(find_define->function);
				return value;
			}
			find_define = find_define->next;
		}
		return 0;
	}
	if (node->left != NULL && node->left->node_type == 'R') node->left->node_type = node->node_type;
	if (node->right != NULL && node->right->node_type == 'R') node->right->node_type = node->node_type;
	if (node->node_type == '+'){
printf("+++");
		int left, right, sum;
		left = converseAST(node->left);
		right = converseAST(node->right);
		sum = left + right;
		return sum;
	}
	if (node->node_type == '-'){
		int left, right, sum;
		left = converseAST(node->left);
		right = converseAST(node->right);
		sum = left - right;
		return sum;
	}
	if (node->node_type == '*'){
		int left, right, sum;
		left = converseAST(node->left);
		right = converseAST(node->right);
		sum = left * right;
		return sum;
	}
	if (node->node_type == '/'){
		int left, right, sum;
		left = converseAST(node->left);
		right = converseAST(node->right);
		sum = left / right;
		return sum;
	}
	if (node->node_type == 'm'){
		int left, right, sum;
		left = converseAST(node->left);
		right = converseAST(node->right);
		sum = left % right;
		return sum;
	}
	if (node->node_type == '>'){
		int left, right, sum;
		left = converseAST(node->left);
		right = converseAST(node->right);
		if (left > right) return 1;
		return 0;
	}
	if (node->node_type == '<'){
		int left, right, sum;
		left = converseAST(node->left);
		right = converseAST(node->right);
		if (left < right) return 1;
		return 0;
	}
	if (node->node_type == '='){
		int left, right, sum;
		left = converseAST(node->left);
		right = converseAST(node->right);
		if (left == right) return 1;
		return 0;
	}
	if (node->node_type == 'a'){
		int left, right, sum;
		left = converseAST(node->left);
		right = converseAST(node->right);
		if (left + right == 2) return 1;
		return 0;
	}
	if (node->node_type == 'o'){
		int left, right, sum;
		left = converseAST(node->left);
		right = converseAST(node->right);
		if (left + right >= 1) return 1;
		return 0;
	}
	if (node->node_type == 'n'){
		int left, right, sum;
		left = converseAST(node->left);
		right = converseAST(node->right);
		if (left == 0) return 1;
		return 0;
	}
	if (node->node_type == 'I'){
		int left, right, condition;
		condition = converseAST(node->condition);
		if (condition == 1){
			left = converseAST(node->left);
			return left;
		}else{
			right = converseAST(node->right);
			return right;
		}
		return 0;
	}
	if (node->node_type == 'F'){
		pass_parameter(node->left, node->condition, 1);
		pass_parameter(node->left, node->right, 2);
		int result;
		result = converseAST(node->right);
		return result;
	}
	return 0;
}
//mode == 1 : pass para into function   
//mode == 2 : set var value into function's var value to calculate
//mode == 3 : function ASTree find var to change value
void pass_parameter(struct ast_node* var, struct ast_node* para, int mode){
	if (mode == 1){
		if ( ((struct ast_node*)var)->left != NULL && ((struct ast_node*)para)->left != NULL){
			pass_parameter(var->left, para->left, mode);
		}
		if ( ((struct ast_node*)var)->right != NULL && ((struct ast_node*)para)->right != NULL){
			pass_parameter(var->right, para->right, mode);
		}
		if (var->node_type == 'p'){
			((struct ast_parameter_node *)var)->value = ((struct ast_number_node *)para)->value;
		}
	}else if(mode == 2){
		if ( ((struct ast_node*)var)->node_type != 'p'){
			pass_parameter(var->left, para, mode);
		}
		if ( ((struct ast_node*)var)->node_type != 'p'){
			pass_parameter(var->right, para, mode);
		}
		pass_parameter(var, para, 3);
	}else if(mode == 3){
		if ( ((struct ast_node*)para)->node_type != 'P' && ((struct ast_node*)para)->node_type != 'N'){
			pass_parameter(var, para->left, mode);
		}
		if ( ((struct ast_node*)para)->node_type != 'P' && ((struct ast_node*)para)->node_type != 'N'){
			pass_parameter(var, para->right, mode);
		}
		if ( ((struct ast_parameter_node *)para)->name != NULL && strcmp( ((struct ast_parameter_node *)var)->name, ((struct ast_parameter_node *)para)->name) == 0){
			((struct ast_parameter_node *)para)->node_type = 'p';
			((struct ast_parameter_node *)para)->value = ((struct ast_parameter_node *)var)->value;
		}
	}
}
struct ast_node * 
new_ast_node (int node_type, struct ast_node* left, struct ast_node* right, struct ast_node* condition, int value, char* name){
  struct ast_node * ast_node = malloc(sizeof (struct ast_node));
  ast_node->node_type = node_type;
  ast_node->value = value;
  ast_node->name = name;
  ast_node->left = left;
  ast_node->right = right;
  ast_node->condition = condition;
  return (struct ast_node *) ast_node;

}
struct ast_node * 
new_ast_bool_node (char* value){
  struct ast_bool_node * ast_node = malloc(sizeof (struct ast_bool_node));
  ast_node->node_type = 'B';
  ast_node->value = value;
  return (struct ast_node *) ast_node;

}
struct ast_node * 
new_ast_number_node (int value){
  struct ast_number_node * ast_node = malloc(sizeof (struct ast_number_node));
  ast_node->node_type = 'N';
  ast_node->value = value;
  return (struct ast_node *) ast_node;
}
struct ast_node * 
new_ast_parameter_node (char* name, int node_type){
  struct ast_parameter_node * ast_node = malloc(sizeof (struct ast_parameter_node));
  ast_node->node_type = node_type;
  ast_node->name = name;
  ast_node->value = 0;
  return (struct ast_node *) ast_node;
}
struct ast_node * 
new_ast_logic_node (int node_type, char* value, struct ast_node* left, struct ast_node* right){
  struct ast_logic_node * ast_node = malloc(sizeof (struct ast_logic_node));
  ast_node->value = value;
  ast_node->node_type = node_type;
  ast_node->left = left;
  ast_node->right = right;
  return (struct ast_node *) ast_node;

}
struct ast_node * 
new_ast_if_node (struct ast_node * condition, struct ast_node * if_branch, struct ast_node * else_branch){
  struct ast_if_node * ast_node = malloc(sizeof (struct ast_if_node));
  ast_node->node_type = 'I';
  ast_node->condition = condition;
  ast_node->if_branch = if_branch;
  ast_node->else_branch = else_branch;
  return (struct ast_node *) ast_node;
}
struct ast_define_node * 
new_ast_define_node (char* name, struct ast_node * function, struct ast_define_node * next){
  struct ast_define_node * ast_node = malloc(sizeof (struct ast_define_node));
  ast_node->node_type = 'D';
  ast_node->name = name;
  ast_node->next = next;
  ast_node->function = function;
  return (struct ast_node *) ast_node;
}
struct ast_node * 
new_ast_function_node (struct ast_node * arguments, struct ast_node * function_body){
  struct ast_function_node * ast_node = malloc(sizeof (struct ast_function_node));
  ast_node->node_type = 'F';
  ast_node->arguments = arguments;
  ast_node->function_body = function_body;
  return (struct ast_node *) ast_node;
}

int main(int argc, char *argv[]) {
		main_define = malloc(sizeof(struct ast_define_node));
        yyparse();
        return(0);
}