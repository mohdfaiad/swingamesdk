from tokeniser.pas_token_kind import TokenKind
from pas_expression import PascalExpression
from types.pas_operator import PascalOperator
class AssignmentStatement(object):
    """
    The assignment statement stores the information about an assignment statement
    """

    def __init__(self, block):
        self._operand = None
        self._operator = None       # += *= /= -= := token
        self._expression = None
        self._block = block
        self._code = dict()

    @property
    def code(self):
        return self._code

    def parse(self, tokens):
        varName = ''
        if (tokens.lookahead(2)[1].value == '.') and (tokens.lookahead(3)[2].kind is TokenKind.Identifier):
            # record field...
            varName = tokens.match_token(TokenKind.Identifier).value
            tokens.match_token(TokenKind.Symbol, '.')
            field_name = tokens.match_token(TokenKind.Identifier).value

            self._operand = self._block.resolve_variable(varName)
            if self._operand.type.kind is 'record':
                if not self._operand.type.has_field(field_name):
                    logger.error("Parser:       Variable %s does not have field: %s in %s" % (var_name, field_name, next_token.filename))
                    assert False
                                 
        else:
            varName = tokens.match_token(TokenKind.Identifier).value
            self._operand = self._block.resolve_variable(varName)

        operatorValue = tokens.match_token(TokenKind.Operator).value
        self._operator = PascalOperator(operatorValue)

        self._expression = PascalExpression(self._block)
        self._expression.parse(tokens)

    @property
    def kind(self):
        return 'assignment'

    @property
    def operand(self):
        return self._operand

    @property
    def operator(self):
        return self._operator

    @property
    def expression(self):
        return self._expression

    @property
    def block(self):
        return self._block

    def to_code(self):
        '''
        This method creates the code to declare all it's variables
        for each of the modules
        '''
        import converter_helper
        my_data = dict()

        my_data['pas_lib_operand'] = self.operand.name
        my_data['c_lib_operand'] = converter_helper.lower_name(self.operand.name)

        self._operator.to_code()
        self._expression.to_code()

        for (name, module) in converter_helper.converters.items():
            # operator / expression
            my_data[name + '_expression'] = self._expression.code[name]
            my_data[name + '_operator'] = self._operator.code[name]
            self._code[name] = module.assignment_template % my_data