class PascalNumber(object):
    """
    Describes a number
    """
    
    def __init__(self, value):
        self._value = value
                
    @property
    def kind(self):
        return 'number'

    @property
    def value(self):
        return self._value