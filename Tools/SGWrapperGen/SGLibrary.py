#!/usr/bin/env python
# encoding: utf-8
"""
SGLibrary.py

Created by Andrew Cain on 2009-05-22.
Copyright (c) 2009 Swinburne. All rights reserved.
"""

from sgcodemodule import SGCodeModule

class SGLibrary(SGCodeModule):
    """Represents the SwinGame SDK library."""
    
    def __init__(self):
        """Initialise the library"""
        super(SGLibrary,self).__init__('SGSDKLib')
        self.is_static = True
    
    def add_member(self, member):
        """Add a method to the library"""
        from SGMethod import SGMethod
        
        if isinstance(member, SGMethod):
            member.is_external = True
            super(SGLibrary,self).add_member(member)
        else:
            raise Exception, "Unknown member type"
    

import nose
from nose.tools import raises 

def test_library_creation():
    """test basic library creation"""
    my_library = SGLibrary()
    
    assert len(my_library.methods) == 0

def test_add_method():
    """test adding a method to a library"""
    from SGMethod import SGMethod
    my_library = SGLibrary()
    my_method = SGMethod('test')
    
    my_library.add_member(my_method)
    
    print my_library.methods
    
    assert len(my_library.methods) == 1
    assert my_method == my_library.methods[("test", ())]

@raises(Exception)
def test_add_unkown_member():
    """test adding some unknown member type to the library, expects to fail"""
    my_library = SGLibrary("Hello")
    my_library.add_method("Hello")
        
if __name__ == '__main__':
    nose.run()
