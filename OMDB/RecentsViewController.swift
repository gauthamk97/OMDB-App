//
//  RecentsViewController.swift
//  OMDB
//
//  Created by Gautham Kumar on 16/04/17.
//  Copyright © 2017 Gautham Kumar. All rights reserved.
//

import UIKit

class RecentsViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var recentMoviesTable: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Recent Movies"
        
        recentMoviesTable.delegate = self
        recentMoviesTable.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        
    }

    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        DispatchQueue.main.async {
            
            //Deactivates loading indicator
            self.loadingIndicator.stopAnimating()
            
            //Reloads table data
            self.recentMoviesTable.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentMoviesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentMovieCell")
        
        cell?.textLabel?.text = recentMovies[indexPath.row]["title"]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = recentMovieData[indexPath.row]
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toMovieInfo", sender: self)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let movieName: String = searchBar.text!
        let updatedMovieName = movieName.replacingOccurrences(of: " ", with: "+") //For API Call
        
        //Activates loading indicator
        loadingIndicator.startAnimating()
        
        let urlToHit = URL(string: "http://www.omdbapi.com/?t=\(updatedMovieName)&plot=full") //Route to hit
        var request = URLRequest(url: urlToHit!)
        request.httpMethod = "POST"
        
        //Hiding keyboard
        searchBar.resignFirstResponder()
    
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            let httpStatus = response as? HTTPURLResponse
            
            if (error != nil) {
                if (httpStatus?.statusCode == nil) {
                    print("NO INTERNET")
                }
                else {
                    print("Error occured : \(error)")
                }
                return;
            }
                
            else if httpStatus?.statusCode != 200 {
                print("Error : HTTPStatusCode is \(httpStatus?.statusCode)")
                return
            }
                
            else {
                let responseString = String(data: data!, encoding: .utf8)
                let jsonData = responseString?.data(using: .utf8)
                if let json = try? JSONSerialization.jsonObject(with: jsonData!) as! [String: Any] {
                    
                    if json["Response"] as! String == "False" {
                        //Alert saying movie doesn't exist
                    }
                    
                    else {
                        selectedMovie = json
                        print(selectedMovie)
                        
                        //Takes care of duplicate records
                        var i=0
                        for movie in recentMovies {
                            if movie["imdbID"]! == selectedMovie["imdbID"] as! String {
                                recentMovies.remove(at: i)
                                recentMovieData.remove(at: i)
                                recentMoviesCount-=1
                                i-=1
                            }
                            i+=1
                        }
                        
                        recentMovies.insert(["title":(json["Title"] as! String?)!, "imdbID":(json["imdbID"] as! String?)!], at: 0)
                        recentMovieData.insert(json, at: 0)
                        recentMoviesCount+=1
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "toMovieInfo", sender: self)
                        }
                        
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
