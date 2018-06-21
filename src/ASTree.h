struct ast_node
{
  int node_type;
  int value;
  char* name;
  struct ast_node * left;
  struct ast_node * right;
  struct ast_node * condition;
};

struct ast_bool_node
{
  int node_type;
  char* value;
};

struct ast_number_node
{
  int node_type;
  int value;
};

struct ast_parameter_node
{
  int node_type;
  char* name;
  int value;
};

struct ast_logic_node
{
  int node_type;
  char* value;
  struct ast_node* left;
  struct ast_node* right;
};

struct ast_if_node
{
  int node_type;

  struct ast_node * condition; 
  struct ast_node * if_branch; 
  struct ast_node * else_branch; 
};

struct ast_define_node
{
  int node_type;
  char* name;
  struct ast_define_node * next;
  struct ast_node * function;
};

struct ast_function_node
{
  int node_type;
  struct ast_node * arguments;
  struct ast_node * function_body;
};

struct ast_node * new_ast_node (int node_type, struct ast_node* left, struct ast_node* right, struct ast_node* condition, int value, char* name);
struct ast_node * new_ast_bool_node (char* value);
struct ast_node * new_ast_number_node (int value);
struct ast_node * new_ast_parameter_node (char* name, int node_type);
struct ast_node * new_ast_logic_node (int node_type, char* value, struct ast_node* left, struct ast_node* right);
struct ast_node * new_ast_if_node (struct ast_node * condition, struct ast_node * if_branch, struct ast_node * else_branch);
struct ast_define_node * new_ast_define_node (char* name, struct ast_node * function, struct ast_define_node * next);
struct ast_node * new_ast_function_node (struct ast_node * arguments, struct ast_node * function_body);

