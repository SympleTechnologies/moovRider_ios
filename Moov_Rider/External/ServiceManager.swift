//
//  ServiceManager.swift
//  Glimpsters
//
//  Created by Albin Kurian on 06/06/17.
//  Copyright © 2017 Albin Kurian. All rights reserved.
//

import UIKit

class ServiceManager: NSObject {
    
    func getBaseUrl() -> String {
        return kBaseUrl
    }
    
    func get(withServiceName serviceName: String!, andParameter parameters: Parameters?, withHud isHud: Bool, completion:@escaping (Bool?, AnyObject?, NSError?) -> Void) {
        if isHud {
            HUD.show(.progress)
        }
        request(getBaseUrl()+serviceName, method: .get, parameters: parameters , encoding: JSONEncoding.default).responseJSON { (response) in
            if isHud {
                HUD.hide()
            }
            if let result = response.result.value {
                completion(true, result as AnyObject, nil)
            }else {
                completion(false, nil, response.error! as NSError)
            }
        }
    }
    
    func post(withServiceName serviceName: String!, andParameters parameters: Parameters?,  withHud isHud: Bool, completion:@escaping (Bool?, AnyObject?, NSError?) -> Void) {
        if isHud {
            HUD.show(.progress)
        }
        request(getBaseUrl()+serviceName!, method: .post, parameters: parameters , encoding: URLEncoding.httpBody).responseJSON { (response) in
            if isHud {
                HUD.hide()
            }
            if let result = response.result.value {
                completion(true, result as AnyObject, nil)
            }else {
                completion(false, nil, response.error! as NSError)
            }
        }
    }
    
    func uploadImage(withServiceName serviceName: String!, imageData image: Data, withName name: String, andParameters parameters: Parameters?,  withHud isHud: Bool, completion:@escaping(Bool?, AnyObject?, NSError?) -> Void){
        if isHud {
            HUD.show(.progress)
        }
        upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(image, withName: name, fileName: "image.jpeg", mimeType: "image/jpeg")
            if parameters != nil {
                for (key, value) in parameters! {
                    multipartFormData.append((value as! String).data(using: .utf8)! , withName: key)
                }
            }
            
        }, to: getBaseUrl()+serviceName) { (encodingResult) in
            if isHud {
                HUD.hide()
            }
            switch encodingResult {
            case .success(request: let request, _, _) :
                if isHud {
                    HUD.show(.progress)
                }
                request.responseJSON(completionHandler: { (response) in
                    if isHud {
                        HUD.hide()
                    }
                    completion(true, response.result.value as AnyObject, nil)
                })
                break
            case .failure(let error) :
                completion(false, nil, error as NSError)
                break
            }
        }
    }
    
    func uploadMultipleData(withServiceName serviceName: String!, multiDatas datas: [Data], withNames names: [String], mineTypes: [String], fileNames: [String], andParameters parameters: Parameters?,  withHud isHud: Bool, completion:@escaping(Bool?, AnyObject?, NSError?) -> Void){
        if isHud {
            HUD.show(.progress)
        }
        upload(multipartFormData: { (multipartFormData) in
            for (index, element) in datas.enumerated() {
                multipartFormData.append(element, withName: names[index], fileName: fileNames[index], mimeType: mineTypes[index])
            }
            if parameters != nil {
                for (key, value) in parameters! {
                    multipartFormData.append(("\(value)").data(using: .utf8)!, withName: key)
                }
            }
        }, to: getBaseUrl()+serviceName) { (encodingResult) in
            if isHud {
                HUD.hide()
            }
            switch encodingResult {
            case .success(request: let request, _, _) :
                if isHud {
                    HUD.show(.progress)
                }
                request.responseJSON(completionHandler: { (response) in
                    if isHud {
                        HUD.hide()
                    }
                    completion(true, response.result.value as AnyObject, nil)
                })
                break
            case .failure(let error) :
                completion(false, nil, error as NSError)
                break
            }
        }
    }
}
