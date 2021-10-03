struct GooglePlacesResponse : Codable {
    let results : [Place]
    enum CodingKeys : String, CodingKey {
        case results = "results"
    }
}

// Place struct
struct Place : Codable {
    
    let geometry : Location
    let name : String
    let place_id: String
    let openingHours : OpenNow?
    let photos : [PhotoInfo]?
    let types : [String]
    let address : String
    
    
    enum CodingKeys : String, CodingKey {
        case geometry = "geometry"
        case name = "name"
        case place_id = "place_id"
        case openingHours = "opening_hours"
        case photos = "photos"
        case types = "types"
        case address = "vicinity"
    }
    
    
    // Location struct
    struct Location : Codable {
        
        let location : LatLong
        
        enum CodingKeys : String, CodingKey {
            case location = "location"
        }
        
        
        // LatLong struct
        struct LatLong : Codable {
            
            let latitude : Double
            let longitude : Double
            
            enum CodingKeys : String, CodingKey {
                case latitude = "lat"
                case longitude = "lng"
            }
        }
        
    }
    
    
    // OpenNow struct
    struct OpenNow : Codable {
        
        let isOpen : Bool
        
        enum CodingKeys : String, CodingKey {
            case isOpen = "open_now"
        }
    }
    
    
    // PhotoInfo struct
    struct PhotoInfo : Codable {
        
        let height : Int
        let width : Int
        let photoReference : String
        
        enum CodingKeys : String, CodingKey {
            case height = "height"
            case width = "width"
            case photoReference = "photo_reference"
        }
    }
    
    
    
}



