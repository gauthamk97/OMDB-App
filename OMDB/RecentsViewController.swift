//
//  RecentsViewController.swift
//  OMDB
//
//  Created by Gautham Kumar on 16/04/17.
//  Copyright © 2017 Gautham Kumar. All rights reserved.
//

import UIKit

class RecentsViewController: UIViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Recent Movies"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let movieName: String = searchBar.text!
        let updatedMovieName = movieName.replacingOccurrences(of: " ", with: "+")
        let urlToHit = URL(string: "http://www.omdbapi.com/?t=\(updatedMovieName)&plot=full") //Route to hit
        var request = URLRequest(url: urlToHit!)
        request.httpMethod = "POST"
    
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            let httpStatus = response as? HTTPURLResponse
            
            if (error != nil) {
                if (httpStatus?.statusCode == nil) {
                    print("NO INTERNET")
                    //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nointernetforclusters"), object: nil)
                }
                else {
                    print("Error occured : \(error)")
                }
                return;
            }
                
            else if httpStatus?.statusCode != 200 {
                print("Error : HTTPStatusCode is \(httpStatus?.statusCode)")
                //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "servererror"), object: nil)
                return
            }
                
            else {
                let responseString = String(data: data!, encoding: .utf8)
                let jsonData = responseString?.data(using: .utf8)
                if let json = try? JSONSerialization.jsonObject(with: jsonData!) as! [String: Any] {
                    
                    if json["response"] as! String == "False" {
                        //Alert saying movie doesn't exist
                    }
                    
                    else {
                        print(json)
                    }
                    
                }
                
            }})
        
        task.resume()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
