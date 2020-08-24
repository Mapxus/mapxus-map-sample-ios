//
//  UIImage+icon.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/30.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "UIImage+icon.h"

@implementation UIImage (icon)

+ (instancetype)buildingIconWithType:(NSString *)type {
    NSString *iconName = nil;
    if ([type containsString:@"residential"]) {
        iconName = @"residential";
    } else if ([type containsString:@"government"]) {
        iconName = @"publicServices";
    } else if ([type containsString:@"commercial"]) {
        iconName = @"commercial";
    } else if ([type containsString:@"healthcare"]) {
        iconName = @"health";
    } else if ([type containsString:@"industrial"]) {
        iconName = @"industrial";
    } else if ([type containsString:@"retail"]) {
        iconName = @"retail";
    } else if ([type containsString:@"educational"]) {
        iconName = @"education";
    } else if ([type containsString:@"transportation"]) {
        iconName = @"transportation";
    } else if ([type containsString:@"entertainment_leisure"]) {
        iconName = @"entertainment";
    } else {
        iconName = @"building";
    }
    return [UIImage imageNamed:iconName];
}

+ (instancetype)categoryIconWithType:(NSString *)type {
    NSString *iconName = nil;
    if ([type containsString:@"arts_entertainment.amusement_parks"]) {
        iconName = @"Amusementparks";
    } else if ([type containsString:@"shopping.appliances"]) {
        iconName = @"Appliances";
    } else if ([type containsString:@"facility.atm"]) {
        iconName = @"Atm";
    } else if ([type containsString:@"automotive.auto_repair"]) {
        iconName = @"Autorepair";
    } else if ([type containsString:@"shopping.baby_gear"]) {
        iconName = @"BabyGear";
    } else if ([type containsString:@"facility.baggage_delivery_service"]) {
        iconName = @"BaggageDelivery";
    } else if ([type containsString:@"facility.baggage_storage"]) {
        iconName = @"BaggageRoom";
    } else if ([type containsString:@"professional_services.financial_services.banks"]) {
        iconName = @"Bank";
    } else if ([type containsString:@"restaurants.bars"]) {
        iconName = @"Bars";
    } else if ([type containsString:@"shopping.media"]) {
        iconName = @"Book";
    } else if ([type containsString:@"sports_activities.bowling"]) {
        iconName = @"Bowling";
    } else if ([type containsString:@"workplace.break_room"]) {
        iconName = @"BreakRoom";
    } else if ([type containsString:@"transport.bus_stations"]) {
        iconName = @"BusStation";
    } else if ([type containsString:@"transport.shuttle_bus_stations"]) {
        iconName = @"BusStation";
    } else if ([type containsString:@"transport.mini_bus_stations"]) {
        iconName = @"BusStation";
    } else if ([type containsString:@"automotive.car_wash"]) {
        iconName = @"Carwash";
    } else if ([type containsString:@"facility.power_charging_station"]) {
        iconName = @"Charge";
    } else if ([type containsString:@"workplace.classroom"]) {
        iconName = @"Classroom";
    } else if ([type containsString:@"shopping.clothes"]) {
        iconName = @"Cloths";
    } else if ([type containsString:@"shopping.food.coffee_tea_supplies"]) {
        iconName = @"Coffee";
    } else if ([type containsString:@"facility.coin_locker"]) {
        iconName = @"CoinLockers";
    } else if ([type containsString:@"workplace.computer_room"]) {
        iconName = @"ComputerRoom";
    } else if ([type containsString:@"shopping.cosmetics"]) {
        iconName = @"Cosmetics";
    } else if ([type containsString:@"restaurants.desserts"]) {
        iconName = @"Desserts";
    } else if ([type containsString:@"facility.restroom.disable"]) {
        iconName = @"Disable";
    } else if ([type containsString:@"shopping.electronics"]) {
        iconName = @"Electronics";
    } else if ([type containsString:@"facility.connector.elevator"]) {
        iconName = @"Elevator";
    } else if ([type containsString:@"facility.connector.escalator"]) {
        iconName = @"Escalator";
    } else if ([type containsString:@"facility.exhibit"]) {
        iconName = @"Exhibit";
    } else if ([type containsString:@"facility.gate"]) {
        iconName = @"Exit";
    } else if ([type containsString:@"facility.gate.fare_gate"]) {
        iconName = @"FareGate";
    } else if ([type containsString:@"facility.fitting_room"]) {
        iconName = @"FittingRoom";
    } else if ([type containsString:@"professional_services.financial_services.currency_exchange"]) {
        iconName = @"ForeignCurrencyExchange";
    } else if ([type containsString:@"workplace.function_room"]) {
        iconName = @"FunctionRoom";
    } else if ([type containsString:@"shopping.home_and_garden"]) {
        iconName = @"Furniture";
    } else if ([type containsString:@"arts_entertainment.galleries"]) {
        iconName = @"Galleries";
    } else if ([type containsString:@"sports_activities.gyms"]) {
        iconName = @"Gyms";
    } else if ([type containsString:@"facility.information"]) {
        iconName = @"Information";
    } else if ([type containsString:@"shopping.jewelry"]) {
        iconName = @"Jewelry";
    } else if ([type containsString:@"shopping.karaoke"]) {
        iconName = @"Karaoke";
    } else if ([type containsString:@"workplace.lab"]) {
        iconName = @"Lab";
    } else if ([type containsString:@"public_services_government.libraries"]) {
        iconName = @"Library";
    } else if ([type containsString:@"facility.lost_and_found"]) {
        iconName = @"LostAndFound";
    } else if ([type containsString:@"facility.mothersroom"]) {
        iconName = @"MothersRoom";
    } else if ([type containsString:@"shopping.opticians"]) {
        iconName = @"Opticians";
    } else if ([type containsString:@"facility.parking"]) {
        iconName = @"Parking";
    } else if ([type containsString:@"shopping.pet_store"]) {
        iconName = @"Petshop";
    } else if ([type containsString:@"health_medical.pharmacy"]) {
        iconName = @"Pharmacy";
    } else if ([type containsString:@"transport.train_platform"]) {
        iconName = @"Platform";
    } else if ([type containsString:@"facility.connector.ramp"]) {
        iconName = @"Ramp";
    } else if ([type containsString:@"workplace.reading_room"]) {
        iconName = @"ReadingRoom";
    } else if ([type containsString:@"facility.restroom.female"]) {
        iconName = @"RestroomFemale";
    } else if ([type containsString:@"facility.restroom.male"]) {
        iconName = @"RestroomMale";
    } else if ([type containsString:@"shopping.shoes"]) {
        iconName = @"Shoes";
    } else if ([type containsString:@"facility.smoking_area"]) {
        iconName = @"SmokingRoom";
    } else if ([type containsString:@"shopping.sport_goods"]) {
        iconName = @"Sportgoods";
    } else if ([type containsString:@"facility.connector.stairs"]) {
        iconName = @"Stairs";
    } else if ([type containsString:@"shopping.stationery"]) {
        iconName = @"Stationery";
    } else if ([type containsString:@"workplace.study_room"]) {
        iconName = @"StudyRoom";
    } else if ([type containsString:@"transport.taxi_stations"]) {
        iconName = @"TaxiStation";
    } else if ([type containsString:@"facility.ticketing"]) {
        iconName = @"Ticketing";
    } else if ([type containsString:@"shopping.toys"]) {
        iconName = @"Toys";
    } else if ([type containsString:@"facility.restroom.unisex"]) {
        iconName = @"Unisex";
    } else if ([type containsString:@"shopping.watches"]) {
        iconName = @"Watches";
    } else if ([type containsString:@"facility.wifi"]) {
        iconName = @"Wifi";
    } else if ([type containsString:@"workplace"]) {
        iconName = @"Workplace";
    } else if ([type containsString:@"arts_entertainment"]) {
        iconName = @"ArtsEntertainment";
    } else if ([type containsString:@"transport"]) {
        iconName = @"Transport";
    } else if ([type containsString:@"sports_activities"]) {
        iconName = @"SportsActivities";
    } else if ([type containsString:@"shopping"]) {
        iconName = @"Shopping";
    } else if ([type containsString:@"restaurants"]) {
        iconName = @"Restaurant";
    } else if ([type containsString:@"local_services"]) {
        iconName = @"LocalServices";
    } else if ([type containsString:@"health_medical"]) {
        iconName = @"HealthMedical";
    } else if ([type containsString:@"facility"]) {
        iconName = @"Facilities";
    } else if ([type containsString:@"automotive"]) {
        iconName = @"Automotive";
    } else if ([type containsString:@"beauty_spas"]) {
        iconName = @"Beauty";
    } else if ([type containsString:@"education"]) {
        iconName = @"Education";
    } else if ([type containsString:@"professional_services"]) {
        iconName = @"ProfessionalServices";
    } else if ([type containsString:@"public_services_government"]) {
        iconName = @"PublicServicesGovernment";
    } else {
        iconName = @"Others";
    }
    return [UIImage imageNamed:iconName];
}

@end
