# -*- coding: utf-8 -*-
# =====================================================================================================================
# These bindings were automatically generated by cyWrap. Please do dot modify.
# Additional functionality shall be implemented in sub-classes.
#
__copyright__ = "Copyright 2017 EPFL BBP-project"
# =====================================================================================================================
include "includes/_base.pxi"

from .includes cimport morpho
from .includes.statics cimport morpho_morpho_node_type
from .includes.statics cimport morpho_neuron_struct_type
from .includes cimport morpho_h5_v1
from .includes.statics cimport morpho_h5_v1_morpho_reader

include "datastructs.pxi"


# ======================================================================================================================
# Python bindings to namespace morpho
# ======================================================================================================================

# ----------------------------------------------------------------------------------------------------------------------
cdef class MORPHO_NODE_TYPE(_Enum):
    unknown = morpho_morpho_node_type.unknown
    neuron_node_3d_type = morpho_morpho_node_type.neuron_node_3d_type
    neuron_branch_type = morpho_morpho_node_type.neuron_branch_type
    neuron_soma_type = morpho_morpho_node_type.neuron_soma_type


# ----------------------------------------------------------------------------------------------------------------------
cdef class NEURON_STRUCT_TYPE(_Enum):
    soma = morpho_neuron_struct_type.soma
    axon = morpho_neuron_struct_type.axon
    dentrite_basal = morpho_neuron_struct_type.dentrite_basal
    dentrite_apical = morpho_neuron_struct_type.dentrite_apical
    unknown = morpho_neuron_struct_type.unknown


# ----------------------------------------------------------------------------------------------------------------------
cdef class MorphoNode(_py__base):
    "Python wrapper class for morpho_node (ns=morpho)"
# ----------------------------------------------------------------------------------------------------------------------
    cdef std.shared_ptr[morpho.morpho_node] _autodealoc
    cdef morpho.morpho_node *ptr0(self):
        return <morpho.morpho_node*> self._ptr

    # Index property, calculated in python only
    cdef readonly int index

    @property
    def bounding_box(self, ):
        return _Box.from_value(self.ptr0().get_bounding_box())

    def is_of_type(self, int mtype):
        return self.ptr0().is_of_type(<morpho.morpho_node_type> mtype)

    def __repr__(self):
        return "<MorphoNode nr.%d>" % (self.index,)

    @staticmethod
    cdef MorphoNode from_ptr_index(const morpho.morpho_node *ptr, int index, bool owner=False):
        # Downcast nodes to specific types
        # this is the only function that introduces some program logic.
        # The same could be done with dynamic_cast, but would be less obvious and more verbose
        cdef MorphoNode obj
        if ptr.is_of_type(morpho_morpho_node_type.neuron_branch_type):
            obj = NeuronBranch.from_ptr(<const morpho.neuron_branch *>ptr, owner)
        elif ptr.is_of_type(morpho_morpho_node_type.neuron_soma_type):
            obj = NeuronSoma.from_ptr(<const morpho.neuron_soma*>ptr, owner)
        elif ptr.is_of_type(morpho_morpho_node_type.neuron_node_3d_type):
            obj = NeuronNode3D.from_ptr(<const morpho.neuron_node_3d*>ptr, owner)
        else:
            # default return just "MorphoNode"
            obj = MorphoNode.__new__(MorphoNode)
            obj._ptr = <void*>ptr
            if owner: obj._autodealoc.reset(obj.ptr0())

        obj.index = index
        return obj
    
    @staticmethod
    cdef MorphoNode from_ref(const morpho.morpho_node &ref):
        return MorphoNode.from_ptr_index(<morpho.morpho_node*>&ref, -1)

    @staticmethod
    cdef MorphoNode from_ref_id(const morpho.morpho_node &ref, int id):
        return MorphoNode.from_ptr_index(<morpho.morpho_node*>&ref, id)

    @staticmethod
    cdef list vectorPtrSel2list(std.vector[const morpho.morpho_node*] vec, std.vector[unsigned int] selection):
        cdef int idx=0
        return [MorphoNode.from_ptr_index(vec[idx], idx) for idx in selection]

    @staticmethod
    cdef list vectorPtr2list(std.vector[const morpho.morpho_node*] vec):
        cdef int idx=0
        cdef const morpho.morpho_node* item
        cdef list lst = []
        for item in vec:
            lst.append(MorphoNode.from_ptr_index(item, idx))
            idx += 1
        return lst



# ----------------------------------------------------------------------------------------------------------------------
cdef class NeuronNode3D(MorphoNode):
    "Python wrapper class for neuron_node_3d (ns=morpho)"
