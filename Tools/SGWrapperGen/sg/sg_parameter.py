#!/usr/bin/env python
# encoding: utf-8
"""
SGParameter.py

Created by Andrew Cain on 2009-05-21.
Copyright (c) 2009 Swinburne. All rights reserved.
"""

from sg_metadata_container import SGMetaDataContainer

class SGParameter(SGMetaDataContainer):
    """Represents a parameter to a method"""
    
    def __init__(self, name):
        """initialise the parameter with a name, sets type to None"""
        SGMetaDataContainer.__init__(self, ['type','modifier','maps_result'])
        self.name = name
        self.data_type = None
        self.modifier = None
        #post parse values
        self.maps_result = False
        self.maps_to_temp = False
        self.is_length_param = False
        self.has_length_param = False   # does this have a length param? (var arrays)
        self.length_idx = -1            # which param is the length param for this?
        self.length_of = None           # the SGParameter this represents the length of...
        self.has_field = False          # Used to check if a parameter/arg has a field (i.e. array wrapper)
    
    # def set_as_output(self):
    #     """marks this as an output parameter"""
    #     self.set_tag('output')
    # 
    # def is_output(self):
    #     """returns True if the parameter is an output parameter"""
    #     #print self.tags.keys()
    #     return 'output' in self.tags.keys()
    # 
    # def set_as_array(self):
    #     """marks this as an array parameter"""
    #     self.set_tag('array')
    # 
    # def is_array(self):
    #     """returns True if the parameter is an array parameter"""
    #     #print self.tags.keys()
    #     return 'array' in self.tags.keys()
    
    def __str__(self):
        return '%s%s %s'% ( 
            self.modifier + ' ' if self.modifier != None else '', 
            self.data_type, 
            self.name)
    
    def arg_name(self):
        return '%s%s' % (
            self.name,
            '_temp' if self.maps_to_temp else ''
            )
    
    data_type = property(lambda self: self['type'].other, lambda self,the_type: self.set_tag('type', the_type), None, "The data type of the parameter.")
    modifier = property(lambda self: self['modifier'].other, lambda self,value: self.set_tag('modifier', value), None, "The modifier of the parameter.")
    maps_result = property(lambda self: self['maps_result'].other, 
        lambda self,value: self.set_tag('maps_result', value), 
        None, "The parameter wraps the result of a function.")
        
    def local_var_name(self):
        """returns the local variable name that this would be copied to if needed, otherwise the parameter name"""
        
        if self.maps_result:
            return 'result'
        elif self.data_type.array_wrapper:
            return self.name + '_temp'
        else:
            return self.name
#
# Test methods
#

def test_parameter_creation():
    """tests basic creation of a parameter"""
    my_param = SGParameter("test")
    
    assert my_param.name == "test"
    assert len(my_param.tags) == 3 #type,name,modifier
    assert my_param.data_type == None

def test_output_param():
    """tests the creation of an output parameter"""
    my_param = SGParameter("Test")
    assert False == my_param.is_output()
    
    my_param.set_as_output()
    assert my_param.is_output()

def test_array_param():
    """tests the creation of an array parameter"""
    my_param = SGParameter("Test")
    assert False == my_param.is_array()
    
    my_param.set_as_array()
    assert my_param.is_array()

def test_type_param():
    """tests the setting of a parameters type"""
    my_param = SGParameter("Test")
    assert None == my_param.data_type
    
    my_param.data_type = "SoundEffect"
    assert "SoundEffect" == my_param.data_type

if __name__ == '__main__':
    import nose
    nose.run()