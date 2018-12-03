//
//  AlamofireSubClass.swift
//  Namaste
//
//  Created by Srishti on 23/11/17.
//  Copyright © 2017 Srishti. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices

var _alomofile : AlamofireSubclass?

class AlamofireSubclass: NSObject {
    
    var serverUrl:String = "http://themoovapp.com/api/v2/"
    
    class func currentAlamofire() -> AlamofireSubclass {
        if (_alomofile == nil) {
            _alomofile = AlamofireSubclass()
        }
        return _alomofile!
    }
    
    //MARK:- GET METHOD
    class func parseLinkUsingGetMethod(_ url : String, completion : @escaping (Bool,AnyObject?,NSError?) -> Void){
        /*let extractedExpr = request("\(AlamofireSubclass.currentAlamofire().serverUrl)"+"\(url)", method: .get, parameters: nil , encoding: JSONEncoding.default)
        extractedExpr.responseJSON { (response) in
            
            if let result = response.result.value {
                completion(true, result as AnyObject, nil)
            }else {
                completion(false, nil, response.error! as NSError)
            }
        }*/
        
        
      request("\(AlamofireSubclass.currentAlamofire().serverUrl)"+"\(url)")
            .responseString { response in
                switch response.result {
                case .success( _):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? NSDictionary {
                        completion(true, json as AnyObject , nil)
                        }
                    }catch {
                         completion(false, nil, error as NSError)
                    }
                   // completion(true, response.result.value! as AnyObject , nil)
                case .failure(let error):
                    completion(false, nil, error as NSError)
                }
        }
    }
    
    //MARK:- POST METHODS
    
    class func parseLinkUsingPostMethod(_ serviceName : String, with dictionary : NSDictionary, completion : @escaping (Bool, AnyObject?, NSError?) -> Void) {
        upload(multipartFormData: { (multipartFormData) in
            for (key, value) in dictionary {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
        }, to:"\(AlamofireSubclass.currentAlamofire().serverUrl)"+"\(serviceName)")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    if response.error == nil {
                        completion(true, response.result.value as AnyObject , nil)
                    }else {
                        completion(false, response.result.value as AnyObject, response.error! as NSError)
                    }
                }
            case .failure(let encodingError):
                completion(false, nil, encodingError as NSError)
            }
        }
    }
    class func parseStaticLinkUsingPostMethod(_ serviceName : String, with dictionary : NSDictionary, completion : @escaping (Bool, AnyObject?, NSError?) -> Void) {
        upload(multipartFormData: { (multipartFormData) in
            for (key, value) in dictionary {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
        }, to:"http://88.208.249.235/ouryesterday.com/index/login_api")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    if response.error == nil {
                        completion(true, response.result.value as AnyObject , nil)
                    }else {
                        completion(false, response.result.value as AnyObject, response.error! as NSError)
                    }
                }
            case .failure(let encodingError):
                completion(false, nil, encodingError as NSError)
            }
        }
    }
    
    class func parseLinkUsingPostMethod(_ serviceName : String, with dictionary : NSDictionary,imagedata:Data,imageKey:String, completion : @escaping (Bool, AnyObject?, NSError?) -> Void) {
        upload(multipartFormData: { (multipartFormData) in
            if imageKey != "" {
                multipartFormData.append(imagedata, withName: imageKey, fileName:makeFileName(type: "image/jpeg"), mimeType: "image/jpeg")
            }
            for (key, value) in dictionary {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
        }, to:"\(AlamofireSubclass.currentAlamofire().serverUrl)"+"\(serviceName)")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    if response.error == nil{
                        completion(true, response.result.value as AnyObject , nil)
                    }else
                    {
                        completion(false, response.result.value as AnyObject, response.error! as NSError)
                    }
                }
            case .failure(let encodingError):
                completion(false, nil, encodingError as NSError)
            }
        }
    }
    
    class func parseLinkUsingImagePostMethod(_ serviceName : String, with dictionary : NSDictionary,imageArray:NSMutableArray, completion : @escaping (Bool, AnyObject?, NSError?) -> Void) {
        upload(multipartFormData: { (multipartFormData) in
                for (idx,dict) in imageArray.enumerated() {
                    let dictO = dict as! NSDictionary
                    let key : String!
                    if idx == 0 {
                        key = "userfile1"
                    }else if idx == 1 {
                        key = "userfile2"
                    }else {
                        key = "userfile3"
                    }
                    
                    let arr = (dictO["imageName"] as! String).components(separatedBy: ".")
                    let extenstion = arr.last?.lowercased()
                    multipartFormData.append(UIImageJPEGRepresentation(dictO["image"] as! UIImage, 0.8)!, withName: key, fileName:dictO["imageName"] as! String, mimeType: "image/\(String(describing: extenstion!))")
           }
            for (key, value) in dictionary {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
        }, to:"\(AlamofireSubclass.currentAlamofire().serverUrl)"+"\(serviceName)")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    if response.error == nil{
                        completion(true, response.result.value as AnyObject , nil)
                    }else
                    {
                        completion(false, response.result.value as AnyObject, response.error! as NSError)
                    }
                }
            case .failure(let encodingError):
                completion(false, nil, encodingError as NSError)
            }
        }
    }
    
    class func postMethodforArray(_ serviceName : String, with dictionary : NSDictionary,imagedata:[UIImage],filename:String, completion : @escaping (Bool, AnyObject?, NSError?) -> Void) {
        upload(multipartFormData: { (multipartFormData) in
            if filename != "" {
                for img in imagedata {
                    multipartFormData.append(UIImageJPEGRepresentation(img, 0.5)!, withName: "\(filename)[]", fileName: self.makeFileName(type: "image/jpeg"), mimeType: "image/jpeg")
                }
            }
            for (key, value) in dictionary {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
        }, to:"\(AlamofireSubclass.currentAlamofire().serverUrl)"+"\(serviceName)")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    if response.error == nil{
                        completion(true, response.result.value as AnyObject , nil)
                    }else
                    {
                        completion(false, response.result.value as AnyObject, response.error! as NSError)
                    }
                }
            case .failure(let encodingError):
                completion(false, nil, encodingError as NSError)
            }
        }
        
    }
    
    class func parseVideoLinkUsingPostMethod(_ serviceName : String, with dictionary : NSDictionary,imagedata:Data,filename:String, completion : @escaping (Bool, AnyObject?, NSError?) -> Void) {
        upload(multipartFormData: { (multipartFormData) in
            if filename != ""
            {
                multipartFormData.append(imagedata, withName: "video-filename", fileName:"mp4", mimeType: "video/mp4")
            }
            for (key, value) in dictionary {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
        }, to:"\(AlamofireSubclass.currentAlamofire().serverUrl)"+"\(serviceName)")
        { (result) in
            switch result {
            case .success(let upload, _ , _):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                })
                upload.responseJSON { response in
                    if response.error == nil{
                        completion(true, response.result.value as AnyObject , nil)
                    }else {
                        //  SVProgressHUD.showError(withStatus: "Please check your internet connection and try again" )
                        completion(false, response.result.value as AnyObject, response.error! as NSError)
                    }
                }
            case .failure(let encodingError):
                //SVProgressHUD.showError(withStatus: "Please check your internet connection and try again" )
                completion(false, nil, encodingError as NSError)
            }
        }
        
    }
    
    class func parseAudioLinkUsingPostMethod(_ serviceName : String, with dictionary : NSDictionary,audioData:Data,filename:String, completion : @escaping (Bool, AnyObject?, NSError?) -> Void) {
        upload(multipartFormData: { (multipartFormData) in
            if filename != ""
            {
                multipartFormData.append(audioData, withName: "userfile", fileName:filename, mimeType: "audio/mpeg")
            }
            for (key, value) in dictionary {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
        }, to:"\(AlamofireSubclass.currentAlamofire().serverUrl)"+"\(serviceName)")
        { (result) in
            switch result {
            case .success(let upload, _ , _):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                })
                upload.responseJSON { response in
                    if response.error == nil{
                        completion(true, response.result.value as AnyObject , nil)
                    }else {
                        //  SVProgressHUD.showError(withStatus: "Please check your internet connection and try again" )
                        completion(false, response.result.value as AnyObject, response.error! as NSError)
                    }
                }
            case .failure(let encodingError):
                //SVProgressHUD.showError(withStatus: "Please check your internet connection and try again" )
                completion(false, nil, encodingError as NSError)
            }
        }
        
    }

    //MARK:- Make File Name
    class func makeFileName(type:String) ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmmssSSS"
        let filename = dateFormatter.string(from: Date()) as String
        if type == kUTTypeMovie as String {
            return "\(filename).mp4"
        }else if type == "audio/mpeg" {
            return "\(filename).m4a"
        }else {
            return "\(filename).jpg"
        }
    }
}