# ----------------------------------------------------------------------------------------------------------------------
    cdef readonly _EnumItem branch_type
    cdef morpho.neuron_node_3d *ptr1(self):
        return <morpho.neuron_node_3d*> self._ptr

    def is_of_type(self, int mtype):
        return self.ptr1().is_of_type(<morpho.morpho_node_type> mtype)

    def __repr__(self):
        return "<MorphoNode::%s nr.%d>" % (self.branch_type.name, self.index)

    cdef _init(self):
        self.branch_type = _EnumItem(NEURON_STRUCT_TYPE, <int>self.ptr1().get_branch_type())

    @staticmethod
    cdef NeuronNode3D from_ptr0(type cls, const morpho.neuron_node_3d *ptr, bool owner=False):
        cdef NeuronNode3D obj = cls.__new__(cls)
        obj._ptr = <void*>ptr
        obj._init()
        if owner: obj._autodealoc.reset(obj.ptr1())
        return obj

    @staticmethod
    cdef NeuronNode3D from_ptr(const morpho.neuron_node_3d *ptr, bool owner=False):
        return NeuronNode3D.from_ptr0(NeuronNode3D, ptr, owner)
    
    @staticmethod
    cdef NeuronNode3D from_ref(const morpho.neuron_node_3d &ref):
        return NeuronNode3D.from_ptr(<morpho.neuron_node_3d*>&ref)



# ----------------------------------------------------------------------------------------------------------------------
cdef class NeuronBranch(NeuronNode3D):
    "Python wrapper class for neuron_branch (ns=morpho)"
# ----------------------------------------------------------------------------------------------------------------------
    cdef object _points_vec
    cdef morpho.neuron_branch *ptr2(self):
        return <morpho.neuron_branch*> self._ptr

    def __init__(self, int neuron_type, _PointVector points, std.vector[double] radius):
        self._ptr = new morpho.neuron_branch(<morpho.neuron_struct_type> neuron_type, morpho.move_PointVector(deref(points.ptr())), morpho.move_DoubleVec(radius))
        self._autodealoc.reset(self.ptr2())
        self._points_vec = None

    def is_of_type(self, int mtype):
        return self.ptr2().is_of_type(<morpho.morpho_node_type> mtype)

    @property
    def number_points(self, ):
        return self.ptr2().get_number_points()

    @property
    def pointsVector(self, ):
        if self._points_vec:
            return self._points_vec
        val = self._points_vec = _PointVector.from_ref(self.ptr2().get_points())
        return val

    @property
    def points(self):
        # Check if cache is filled
        p_vec = self._points_vec or self.pointsVector
        return p_vec.nparray

    @property
    def radius(self, ):
        return self.ptr2().get_radius()

    @property
    def bounding_box(self, ):
        return _Box.from_value(self.ptr2().get_bounding_box())

    def get_segment(self, size_t n):
        return _Cone.from_value(self.ptr2().get_segment(n))

    def get_segment_bounding_box(self, size_t n):
        return _Box.from_value(self.ptr2().get_segment_bounding_box(n))

    def get_junction(self, size_t n):
        return _Sphere.from_value(self.ptr2().get_junction(n))

    def get_junction_sphere_bounding_box(self, size_t n):
        return _Box.from_value(self.ptr2().get_junction_sphere_bounding_box(n))

    @property
    def linestring(self, ):
        return _Linestring.from_value(self.ptr2().get_linestring())

    @property
    def circle_pipe(self, ):
        return _CirclePipe.from_value(self.ptr2().get_circle_pipe())

    @staticmethod
    cdef NeuronBranch from_ptr(const morpho.neuron_branch *ptr, bool owner=False):
        return <NeuronBranch>NeuronNode3D.from_ptr0(NeuronBranch, ptr, owner)

    @staticmethod
    cdef NeuronBranch from_ref(const morpho.neuron_branch &ref):
        return NeuronBranch.from_ptr(<morpho.neuron_branch*>&ref)

    @staticmethod
    cdef NeuronBranch from_value(const morpho.neuron_branch &ref):
        cdef morpho.neuron_branch *ptr = new morpho.neuron_branch(ref)
        return NeuronBranch.from_ptr(ptr, True)



# ----------------------------------------------------------------------------------------------------------------------
cdef class NeuronSoma(NeuronNode3D):
    "Python wrapper class for neuron_soma (ns=morpho)"
# ----------------------------------------------------------------------------------------------------------------------
    cdef morpho.neuron_soma *ptr2(self):
        return <morpho.neuron_soma*> self._ptr

    def is_of_type(self, int mtype):
        return self.ptr2().is_of_type(<morpho.morpho_node_type> mtype)

    @property
    def sphere(self, ):
        return _Sphere.from_value(self.ptr2().get_sphere())

    @property
    def bounding_box(self, ):
        return _Box.from_value(self.ptr2().get_bounding_box())

    @property
    def line_loop(self, ):
        return _PointVector.from_ref(self.ptr2().get_line_loop())

    @staticmethod
    cdef NeuronSoma from_ptr(const morpho.neuron_soma *ptr, bool owner=False):
        return <NeuronSoma>NeuronSoma.from_ptr0(NeuronSoma, ptr, owner)

    @staticmethod
    cdef NeuronSoma from_ref(const morpho.neuron_soma &ref):
        return NeuronSoma.from_ptr(<morpho.neuron_soma*>&ref)



