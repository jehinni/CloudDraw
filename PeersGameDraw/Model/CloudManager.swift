//
//  CloudManager.swift
//  Draw
//
//  Created by Johanna Reiting on 24.07.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit

class CloudManager {
	var cloudManagerDelegate: CloudManagerDelegate?
	
    func send (label: String, bitmap: [[UInt8]]) {
        let params =  [ "label": label, "image": bitmap] as [String : Any]
		
		var request = URLRequest(url: URL(string: "https://us-central1-cloud-computing-247314.cloudfunctions.net/classifier")!)
		request.httpMethod = "POST"
		request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		let session = URLSession.shared
		let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
			print(response!)
			do {
				let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
				print(json)
				self.cloudManagerDelegate?.didReceive(prediction: json)
			} catch {
				print("error")
			}
		})
		
		task.resume()
	}
}
