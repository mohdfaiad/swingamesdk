import logging

_files = {}
_classes = {}
_loaded_types = {}
_known_values = [
        'ColorBlack'
    ]

logger = logging.getLogger("SGWrapperGen")

def all_classes():
    return _classes

def all_files():
    return _files

def all_types():
    return _loaded_types;

def find_or_add_class(name):
    '''finds or creates and adds a class with the indicated name'''
    if name == None: return None
    
    if name in _classes:
        return _classes[name]
    else:
        from sg_code_module import SGCodeModule
        from sg_library import SGLibrary
        logger.debug('Cache     : Created class %s', name)
        if name == 'lib': result = SGLibrary()
        else: 
            result = SGCodeModule(name)
        _classes[name] = result
        return result

def find_or_add_type(name):
    if name == None: return None
    from sg_type import SGType
    
    if name in _loaded_types:
        return _loaded_types[name]
    else:
        logger.debug('Cache     : Created Type %s', name)
        result = SGType(name)
        _loaded_types[name] = result
        return result

def find_or_add_file(pascal_name, name=None, filename=None):
    '''finds or creates and adds a file with the indicated Pascal name'''
    if pascal_name == None: return None
    
    from sg_file import SGFile
    if pascal_name in _files:
        return _files[pascal_name]
    else:
        logger.info(' Cache     : Created file %s', pascal_name)
        result = SGFile(pascal_name, name, filename)
        _files[pascal_name] = result
        return result

