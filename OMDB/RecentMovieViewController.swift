//
//  RecentMovieViewController.swift
//  OMDB
//
//  Created by Gautham Kumar on 16/04/17.
//  Copyright © 2017 Gautham Kumar. All rights reserved.
//

import UIKit

class RecentMovieViewController: UIViewController {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var relLabel: UILabel!
    @IBOutlet weak var runningTimeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var plotTextView: UITextView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.title = "Movie Details"
            self.movieNameLabel.text = selectedMovie["Title"] as? String
            self.relLabel.text = selectedMovie["Released"] as? String
            self.runningTimeLabel.text = selectedMovie["Runtime"] as? String
            self.genreLabel.text = selectedMovie["Genre"] as? String
            self.directorLabel.text = selectedMovie["Director"] as? String
            self.actorsLabel.text = selectedMovie["Actors"] as? String
            self.ratingLabel.text = selectedMovie["imdbRating"] as? String
            self.plotTextView.text = selectedMovie["Plot"] as? String
            
            //Obtain Image
            if let checkedURL = URL(string: selectedMovie["Poster"] as! String) {
                let imageData = NSData(contentsOf: checkedURL)
                self.posterImageView.image = UIImage(data: imageData as! Data)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
