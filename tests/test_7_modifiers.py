import os
import numpy as np
from collections import OrderedDict
from itertools import combinations
from numpy.testing import assert_array_equal
from nose.tools import assert_equal, assert_raises, ok_

from morphio import Morphology, upstream, IterType, Option, SectionType, ostream_redirect
from morphio.mut import Morphology as MutableMorphology
from utils import captured_output, setup_tempdir


def _path(filename):
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", filename)

SIMPLE = _path('simple.swc')
SIMPLE_NO_MODIFIER = Morphology(SIMPLE)

def test_no_modifier():
    assert_array_equal(SIMPLE_NO_MODIFIER.points, Morphology(SIMPLE, options=Option.no_modifier).points)

def test_nrn_order():
    m = Morphology(_path('reversed_NRN_neurite_order.swc'), options=Option.nrn_order)
    assert_equal([section.type for section in m.root_sections],
                 [SectionType.axon,
                  SectionType.basal_dendrite,
                  SectionType.apical_dendrite])


    normal = Morphology(_path('reversed_NRN_neurite_order.swc'))
    m = MutableMorphology(normal, options=Option.nrn_order)
    assert_equal([section.type for section in m.root_sections],
                 [SectionType.axon,
                  SectionType.basal_dendrite,
                  SectionType.apical_dendrite])

    normal = MutableMorphology(_path('reversed_NRN_neurite_order.swc'))
    m = MutableMorphology(normal, options=Option.nrn_order)
    assert_equal([section.type for section in m.root_sections],
                 [SectionType.axon,
                  SectionType.basal_dendrite,
                  SectionType.apical_dendrite])


def test_two_point_section():
    m = Morphology(_path('multiple_point_section.asc'), options=Option.two_points_sections)
    assert_array_equal([section.points for section in m.iter()],
                       [[[0.,0.,0.], [10.,50.,0.]],
                        [[10,50,0], [0,1,2]],
                        [[10,50,0], [0,4,5]],
                        [[0,0,0], [7,7,7]]])

def test_soma_sphere():
    m = Morphology(_path('soma_multiple_frustums.swc'), options=Option.soma_sphere)
    assert_array_equal(m.soma.points,
                       [[1.5, 0, 0]])

def test_no_duplicate():
    with captured_output():
        with ostream_redirect(stdout=True, stderr=True):
            m = Morphology(SIMPLE, options=Option.no_duplicates)

    neurite1 = [[[0.,0.,0.], [0,5,0]],
                [[-5,5,0]],
                [[6,5,0]]]

    neurite2 = [[[0,0,0], [0,-4,0]],
                [[6,-4,0]],
                [[-5,-4,0]]]

    assert_array_equal([section.points.tolist() for section in m.iter()],
                       neurite1 + neurite2)

    # Combining options NO_DUPLICATES and NRN_ORDER
    with captured_output():
        with ostream_redirect(stdout=True, stderr=True):
            m = Morphology(SIMPLE, options=Option.no_duplicates|Option.nrn_order)
    assert_array_equal([section.points.tolist() for section in m.iter()],
                       neurite2 + neurite1)

def test_no_sanitize():
    with captured_output():
        with ostream_redirect(stdout=True, stderr=True):
            immut = Morphology(_path('nested_single_children.asc'), options=Option.no_sanitize)
            mut = immut.as_mutable()
            with setup_tempdir('test_write_no_sanitize') as tmp_folder:
                filename = os.path.join(tmp_folder, 'after-write.asc')
                mut.write(filename, sanitize=False)
                after_write = Morphology(filename, options=Option.no_sanitize)

                for morph in [immut, mut, after_write]:
                    root = morph.root_sections[0]
                    assert_array_equal(root.points, [[0, 0, 0], [0, 0, 1]])
                    assert_equal(len(root.children), 1)
                    child = root.children[0]
                    assert_array_equal(child.points, [[0, 0, 2]])
                    assert_equal(len(child.children), 1)
                    assert_array_equal(child.children[0].points, [[0, 0, 3]])
