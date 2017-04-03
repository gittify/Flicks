//
//  MovieDetailsViewController.swift
//  Flicks
//
//  Created by Doshi, Nehal on 4/1/17.
//  Copyright © 2017 Doshi, Nehal. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var movieImageVIew: UIImageView!
    
    @IBOutlet weak var movieDesc: UILabel!
    var imageURL = ""
    var movie_title = ""
    var movie_desc = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if imageURL != "" {
            let imageUrl = URL(string: imageURL)!
            movieImageVIew.setImageWith(imageUrl)
            
            movieDesc.text = movie_title  + "\n" +  movie_desc
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