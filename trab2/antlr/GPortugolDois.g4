/* Alunos:
		Gabriel Correa de Macena
		Marcus Vinicius Palassi Sales
*/

grammar GPortugolDois;

fragment DIGITO : [0-9];
fragment NAOZERO : [1-9];
fragment LETRA : [a-zA-Z];
fragment HEXA : '0'[xX](DIGITO | [a-fA-F])+; 
fragment OCTAL : '0'[cC][0-7]+;
fragment BINARIO : '0'[bB][01]+;
fragment DECIMAL : DIGITO+ ;

algoritmo
	:	declaracao_algoritmo var_decl_block? stm_block func_decls+ EOF	#AlgFuncDecl
	|	declaracao_algoritmo var_decl_block? stm_block EOF				#AlgNoFuncDecl
	;

declaracao_algoritmo 
	: 'algoritmo' IDENTIFICADOR ';'	#DeclAlg
	;

var_decl_block 
	: 'variaveis' (var_decl ';')+ 'fim_variaveis'	#VarDeclBlock
	;

var_decl 
	: IDENTIFICADOR (',' IDENTIFICADOR)* ':' (tp_primitivo | tp_matriz)	#VarDecl
	;

tp_primitivo 
	:	'logico'	#TpLogico
	|	'literal'	#TpLiteral
	|	'caractere'	#TpCaractere
	|	'real'		#TpReal
	|	'inteiro'	#TpInteiro
	;

tp_matriz 
	: 'matriz' ('[' INTEIRO ']')+ 'de' tp_prim_pl	#TpMatriz
	;

tp_prim_pl 
	:	'logicos'		#TpPlLogicos
	|	'literais'		#TpPlLiterais
	|	'caracteres'	#TpPlCaracteres
	|	'reais'			#TpPlReais
	|	'inteiros'		#TpPlInteiros
	;

stm_block
	:	'inicio' (stm_list)* 'fim'	#StmBlock
	;

stm_list 
	:	stm_para		#StmListPara
	|	stm_enquanto	#StmListEnquanto
	|	stm_se			#StmListSe
	|	stm_ret			#StmListRet
	|	fcall ';'		#StmListFCall
	|	stm_attr		#StmListAttr
	;

stm_ret
	:	'retorne' expr? ';'	#StmRet
	;

lvalue
	:	IDENTIFICADOR ('[' expr ']')*	#LValue
	;

stm_attr
	:	lvalue ':=' expr ';'	#StmAttr
	;

stm_se
	:	'se' expr 'entao' stm_list* ('senao' stm_list*)? 'fim_se'	#StmSe
	;

stm_enquanto
	:	'enquanto' expr 'faca' stm_list* 'fim_enquanto'	#StmEnquanto
	;

stm_para
	:	'para' lvalue 'de' expr 'ate' expr passo? 'faca' stm_list* 'fim_para'	#StmPara
	;

passo
	:	'passo' ('+'|'-')? INTEIRO 		#StmPasso
	;

expr
	:	('+'|'-'|'~'|'nao')? termo 		#UnaryTermo
	|	expr ('/'|'*'|'%') expr			#MulDivMod
	|	expr ('+'|'-') expr				#AddSub
	|	expr ('>'|'>='|'<'|'<=') expr	#BiggerLessEqual
	|	expr ('='|'<>') expr			#EqualDiff
	|	expr '&' expr					#BitwiseAND
	|	expr '^' expr					#BitwiseXOR
	|	expr '|' expr					#BitwiseOR
	|	expr ('e'|'&&') expr			#LogicalAND
	|	expr ('ou'|'||') expr			#LogicalOR
	;

termo
	:	'(' expr ')'	#ParenthesisExpr
	|	literal 		#LiteralTerm
	|	lvalue 			#LValueTerm
	|	fcall 			#FCallTerm
	;

fcall
	:	IDENTIFICADOR '(' fargs? ')'	#FCall
	;

fargs
	:	expr (',' expr)*	#FArgs
	;

literal
	:	T_KW_FALSO		#LitFalso
	|	T_KW_VERDADEIRO	#LitVerdadeiro
	|	CARACTERE 		#LitCaractere
	|	REAL 			#LitReal
	|	INTEIRO 		#LitInteiro
	|	STRING 			#LitString
	;

func_decls
	:	'funcao' IDENTIFICADOR '(' fparams? ')' (':' tp_primitivo)? fvar_decl stm_block		#FuncDecls
	;

fvar_decl
	:	(var_decl ';')*		#FVarDecl
	;

fparams
	:	fparam (',' fparam)*	#FParams
	;

fparam
	:	IDENTIFICADOR ':' (tp_primitivo | tp_matriz) 	#FParam
	;

COMENTARIO_LINHA : '//' .*? '\n' -> skip;
COMENTARIO_BLOCO : '/*' .*? '*/' -> skip;

T_KW_VERDADEIRO: 'verdadeiro';

T_KW_FALSO: 'falso';

OP_LOGICO : 'e'|'ou'|'nao'; 

OP_ARITMETICO : '+'| '-' |'*'|'/'|'%'|'++'|'--' ; 

OP_RELACIONAL : '<'|'<='|'>'|'>='|'='|'<>' ;

RESERVADA : 
		'fim_variaveis' | 'algoritmo' | 'variaveis' | 'inteiro' 's'? 
		| 'rea'('l'|'is')|'caractere' 's'? | 'litera'('l'|'is') | 'logico' 's'? 
		| 'inicio' | 'fim' | 'se' | 'senao' | 'entao' 
		| 'fim_'('se'|'enquanto'|'para') | 'enquanto' | 'faca' |'para' | 'de' 
		| 'ate' | 'matriz' | 'funcao' | 'retorne' | 'passo'
		;

INTEIRO : HEXA | OCTAL | BINARIO | DECIMAL ; 

REAL : DECIMAL '.' DECIMAL+ ; 

CARACTERE : '\''(~('\'' | '\\')|'\\'.)?'\'' ; 

STRING : '"' (~('"' | '\\' | '\n' | '\r')|'\\'.)* '"' ; 

IDENTIFICADOR : (LETRA | '_')(LETRA | DIGITO | '_')*; 

ATRIBUICAO : ':=' ; 

ESPECIAL : '('|')'|'['|']'|';'|','|':';
WS : [ \t\r\n]+ -> skip;

UNKNOWN : . ;