//
//  Web.swift
//  CelebScope
//
//  Created by Gaofei Wang on 2/3/19.
//  Copyright © 2019 Gaofei Wang. All rights reserved.
//


import Foundation
import FaceCropper

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

typealias ocrCompletionResponseHandler = (Data?, URLResponse?, Error?, String, UIImage) -> Void


//    https://stackoverflow.com/questions/24603559/store-a-closure-as-a-variable-in-swift
//    var userCompletionHandler: (Any)->Void = {
//        (arg: Any) -> Void in
//    }

// completionHandler: the handler to pass down, it is supplied at the top entry point of the nested handler call
func identifyFaces(_ faces: [Face],  completionHandler: @escaping classificationCompletionHandler ) { //gw: (!done)todo: fix this. error
    // server endpoint
    let endpoint = "https://vision.googleapis.com/v1/images:annotate"
    let endpointUrl = URL(string: endpoint)!
    
    var request = URLRequest(url: endpointUrl)
    request.httpMethod = "POST"
    
    let boundary = generateBoundaryString()
    
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    let jpegDataImages = faces.map({ (face: Face) -> Data in
        guard let jpegImage = UIImage(cgImage: face.image).jpegData(compressionQuality: 1) else {
            fatalError("Could not retrieve person's photo")
        }
        
        return jpegImage
    })
    
    request.httpBody = createBodyWithParameters(parameters: nil, filePathKey: "images[]", dataItems: jpegDataImages, boundary: boundary) as Data
    
    
    fireClassificationRequest(request, completionHandler)
}


func searchTextInImage(_ text: String, _ image: UIImage,  completionHandler: @escaping ocrCompletionResponseHandler, accessToken: String ) { //gw: (!done)todo: fix this. error
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
    fireOCRRequest(request, completionHandler, text, image)
}


func fireClassificationRequest(_ request: URLRequest, _ completionHandler: @escaping classificationCompletionHandler) {
    // gw: completion handler: URL request
    //TODO: extract completion handlers
    URLSession.shared.dataTask(with: request){
        (data: Data?, response: URLResponse?, error: Error?) in
        
        
        guard let data = data else { return }
        guard let outputStr  = String(data: data, encoding: String.Encoding.utf8) as String? else {
            fatalError("could not get classification result ")
        }
        // gw_log(outputStr)
        
        do {
            
            guard let peopleClassification = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] else {
                fatalError("could not parse result as json")
            }
            
            completionHandler(peopleClassification)
        } catch let error as NSError {
            gw_log(error.debugDescription)
        }
        
        
        }.resume()
}

// text: the string to search for
func fireOCRRequest(_ request: URLRequest, _ completionHandler: @escaping ocrCompletionResponseHandler, _ text: String, _ image: UIImage) {
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
            
           
            
            completionHandler(data, response, error, text, image)
            //completionHandler(ocrClassification, image)
        } catch let error as NSError {
            gw_log(error.debugDescription)
        }
        
        
        }.resume()
}

func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}



func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, dataItems: [Data], boundary: String) -> NSData {
    
    
    let body = NSMutableData();
    
    if parameters != nil {
        for (key, value) in parameters! {
            body.appendString(string:"--\(boundary)\r\n")
            body.appendString(string:"Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string:"\(value)\r\n")
        }
    }
    
    let mimetype = "image/jpg"
    
    
    // boundary notes:
    
    // boundary #1
    //  image #1
    // bondary #2
    // image #2
    //    .... (one boundary before each image)
    
    // boundary in the very end of all images (last)
    
    for (idx, item) in dataItems.enumerated() {
        body.appendString(string:"--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(idx).jpg\"\r\n")  //TODO: might not work, then need to research how to upload a (variable) list of files/photos, https://stackoverflow.com/a/26639822/8328365
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(item)
        body.appendString(string: "\r\n")
    }
    
    body.appendString(string: "--\(boundary)--\r\n")
    
    
    return body
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
