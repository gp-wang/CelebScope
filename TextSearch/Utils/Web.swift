//
//  Web.swift
//  CelebScope
//
//  Created by Gaofei Wang on 2/3/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//


import Foundation
import UIKit

// gw: for image identification
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}



// gw: take classificationResult, see in the face.crop.success for usage example
// gw: 02032019: change to array
typealias classificationCompletionHandler = ([NSDictionary]) -> Void
typealias ocrCompletionHandler = (NSDictionary, UIImage) -> Void

typealias ocrCompletionResponseHandler = (String, GoogleCloudVisionApiResponses) -> Void


//    https://stackoverflow.com/questions/24603559/store-a-closure-as-a-variable-in-swift
//    var userCompletionHandler: (Any)->Void = {
//        (arg: Any) -> Void in
//    }



// pass in a reference of Viewcontroller to update cache dict
// TODO: is there better way?
func searchTextInImage(_ text: String, _ image: UIImage,  completionHandler: @escaping ocrCompletionResponseHandler, accessToken: String, cache: Cache ) { //gw: (!done)todo: fix this. error
    // server endpoint
    let endpoint = "https://vision.googleapis.com/v1/images:annotate"
    let endpointUrl = URL(string: endpoint)!
    
    var request = URLRequest(url: endpointUrl)
    request.httpMethod = "POST"
    
   
    
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    //"Authorization: Bearer "$(gcloud auth application-default print-access-token)
    //request.setValue("Bearer 02b18437e04ca4c531539129ab5d49d0983c9677", forHTTPHeaderField: "Authorization")
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

    guard let jpegImage = image.jpegData(compressionQuality: 1) else {
        fatalError("Could not retrieve person's photo")
    }
    



    
    request.httpBody = createOCRRequestBody(imageData: jpegImage)
    
    // gw: pass in the ref to the image for retring  (e.g. when access_token is invalid)
    fireOCRRequest(request, completionHandler, text, image, cache: cache)
}


// text: the string to search for
func fireOCRRequest(_ request: URLRequest, _ completionHandler: @escaping ocrCompletionResponseHandler, _ text: String, _ image: UIImage, cache: Cache) {
    // gw: completion handler: URL request
    //TODO: extract completion handlers
    URLSession.shared.dataTask(with: request){
        (data: Data?, response: URLResponse?, error: Error?) in
        
        
        //guard let data = data else { return }
        /* guard let outputStr  = String(data: data, encoding: String.Encoding.utf8) as String? else {
         fatalError("could not get classification result ")
         } */
        // gw_log(outputStr)
        
        do {
            
            if let error = error {
                print("dataTask response has error: \(error.localizedDescription)")
            } else {
                guard  let data = data,
                    let response = response as? HTTPURLResponse else {
                        fatalError("dataTask reports no error but could not cast data and response")
                }
                
                
                if response.statusCode != 200 {
                    
                } else {
                    
                    do {
                        gw_log("success getting google response")
                        let googleResponse = try JSONDecoder().decode(GoogleCloudVisionApiResponses.self, from: data)
                        cache.cachedResponses[image] = googleResponse
                        
                        completionHandler(text, googleResponse)
                    } catch let jsonErr {
                        print(jsonErr)
                    }
                    
                }
            }
            
            
            
            
            //completionHandler(data, response, error, text, image)
            //completionHandler(ocrClassification, image)
        } catch let error as NSError {
            gw_log(error.debugDescription)
        }
        
        
    }.resume()
}

func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}

/*
 sample body:
 
 {
 "requests": [
 {
 "image": {
 "content": "base64-encoded-image"
 },
 "features": [
 {
 "type": "TEXT_DETECTION"
 }
 ]
 }
 ]
 }
 */
func createOCRRequestBody(imageData: Data) -> Data {
    
    
    
    
    
    var messageDictionary : [String: Any] = [ "requests":
        [
            [
                "image":
                    ["content" : imageData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)],
                "features":
                    [
                        ["type": "DOCUMENT_TEXT_DETECTION"]
                    ]
            ],
        ]
    ]
     let jsonDataOpt = try? JSONSerialization.data(withJSONObject: messageDictionary, options: [])
    
    
    guard let jsonData = jsonDataOpt else {
        fatalError("Cannot convert image to jsonData in createOCRRequestBody")
    }
    //let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
    //print (jsonString)

    
    
    return jsonData
}