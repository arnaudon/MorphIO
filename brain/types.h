/* Copyright (c) 2016, EPFL/Blue Brain Project
 *                     Stefan.Eilemann@epfl.ch
 *
 * This file is part of Brion <https://github.com/BlueBrain/Brion>
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License version 3.0 as published
 * by the Free Software Foundation.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef BRAIN_NEURON_TYPES
#define BRAIN_NEURON_TYPES

#include <brion/types.h>
#include <memory>
#include <vector>

namespace brain
{
/** High-level interface to neuron morphologies. */
class Morphology;
class Section;
class Soma;

enum class SectionType
{
    soma = brion::enums::SECTION_SOMA,
        axon = brion::enums::SECTION_AXON,
        dendrite = brion::enums::SECTION_DENDRITE,
        basalDendrite = brion::enums::SECTION_BASAL_DENDRITE,
        apicalDendrite = brion::enums::SECTION_APICAL_DENDRITE,
        undefined = brion::enums::SECTION_UNDEFINED,
        all = brion::enums::SECTION_ALL
        };

typedef std::shared_ptr<Morphology> MorphologyPtr;

typedef std::vector<MorphologyPtr> Morphologies;
typedef std::vector<Section> Sections;
typedef std::vector<SectionType> SectionTypes;


using vmml::Matrix4f;
using vmml::Quaternionf;
using vmml::Vector2i;
using vmml::Vector3f;
using vmml::Vector4f;

using brion::Strings;
using brion::URI;
using brion::Vector2is;
using brion::Vector3fs;
using brion::Vector4fs;
using brion::floats;
using brion::uint32_ts;
using brion::size_ts;

// Brion exceptions
using brion::RawDataError;
using brion::SomaError;
using brion::IDSequenceError;
using brion::MultipleTrees;
using brion::MissingParentError;

typedef std::vector<Matrix4f> Matrix4fs;
typedef std::vector<Quaternionf> Quaternionfs;


/**
 * The GID of a synapse is the a tuple of two numbers:
 * - The GID of the post-synaptic cell.
 * - The index of the synapse in the array of afferent contacts
 *   of the post-synaptic cell before pruning/filtering.
 * GIDs are invariant regardless of how the structural touches are
 * converted into functional synapses during circuit building.
 */
typedef std::pair<uint32_t, size_t> SynapseGID;


}
#endif
