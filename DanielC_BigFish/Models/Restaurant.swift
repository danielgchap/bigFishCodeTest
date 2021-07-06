import Foundation
import MapKit

struct Restaurants : Decodable {
    var businesses: [Restaurant]
}

struct Restaurant : Decodable {
    var displayPhone: String?
    var imageURL: String?
    var latitude: Double?
    var longitude: Double?
    var name: String?
    var phone: String?
    var rating: Double?
    var reviewCount: Double?
    
    enum CodingKeys: String, CodingKey {
        case coordinates, name, phone, price, rating
        case reviewCount = "review_count"
        case displayPhone = "display_phone"
        case imageURL = "image_url"
    }

    enum CoordinatesKey: Int, CodingKey {
        case latitude, longitude
    }
    
    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: CodingKeys.self)
        displayPhone = try outerContainer.decode(String.self, forKey: .displayPhone)
        imageURL = try outerContainer.decodeIfPresent(String.self, forKey: .imageURL)
        name = try outerContainer.decode(String.self, forKey: .name)
        phone = try outerContainer.decode(String.self, forKey: .phone)
        rating = try outerContainer.decode(Double.self, forKey: .rating)
        reviewCount = try outerContainer.decode(Double.self, forKey: .reviewCount)

        let coordinatesContainer = try outerContainer.nestedContainer(keyedBy: CoordinatesKey.self, forKey: .coordinates)
        latitude = try coordinatesContainer.decode(Double.self, forKey: .latitude)
        longitude = try coordinatesContainer.decode(Double.self, forKey: .longitude)
    }
}


