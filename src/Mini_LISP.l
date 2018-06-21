%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#include "Mini_LISP.tab.h"
#include "ASTree.h"
%}
letter       [a-z] 
digit		 [0-9] 
%%
\n|[ ]|\t|\r		 { }
0|[1-9]{digit}*|-[1-9]{digit}* 		{yylval.ival = atoi(yytext); return(number);}
#t|#f							{yylval.str = strdup(yytext);  return(bool_val);}
print-num						{yylval.str = strdup(yytext);  return(print_num);}
print-bool 					{yylval.str = strdup(yytext);  return(print_bool);}
mod 							{yylval.str = strdup(yytext);  return(mod);}
and 							{yylval.str = strdup(yytext);  return(and);}
or 							{yylval.str = strdup(yytext);  return(or);}
not 							{yylval.str = strdup(yytext);  return(not);}
define 						{yylval.str = strdup(yytext);  return(define);}
fun 							{yylval.str = strdup(yytext);  return(fun);}
if							{yylval.str = strdup(yytext);  return(ift);}
{letter}({letter}|{digit}|[-])*	{yylval.str = strdup(yytext);  return(id);}
.			 {return(yytext[0]);}
%%
