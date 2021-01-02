//
//  DemoUtility.swift
//  DJISDKSwiftDemo
//
//  Created by Macbook on 25/12/2020.
//  Copyright © 2020 DJI. All rights reserved.
//

import DJISDK
import UIKit


class DemoUtility {
    
    class func fetchProduct() -> DJIBaseProduct? {
        return DJISDKManager.product()
    }

    class func fetchAircraft() -> DJIAircraft? {
        if !(DJISDKManager.product() != nil) {
            return nil
        }

        if DJISDKManager.product() is DJIAircraft {
            return DJISDKManager.product() as? DJIAircraft
        }

        return nil
    }

    class func fetchCamera() -> DJICamera? {
        if !(DJISDKManager.product() != nil) {
            return nil
        }

        if DJISDKManager.product() is DJIAircraft {
            return (DJISDKManager.product() as? DJIAircraft)?.camera
        } else if DJISDKManager.product() is DJIHandheld {
            return (DJISDKManager.product() as? DJIHandheld)?.camera
        }

        return nil
    }
    class func fetchFlightController() -> DJIFlightController? {
        if !(DJISDKManager.product() != nil) {
            return nil
        }
        if DJISDKManager.product() is DJIAircraft {
            return (DJISDKManager.product() as? DJIAircraft)?.flightController
        }
        return nil
    }
}