# ----------------------------------------------------------------------------------------------------------------------
cdef class MorphoTree(_py__base):
    "Python wrapper class for morpho_tree (ns=morpho)"
# ----------------------------------------------------------------------------------------------------------------------
    cdef std.shared_ptr[morpho.morpho_tree] _sharedPtr
    cdef morpho.morpho_tree *ptr(self):
        return <morpho.morpho_tree*> self._ptr

    def __init__(self, MorphoTree other=None):
        if other:
            self._ptr = new morpho.morpho_tree(deref(other.ptr()))
        else:
            self._ptr = new morpho.morpho_tree()

        self._sharedPtr.reset(self.ptr())

    @property
    def bounding_box(self, ):
        return _Box.from_value(self.ptr().get_bounding_box())

    @property
    def tree_size(self, ):
        return self.ptr().get_tree_size()

    def swap(self, MorphoTree other):
        """Python side swap only swaps pointers"""
        self._ptr = other._ptr
        self._sharedPtr = other._sharedPtr

    def add_node(self, int parent_id, MorphoNode new_node):
        return self.ptr().add_node(parent_id, new_node._autodealoc)

    def copy_node(self, MorphoTree other, int id_, int new_parent_id):
        return self.ptr().copy_node(deref(other.ptr()), id_, new_parent_id)

    def get_node(self, int id_):
        if id_ > self.tree_size:
            return None
        return MorphoNode.from_ref_id(self.ptr().get_node(id_), id_)

    def get_parent(self, int id_):
        return self.ptr().get_parent(id_)

    def get_children(self, int id_):
        return self.ptr().get_children(id_)

    @property
    def all_nodes(self, ):
        return MorphoNode.vectorPtr2list(self.ptr().get_all_nodes())

    def find_nodes(self, int mtype):
        return self.ptr().find_nodes(<morpho.neuron_struct_type>mtype)

    @property
    def soma(self):
        return NeuronSoma.from_ptr(self.ptr().get_soma())

    @staticmethod
    cdef MorphoTree from_ptr(const morpho.morpho_tree *ptr, bool owner=False):
        cdef MorphoTree obj = MorphoTree.__new__(MorphoTree)
        obj._ptr = <morpho.morpho_tree *>ptr
        if owner: obj._sharedPtr.reset(obj.ptr())
        return obj
    
    @staticmethod
    cdef MorphoTree from_ref(const morpho.morpho_tree &ref):
        return MorphoTree.from_ptr(<morpho.morpho_tree*>&ref)

    @staticmethod
    cdef MorphoTree from_value(const morpho.morpho_tree &ref):
        cdef morpho.morpho_tree *ptr = new morpho.morpho_tree(ref)
        return MorphoTree.from_ptr(ptr, True)

    @staticmethod
    cdef MorphoTree from_move(const morpho.morpho_tree &ref):
        cdef MorphoTree obj = MorphoTree()
        obj.ptr().swap(<morpho.morpho_tree&>ref)
        return obj

    @staticmethod
    cdef list vectorPtr2list(std.vector[morpho.morpho_tree*] vec):
        return [MorphoTree.from_ptr(elem) for elem in vec]

    # Transform support
    def transform(self, list operations):
        cdef std.vector[std.shared_ptr[morpho.morpho_operation]] vec
        cdef _py_morpho_operation item
        for item in operations:
            vec.push_back(item._sharedPtr)
        morpho.morpho_transform(deref(self.ptr()), vec)
        return self



# Add bindings for h5_v1 loader and exporter
include "morpho_h5_v1.pxi"

# Add bindings for transformations and spatial index
include "morpho_transform_spatial.pxi"

# Add bindings for MorphoStats
include "morpho_stats.pxi"

# Optional bindings for morpho_mesher, overridable by cython exec
# ----------------------------------------------------------------------------------------------------------------------
DEF ENABLE_MESHER_GCAL = 0
IF ENABLE_MESHER_GCAL:
    include "morpho_mesher.pxi"


# ************************************
# Class-Namespace alias
# ************************************

cdef class Types:
    Point = _Point
    Box = _Box
    Linestring = _Linestring
    Circle = _Circle
    Cone = _Cone
    Sphere = _Sphere
    CurclePipe = _CirclePipe
    PointVector = _PointVector
    MatPoints = _Mat_Points
    MatIndex = _Mat_Index


class Transforms:
    Delete_Duplicate_Point_Operation = _py_delete_duplicate_point_operation
    Duplicate_First_Point_Operation = _py_duplicate_first_point_operation
