//
//  StopArrivals+Deduplication.swift
//  OBAKit
//
//  Copyright © Open Transit Software Foundation
//  This source code is licensed under the Apache 2.0 license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import OBAKitCore

extension StopArrivals {
    /// Returns a deduplicated list of arrivals and departures.
    ///
    /// In some cases, transit agencies may report duplicate trip data,
    /// resulting in the same arrival appearing multiple times. This computed
    /// property filters the list to ensure each unique trip appears only once.
    ///
    /// Deduplication Strategy:
    /// - Uses tripID as the primary unique identifier
    /// - For entries with the same tripID, keeps only the first occurrence
    /// - This handles cases where the same trip is reported multiple times
    ///   with slightly different metadata (e.g., status changes)
    ///
    /// - Returns: An array of `ArrivalDeparture` objects with duplicates removed
    var deduplicatedArrivalsAndDepartures: [ArrivalDeparture] {
        var seenTripIDs = Set<String>()
        var deduplicated: [ArrivalDeparture] = []
        
        for arrivalDeparture in arrivalsAndDepartures {
            // Use tripID as the unique identifier
            // This ensures each unique trip appears only once, regardless of
            // minor differences in status or predicted times
            let tripKey = arrivalDeparture.tripID
            
            if !seenTripIDs.contains(tripKey) {
                seenTripIDs.insert(tripKey)
                deduplicated.append(arrivalDeparture)
            }
        }
        
        return deduplicated
    }
}

extension Array where Element == ArrivalDeparture {
    /// Removes duplicate arrivals based on trip ID.
    ///
    /// This method is useful when working with collections of `ArrivalDeparture`
    /// objects that may have already been filtered or transformed.
    ///
    /// - Returns: An array with duplicate trips removed, preserving the first occurrence
    func deduplicatedByTrip() -> [ArrivalDeparture] {
        var seenTripIDs = Set<String>()
        
        return self.filter { arrivalDeparture in
            let tripKey = arrivalDeparture.tripID
            
            guard !seenTripIDs.contains(tripKey) else {
                return false
            }
            
            seenTripIDs.insert(tripKey)
            return true
        }
    }
}
