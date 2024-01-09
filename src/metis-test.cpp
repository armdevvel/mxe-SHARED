/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 *
 * taken from: https://gist.github.com/erikzenker/c4dc42c8d5a8c1cd3e5a
 */


#include <cstddef> /* NULL */
#include <metis.h>
#include <iostream>


// Install metis from:
// http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz

// Build with
// g++ metis.cc -lmetis

int main(){

    constexpr idx_t kVertices = 6;
    constexpr idx_t kEdges    = 7;
    constexpr idx_t kWeights  = 1;
    idx_t nVertices = kVertices;
    idx_t nEdges    = kEdges;
    idx_t nWeights  = kWeights;
    idx_t nParts    = 2;

    idx_t objval;
    idx_t part[kVertices];


    // Indexes of starting points in adjacent array
    idx_t xadj[kVertices+1] = {0,2,5,7,9,12,14};

    // Adjacent vertices in consecutive index order
    idx_t adjncy[2 * kEdges] = {1,3,0,4,2,1,5,0,4,3,1,5,4,2};

    // Weights of vertices
    // if all weights are equal then can be set to NULL
    idx_t vwgt[kVertices * kWeights];


    // int ret = METIS_PartGraphRecursive(&nVertices,& nWeights, xadj, adjncy,
    //                     NULL, NULL, NULL, &nParts, NULL,
    //                     NULL, NULL, &objval, part);

    int ret = METIS_PartGraphKway(&nVertices,& nWeights, xadj, adjncy,
                       NULL, NULL, NULL, &nParts, NULL,
                       NULL, NULL, &objval, part);

    std::cout << ret << std::endl;

    for(idx_t part_i = 0; part_i < nVertices; part_i++){
    std::cout << part_i << " " << part[part_i] << std::endl;
    }


    return 0;
}
